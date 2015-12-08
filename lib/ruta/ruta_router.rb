# matches routes to a handeler
module Ruta

  class Router
    # TODO: ensure sub-context routes are mounted into parent context routes
    # re-build route matching
    attr_accessor :current_context, :inital_context, :routes
    def initialize &block
      @current_context = []
      @routes = {}
      instance_exec &block
    end

    def for_context context
      @current_context << context
      yield
      @current_context.pop
    end

    def map key,route, options={}
      Routes.add(ref,route,@current_context || [:no_context] ,options)
    end

    def root context
      Router.set_initial context
    end


    class << self
      attr_reader :current_context,  :history

      def define &block
        new &block
      end

      def set_initial context
        @current_context context
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
        params ? Routes.get_and_paramaterize ref,*params : Routes.get ref
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
            url = match.shift
            [Context.collection[@current_context].handlers[route[:handle]]].flatten.(&:call, match,url)
          end
        end
      end

    end

  end
end
