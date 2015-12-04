# stores contexts
module Ruta
  class Context
    attr_accessor :elements
    attr_accessor :handlers

    def initialize &block
        @elements = {}
        @handlers = {}
        instance_exec &block
    end

    def element element_name,element_attribs, &block
      self.elements[element_name] = {
        attributes: element_attribs,
        content: block
      }
    end


    # TODO:Move these functions to execution context?
    def context context_name
      context_name
    end

    class << self
      attr_reader :collection, :render

      def handle_render &block
        @render = block
      end

      def define context_name, &block
        @collection[context_name] = new(block)
      end
    end
    @collection = {}
  end
end
