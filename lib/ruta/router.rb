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


      def data params
        if params.first.class == Hash
          params.shift
        else
          {}
        end
      end

      def route_for context, ref,params=nil
        Context.collection[context].routes[ref].get(params)
      end

    end

  end
end
