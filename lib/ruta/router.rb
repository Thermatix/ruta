# matches routes to a handeler
module Ruta

  class Router


    # TODO: ensure sub-context routes are mounted into parent context routes
    attr_accessor :current_context, :routes
    def initialize block
      @current_context = []
      @routes = {}
      instance_exec &block
    end

    def for_context context
      @current_context << context
      yield
      @current_context.pop
    end

    def get_context
      @current_context.last || :no_context
    end

    def map ref,route, options={}
      context = Context.collection[get_context]
      context.routes[ref]= Route.new(route, context,options)
    end

    def root_to context
      Router.set_root_to context
    end



    class << self
      attr_reader :current_context, :history, :window, :root

      def define &block
        new block
      end

      def set_root_to context
        @root = context
        Router.set_context_to root
      end

      def set_context_to context
        @current_context = context
      end

      def get_fragment
        window.location.fragment
      end

      def get_query
        window.location.query
      end

      def get_current_path
        window.location.path
      end

      def data params
        if params.first.class == Hash
          params.shift
        else
          {}
        end
      end

      def route_for context, ref,params=nil
        puts "context(#{context}):"
        puts Context.collection[context]
        puts "routes(#{ref}):"
        puts Context.collection[context].routes
        Context.collection[context].routes[ref].get(params)
      end

      def current_uri
       window.location.uri
      end
      private
      def find attr, element

      end
    end

    @window = Browser::Window.new
    # puts `self["native"]`
    # puts `self["native"].history`
    # @history = window.history

  end
end
