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

    def sub_context ref, context
      self.elements[ref] = {
        content: Proc.new {|context|Context.render context,context}
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
        puts this
        puts context_to_render
        context_to_render.elements.each do |element_name,details|
          a = Dom {
            div.send("#{element_name}!")
          }
          puts a
          a.append_to this
        end
      end

      def render_element_contents context_to_render,context
        context_to_render.elements.each do |element_name,details|
          object = details[:content].call
          puts object
          if object.class == Symbol
            render object,$document[context]
          else
            @render.call($document[element_name])
          end
        end
      end
    end
    @collection = {}
  end
end