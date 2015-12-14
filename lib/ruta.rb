

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
    class << self



      # used to retrive a stored url
      #
      # @param [Symbol] context of the stored url, if this is nil it defaults to the current context
      # @param [Symbol] reference to the route
      # @param [Array<String,Number,Boolean>] *params 0 or more params to replace params in the paramterized route
      # @return [String] string containing url with any params given correctly inserted
      def get_url_for context, reference, *params
        Router.route( context || Router.current_context, reference, params)[:path]
      end

      # returns a proc that is used in place of a callback block
      # @example
      #   button do
      #     button_name
      #   end.on(:click,&Ruta.navigate_to_ref(:i_switch,'some_value'))
      # @param [Symbol] context that route is mounted to
      # @param [Symbol] ref to a route that you wish to navigate to
      # @param [Array<String,Number,Boolean>] *params 0 or more params to replace params in the paramterized route
      # @note you have to use this function as a proc direcly as in the example, if you place this into a callback block and call it there, you will find that the incorrect context is used for the route
      # @return [Proc] A proc that can be used as a callback block for an event
      def navigate_to_ref context, ref,*params
        res = Router.route_for(context,ref,params)
        History.push(res[:path],res[:params],res[:page_name])
        res[:route].execute_handler res[:params],res[:path]
      end

      # used to start the app
      # @example app start command placed inside of $document.ready block
      #   $document.ready do
      #     Ruta.start_app
      #   end
      def start_app
        Context.render(Router.current_context)
        History.listen
      end
    end

  end


else
  require "ruta/version"
  require 'opal'
  lib_path = File.dirname(File.expand_path('.', __FILE__))
  Opal.append_path lib_path
end
