# matches routes to a handeler
module Ruta

  class Router


    # @todo: ensure sub-context routes are mounted into parent context routes

    # @!attribute [r,w] current_context
    # @return [Array<Symbol>] current_context a list of contexts, the last being the current

    # @!attribute [r,w] routes
    # @return [{ref => Proc}] list of route handlers attached to this context

    attr_accessor :current_context
    def initialize block
      @current_context = []
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

      # @!attribute [r] current_context
      # @return [Array<Symbol>] current_context the current context that the user is in

      # @!attribute [r] history
      # @return [Array<Symbol>] history

      # @!attribute [r] window
      # @return [Array<Symbol>] window

      # @!attribute [r] root
      # @return [Array<Symbol>] root the initial context of the app

      attr_reader :current_context, :root

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

      def find_and_execute(path)
        res = find(path)
        puts "result:#{res}"
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
        puts route
        route[:route].execute_handler route[:params],route[:path]
      end

      def route_for context, ref,params=nil
        Context.collection[context].routes[ref].get(params)
      end

    end

  end
end
