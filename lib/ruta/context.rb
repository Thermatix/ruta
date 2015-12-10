# stores contexts
module Ruta
  class Context
    attr_reader :elements, :ref
    attr_accessor :handlers, :routes
    DOM = ::Kernel.method(:DOM)
    def initialize ref,block
        @ref = ref
        @elements = {}
        @handlers = {}
        @routes = {}
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
      attr_reader :collection,:renderer

      def handle_render &block
        @renderer = block
      end

      def define ref, &block
        @collection[ref] = new(ref,block)
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
        render_context_elements context_to_render,context, this
        render_element_contents context_to_render,context
      end
      private
      def render_context_elements context_to_render,context,this
        context_to_render.elements.each do |element_name,details|
          DOM {
            div(details[:attributes].merge(id: element_name, "data-context" => context))
          }.append_to(this)
        end
      end

      def render_element_contents context_to_render,context
        Ruta.context = context
        context_to_render.elements.each do |element_name,details|
          case details[:type]
          when :sub_context
            render details[:content],$document[element_name]
          when :element
            @renderer.call(details[:content].call,element_name,context)
          end
        end
        Ruta.context = :no_context
      end
    end
    @collection = {}
  end
end
