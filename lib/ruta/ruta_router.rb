# matches routes to a handeler
module Ruta
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

      def navigate_to path
        
      end

      def current_uri
       Window.location.uri
      end

      private
      def get_handler_for fragment
        Routes.collection[current_context].each do |ref,route|
          # match = `#{fragment}.match(#{route[:re]})`
          match = fragment.match(route[:re])
          if match
            url = match.shift
            Context.collection[@current_context].handlers[route[:handle]].call(match,url)
          end
        end
      end

    end

  end
end
