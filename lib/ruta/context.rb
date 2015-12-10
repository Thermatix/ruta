# stores contexts
module Ruta
  class Context
    attr_reader :elements
    attr_accessor :handlers
    DOM = ::Kernel.method(:DOM)
    def initialize block
        @elements = {}
        @handlers = {}
        instance_exec &block
    end

    def element ref,attribs={}, &block
        self.elements[ref] = {
          attributes: attribs,
          type: :element,
          content: block
        }
    end

    def sub_context ref,context,attribs={}
      self.elements[ref] = {
        attributes: attribs,
        type: :sub_context,
        content: context,
      }
    end


    class << self
      attr_reader :collection, :render

      def handle_render &block
        @render = block
      end

      def define context_name, &block
        @collection[context_name] = new(block)
      end

      def wipe element=nil
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
          DOM {
            div(details[:attributes].merge(id: element_name))
          }.append_to(this)
        end
      end

      def render_element_contents context_to_render,context
        context_to_render.elements.each do |element_name,details|
          case details[:type]
          when :sub_context
            puts "#{element_name}: #{$document[element_name]}"
            render details[:content],$document[element_name]
          when :element
            @render.call(details[:content].call,element_name)
          end
        end
      end
    end
    @collection = {}
  end
end
