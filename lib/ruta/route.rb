module Ruta
  # this class was taken from vienna and modified
  # https://github.com/opal/vienna/blob/master/opal/vienna/router.rb#L42
  class Route
    DOM = ::Kernel.method(:DOM)
    NAMED = /:(\w+)/

    SPLAT = /\\\*(\w+)/

    OPTIONAL = /\\\((.*?)\\\)/

     attr_reader :regexp, :named, :type, :handlers, :url,:flags, :param_keys

     def initialize(pattern, context_ref,flags)

       if flags[:to]
         @type = :handlers
         @handlers = [flags.delete :to].flatten
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


       @param_keys = @url.split('/').select {|e| e[0] == ':' }.map {|e| e.gsub(/.{1}(.*)/,'\1')}
       pattern = Regexp.escape pattern
       pattern = pattern.gsub OPTIONAL, "(?:$1)?"

       pattern.gsub(NAMED) { |m| @named << m[1..-1] }
       pattern.gsub(SPLAT) { |m| @named << m[2..-1] }

       pattern = pattern.gsub NAMED, "([^\\/]*)"
       pattern = pattern.gsub SPLAT, "(.*?)"

       @regexp = Regexp.new "^#{pattern}$"
     end

     def paramaterize params
       segments = @url.split('/')
       '/' + segments.map { |item| item[0] == ':' ? params.shift : item }.join('/') + '/'
     end

     def get ref, params=nil
       path = if params
         paramaterize params
       else
         @url
       end
       {
           url: path,
           page_name: self.flags.fetch(:page_name){nil},
           route: self
       }
     end

     def match(path,current_context)
       if match = @regexp.match(path)
         params = {}
         @named.each_with_index { |name, i| params[name] = match[i + 1] } if @type == :handlers
         {
             url: path,
             page_name: self.flags.fetch(:page_name),
             params: params,
             route: self
         }
       end
       false
     end

     def execute_handler params={},path=nil
       case @type
       when :handlers
         puts "mounted at: #{@context_ref.ref}"
         @handlers.each do |handler_ident|
           handler = @context_ref.handlers.fetch(handler_ident) {raise "handler #{handler_ident} doesn't exist in context #{@context_ref.ref}"}
           Context.wipe handler_ident
           puts handler_ident
           component = handler.(Hash[@param_keys.zip(params)],path||@url,&:call)
          #  puts component.instance_variable_get(:@native)
          #  component.append_to($document[handler_ident])
           Context.renderer.call(component,handler_ident)
         end
       when :context
         Context.wipe
         Context.render handlers
       end
     end

  end
end
