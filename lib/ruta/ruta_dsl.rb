module Ruta

  module DSL

    class Base

      attr_accessor :pointer, :tree

      def initialize block
        @position = []
        @tree = {}
        instance_exec &block
      end

      private

      def section name
        self.pointer << name
        self.create_section_at_pos
        section_return = yield
        self.pointer.pop
        section_return
      end

      def get_pos
        pos
      end

      def set_pos key,value
        pos[key] = value
      end

      def pos
        if self.empty?
          self
        else
          self.pointer.inject(self) do |tree,pos|
            tree[pos]
          end
        end
      end

      def create_section_at_pos
        self.pointer.inject(self.tree) do |tree,pos|
          tree[pos] = {} unless tree[pos]
          tree[pos]
        end
      end

    end
    class Handler
      attr_reader :handles
      def handle handler_name,&handler
          @context.handlers[handler_name] = handler
      end

      def initialize context,&block
        @context = context
        instance_exec &block
      end

      # TODO:Move these functions to execution context
      def switch_context_to context

      end

      def switch_sub_context_to context

      end

    end

    class Context
      attr_accessor :elements
      attr_accessor :handlers

      def initialize &block
          @elements = {}
          @handlers = {}
          instance_exec &block
      end

      def element element_name, &block
        self.elements[element_name] = block
      end




      # TODO:Move these functions to execution context
      def context context_name
        context_name
      end
    end

    class Router < Base
      attr_accessor :current_context, :inital_context, :routes
      def initialize &block
        @current_context = ""
        @routes = {}
        super(block)
      end

      def using_context context
        @current_context = context
        yield
        @current_context = ""
      end

      def map key,route, options={}
        # @routes[current_context] = {
        #   key: {
        #     route: Route.new(route),
        #     to: options.fetch(:to)
        #   }
        # }
        Routes.create(ref,route,options)
      end

      def root context
        @inital_context = context
      end


    end
  end
end
