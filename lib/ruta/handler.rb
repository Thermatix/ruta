module Ruta
  class Handlers

    # create a handle to be excuted when a matching route is hit
    #
    # @param [Symbol] handler_name the unique ident of the handler, it should match the id of an element that you want the component to be rendered to
    # @yield [params,path] a block containing logic for processing any params before passing it to a component to render
    # @yieldparam [{Symbol => String}] params containing a list of params passed into it from the matching route
    # @yieldparam [String] path the non processed url
    # @yieldreturn [Object] a component that will be passed to the renderer to be rendered to the page
    def handle handler_name,&handler
        @handler_name = handler_name
        @context.handlers[@handler_name] = handler
    end

    # @see #Handlers#define_for
    def initialize context,block
      @context = context
      instance_exec &block
    end

    # wipe the matching element and render a context
    #
    # @param [Symbol] context context to be mounted to matching element of handler
    # @todo Move these functions to execution context?
    # @return [Proc] returns a proc to be executed later
    def mount context
      handler_name = @handler_name
      proc {
        Context.wipe handler_name
        Context.render context
      }
    end

    class << self
      # define handlers for a context
      #
      # @example
      # Ruta::Handlers.define_for :main do
      #  handler :header do |params,url|
      #   some code that process the params and returns a component
      #  end
      #  handler :header do |params,url|
      #   some code that process the params and returns a component
      #  end
      # end
      # @param [Symbol] context to define handlers for
      # @yield block containing handlers for a context
      def define_for context, &block
         new(Context.collection.fetch(context){|c_n|raise"Tried to define handlers for #{c_n} before it exists"},
         block)
      end
    end
  end
end
