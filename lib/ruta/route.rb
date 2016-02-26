module Ruta
  # this class was taken from vienna and modified
  # https://github.com/opal/vienna/blob/master/opal/vienna/router.rb#L42
  class Route
    DOM = ::Kernel.method(:DOM)
    NAMED = /:(\w+)/

    SPLAT = /\\\*(\w+)/

    OPTIONAL = /\\\((.*?)\\\)/

    # @!attribute [r] regexp
    # @return [Symbol] the regexp used to match against a route
    # @!attribute [r] named
    # @return [Symbol] list of all named paramters
    # @!attribute [r] type
    # @return [Symbol] the type of the route's handler
    # @!attribute [r] handlers
    # @return [Symbol] a list of the handlers this route is suposed to execute
    # @!attribute [r] url
    # @return [Symbol] the raw url to match against
    # @!attribute [r] flags
    # @return [Symbol] any flags this route possesses

     attr_reader :regexp, :named, :type, :handlers, :url,:flags

    # @param [String] pattern of url to match against
    # @param [Symbol] context_ref to context route is mounted to
    # @param [{Symbol => String,Number,Boolean}] flags attached to route
    def initialize(pattern, context_ref,flags)

     if flags[:to]
       @type = :handlers
       @handlers = [flags.delete(:to)].flatten
     elsif flags[:context]
       @type = :context
       @handlers = flags.delete :context
     else
       @type = :ref_only
     end
     @context_ref = context_ref
     @flags = flags
     @url = pattern
     @named = []

     pattern = Regexp.escape pattern
     pattern = pattern.gsub OPTIONAL, "(?:$1)?"

     pattern.gsub(NAMED) { |m| @named << m[1..-1] }
     pattern.gsub(SPLAT) { |m| @named << m[2..-1] }

     pattern = pattern.gsub NAMED, "([^\\/]*)"
     pattern = pattern.gsub SPLAT, "(.*?)"

     @regexp = Regexp.new "^#{pattern}$"

    end

    #take in params and return a paramaterized route
    #
    # @param [Array<String,Number,Boolean>] params a list of params to replace named params in a route
    # @return [String] url containing named params replaced
    def paramaterize params
     segments = @url.split('/')
     segments.map { |item| item[0] == ':' ? params.shift : item }.join('/')
    end

    # get route hash and paramaterize url if needed
    #
    # @param [Array<String,Number,Boolean>] params to replace named params in the returned url
    # @return [Symbol => Number,String,Route] hash specificly formatted:
    #  {
    #    url: of the route with named params replaced,
    #    title: the name of page if the url has one,
    #    params: a list of all the params used in the route,
    #    route: the #Route object
    #  }
    def get params=nil
     path = if params
       paramaterize params.dup
     else
       @url
     end
     {
         path: path,
         title: self.flags.fetch(:title){nil},
         params: params_hash(params),
         route: self
     }
    end

    # match this route against a given path
    #
    # @param [String,Regex] path to match against
    # @return [Hash,false] (see #get) or false if there is no match
    def match(path)
       if match = @regexp.match(path)
         params = {}
         @named.each_with_index { |name, i| params[name] = match[i + 1] } if @type == :handlers
         {
             path: path,
             title: self.flags.fetch(:title){nil},
             params: params,
             route: self
         }
       else
         false
       end
    end

    # execute's route's associated handlers
    #
    # @param [Symbol => String] params from the route with there respective keys
    # @param [String] path containing params placed into there respective named positions
    def execute_handler params={},path=nil
     case @type
     when :handlers
       @handlers.each do |handler_ident|
         handler = @context_ref.handlers.fetch(handler_ident) {raise "handler #{handler_ident} doesn't exist in context #{@context_ref.ref}"}
         component = handler.(params,path||@url,&:call)
         Context.current_context = @context_ref.ref
         if component.class == Proc
           component.call
         else
           Context.renderer.call(component,handler_ident)
         end
         Context.current_context = :no_context
       end
     when :context
       Context.wipe
       Context.render handlers
     end
    end

    def params_hash(params)
      Hash[@named.zip(params)]
    end
  end
end
