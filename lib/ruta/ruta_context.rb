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

      def wipe element
        if element
          $document[element].clear
        else
          $document.body.clear
        end
      end

      def render context, this=$document.body
        context_to_render = @collection[context]
        render_context_elements context_to_render, this
        render_element_contents context_to_render,context
      end
      private
      def render_context_elements context_to_render,this
        context_to_render.elements.each do |element_name,details|
          Dom {
            div.send("#{element_name}!")
          }.append_to this
        end
      end

      def render_element_contents context_to_render,context
        context_to_render.elements.each do |element_name,details|
          object = details.content.call
          if object.class == Symbol
            render object,$document[context]
          else
            @render.call(,$document[element_name])
          end
        end
      end
    end
    @collection = {}
  end
end
