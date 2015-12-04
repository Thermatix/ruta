# handles url changes
module Ruta
  class Handler

    attr_reader :handles
    def handle handler_name,&handler
        @context.handlers[handler_name] = handler
    end

    def initialize context,&block
      @context = context
      instance_exec &block
    end

    # TODO:Move these functions to execution context?
    def switch_context_to context

    end

    def switch_sub_context_to context

    end
    class << self
      def define_for context_name, &block
         new(Context.collection.fetch(context_name){|c_n|raise"Tried to define handlers for #{c_n} before it exists"},
         block)
      end
    end
  end
end
