# matches routes to a handeler
module Ruta

  class Router


    # TODO: ensure sub-context routes are mounted into parent context routes
    attr_accessor :current_context, :inital_context, :routes
    def initialize block
      @current_context = []
      @routes = {}
      puts block
      instance_exec &block
    end

    def for_context context
      @current_context << context
      yield
      @current_context.pop
    end

    def map ref,route, options={}
      puts "mapping #{route} to #{ref}"
      Routes.add(ref,route,@current_context || [:no_context] ,options)
    end

    def root_to context
      puts "setting root to: #{context}"
      Router.set_context_to context
    end


    class << self
      attr_reader :current_context,  :history

      def define &block
        puts 'defining a router'
        new &block
      end

      def set_context_to context
        puts "setting context to: #{context}"
        @current_context = context
      end

      def get_fragment
        Window.location.fragment
      end

      def get_query
        Window.location.query
      end

      def get_current_path
        Window.location.path
      end

      def data params
        if params.first.class == Hash
          params.shift
        else
          {}
        end
      end

      def route ref,params
        params ? Routes.get_and_paramaterize(ref,*params) : Routes.get(ref)
      end

      def current_uri
       Window.location.uri
      end
      # TODO need to see if this works, a it's based on pure JS
      def get_handler_for fragment
        Routes.collection[current_context].each do |ref,route|
          # match = `#{fragment}.match(#{route[:re]})`
          match = fragment.match route[:re]
          if match
            if route[:handle]
            url = match.shift
            [Context.collection[@current_context].handlers[route[:handle]]].flatten.(match,url,&:call)
            elsif route[:context]
              Context.wipe
              Context.render(route[:Context])
            else
              raise "trying to render non rendarable route(#{ref}) for fragment(#{fragment})"
            end
          end
        end
      end


    end

  end
end
