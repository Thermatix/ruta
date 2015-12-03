# stores contexts
module Ruta
  class Context

    class << self

      attr_reader :collection, :render

      def handle_render &block
        @render = block
      end


      def define context_name, &block
        @collection[context_name] = DSL::Context.new(block)
      end
    end
    @collection = {}
  end
end
