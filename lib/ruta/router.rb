# matches routes to a handeler
module Ruta

  class Router




    # @!attribute [r,w] current_context
    # @return [Array<Symbol>] current_context a list of contexts, the last being the current

    attr_accessor :current_context

    # @see (see #Router#define)
    def initialize block
      @current_context = []
      Context.define(:no_context)
      instance_exec(&block)
    end

    # set which Context to map the following routes to
    #
    # @param [Symbol] context to map routes to
    def for_context context
      @current_context << context
      yield
      @current_context.pop
    end

    #  map a route
    # @param [Symbol] ref to map route to for easy future reference
    def map ref,route, options={}
      context = Context.collection[get_context]
      context.routes[ref]= Route.new(route, context,options)
    end

    # set the root context, this is the initial context that will be renered by the router
    #
    # @note there is only ever one root, calling this multiple times will over right the original root
    # @param [Symbol] reference to context
    def root_to reference
      Router.set_root_to reference
      context = Context.collection[reference]
      context.routes[:root]= Route.new('/', context,{ context: reference})
    end

    private

    def get_context
      @current_context.last || :no_context
    end

    class << self

      # @!attribute [r] current_context
      # @return [Array<Symbol>] current_context the current context that the user is in

      # @!attribute [r] history
      # @return [Array<Symbol>] history

      # @!attribute [r] window
      # @return [Array<Symbol>] window

      # @!attribute [r] root
      # @return [Array<Symbol>] root the initial context of the app

      attr_reader :current_context, :root

      # define a router, this can be called multiple times
      # @example defining routes
      #   Ruta::Router.define do
      #     for_context :main do
      #       for_context :info_view do
      #         map :i_switch, '/buttons/:switch_to', to: [:scroller,:buttons]
      #         map :sign_up, '/sign_up', context: :sign_up
      #       end
      #     end
      #
      #     root_to :main
      #   end
      # @note please be aware that placing contexts within other contexts doesn't actully do anything.
      # @yield Use this block to define any routes
      def define &block
        new block
      end

      def set_context_to context
        @current_context = context
      end

      def find_and_execute(path)
        path =
        if Ruta.config.context_prefix
        (  path == '/' || path == "") ? path : (path[/(?:\/.*?)(\/.*)/];$1)
        else
          path
        end
        res = find(path)
        if res
          navigate_to res
        else
          raise "no matching route for #{path}"
        end
      end

      def find path
        Context.collection.each do |con_ref,context|
          context.routes.each do |r_ref,route|
            res = route.match(path)
            return res if res
          end
        end
        false
      end


      def navigate_to(route)
        route[:route].execute_handler route[:params],route[:path]
      end

      def route_for context, ref,params=nil
        Context.collection[context].routes[ref].get(params)
      end

      def set_root_to context
        @root = context
        Router.set_context_to root
      end

    end

  end
end
