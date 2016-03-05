# @todo: allow contexts to be mounted to roots
# @todo: Allow empty components to exists and ensure they are only rendered when they are not blank

if RUBY_ENGINE == 'opal'
  require 'browser'
  require 'browser/history'

  require 'ruta/context'
  require 'ruta/handler'
  require 'ruta/history'
  require 'ruta/route'
  require 'ruta/router'
  require 'ruta/version'


  module Ruta
    class Config
      attr_accessor :context_prefix
      def initialize &block
        @context_prefix = false
        block_given?
        instance_exec(self,&block) if block_given?
      end

      def configure &block
        instance_exec(&block)
      end
    end

    class << self
      attr_reader :config

      def configure &block
        if self.config
          @config.configure(&block)
        else
          @config = Config.new(&block)
        end
      end
      # used to retrieve a stored url
      #
      # @param [Symbol] context of the stored url, if this is nil it defaults to the current context
      # @param [Symbol] reference to the route
      # @param [Array<String,Number,Boolean>] *params 0 or more params to replace params in the paramterized route
      # @return [String] string containing url with any params given correctly inserted
      def get_url_for context, reference, *params
        Router.route( context || Router.current_context, reference, params)[:path]
      end

      # used to navigate to a route
      # @param [Symbol] context that route is mounted to
      # @param [Symbol] ref to a route that you wish to navigate to
      # @param [Array<String,Number,Boolean>] *params 0 or more params to replace params in the paramterized route
      def navigate_to_ref context, ref,*params
        route = Router.route_for(context,ref,params)
        History.push(context,route[:path],route[:params],route[:title]) unless route[:route].type == :context
        route[:route].execute_handler route[:params],route[:path]
      end

      # used to start the app
      # @example start command placed inside of $document.ready block
      #   $document.ready do
      #     Ruta.start_app
      #   end
      def start_app &block
        if block_given?
          configure(&block)
        else
          configure unless self.config
        end
        Context.render(Router.current_context)
        Router.find_and_execute(History.current :path)
        History.listen_for_pop
      end
    end

  end


else
  require "ruta/version"
  require 'opal'
  lib_path = File.dirname(File.expand_path('.', __FILE__))
  Opal.append_path lib_path
end
