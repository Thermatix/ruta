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
      # @!attribute [r] collection
      # @return [{ref => Context}] Hash of all Contexts created

      # @!attribute [r] renderer
      # @return [Proc] the renderer used to render and or mount components on to the DOM

      # @!attribute [r] current_context
      # @return [Symbol] The reference to the current context being rendered


      attr_reader :collection,:renderer, :current_context

      # Used to tell the router how to render components to the DOM
      #
      # @example render a react.rb component to the dom
      #   Ruta::Context.handle_render do |object,element_id|
      #     React.render React.create_element(object), `document.getElementById(#{element_id})`
      #   end
      # @yield [object,element_id] A block of code that gets executed to render a given object to a given element id
      # @yieldparam [Object] object to be rendered
      # @yieldparam [String] ID of page element object will be mounted to
      def handle_render &block
        @renderer = block
      end

      # used to define a context's page composition
      #
      # @example Define a composition for a context called :main
      #   Ruta::Context.define :main do
      #     element :header do
      #       Header
      #     end
      #
      #     sub_context :info, :info_view
      #
      #     element :footer do
      #       Footer
      #     end
      #   end
      # @param [Symbol] ref reference to the context being defined
      # @yield a block of code that is used to define the composition of a context
      def define ref, &block
        @collection[ref] = new(ref,block)
      end

      # used to wipe clear an elementt's content
      #
      # @param [String] id of element to be cleared, if no id is provided will clear body tag of content
      def wipe id=nil
        if id
          $document[id].clear
        else
          $document.body.clear
        end
      end

      # used to render a composition to the screen
      #
      # @param [Symbol] context the context to render
      # @param  [String] id of element context is to be rendered to, if no id is provided will default to body tag
      def render context, id=nil
        this = id ? $document[id]: $document.body
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
        Context.current_context = context
        context_to_render.elements.each do |element_name,details|
          case details[:type]
          when :sub_context
            render details[:content],element_name
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
