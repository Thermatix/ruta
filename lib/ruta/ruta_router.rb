# matches routes to a handeler
module Ruta
  
  class << self
    def get_url_for ref, *params
      Router.route ref,params
    end

    def navigate_to ref,*params
      d = Router.data(params)
      r = Router.route(ref,params)
      History.add_to_history r[:path], r[:flags][:page_name],d
      Router.get_handler_for get_fragment
    end
  end

  class Router
    class << self
      attr_reader :current_context,  :history

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

      def get_handler_for fragment
        Routes.collection[current_context].each do |ref,route|
          # match = `#{fragment}.match(#{route[:re]})`
          match = fragment.match route[:re]
          if match
            url = match.shift
            Context.collection[@current_context].handlers[route[:handle]].call match,url
          end
        end
      end

    end

  end
end
