module Ruta
  class Handlers

    attr_reader :handles
    def handle handler_name,&handler
        @handler_name = handler_name
        @context.handlers[@handler_name] = handler
    end

    def initialize context,block
      @context = context
      instance_exec &block
    end

    # @todo Move these functions to execution context?
    def switch_sub_context_to context
      Context.wipe @handler_name
      Context.render context
    end

    class << self
      def define_for context_name, &block
         new(Context.collection.fetch(context_name){|c_n|raise"Tried to define handlers for #{c_n} before it exists"},
         block)
      end
    end
  end
end
