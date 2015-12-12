

if RUBY_ENGINE == 'opal'
  require 'browser'
  require 'browser/history'

  require 'ruta/context'
  require 'ruta/handler'
  require 'ruta/route'
  require 'ruta/router'
  require 'ruta/version'

  module Ruta
    class << self



      # used to retrive a stored url
      #
      # @param [Symbol] context of the stored url, if
      # @param [Symbol] reference to the route
      # @param [Array<String,Number,Boolean>] *params 0 or more params to replace params in the paramterized route
      # @return [String] string containing url with any params given correctly inserted
      def get_url_for context, reference, *params
        Router.route( context, reference, params)[:path]
      end

      # returns a proc that is used in place of a callback block
      # @example
      #   button do
      #     button_name
      #   end.on(:click,&Ruta.navigate_to_ref(:i_switch,'some_value'))
      # @param [Symbol] ref to a route that you wish to naviage to
      # @param [Array<String,Number,Boolean>] *params 0 or more params to replace params in the paramterized route
      # @note you have to use this function as a proc direcly as in the example, if you place this into a callback block and call it there, you will find that the incorrect context is used for the route
      # @return [Proc] A proc that can be used as a callback block for an event
      def navigate_to_ref ref,*params
        con = Context.current_context
        proc {
          dat = Router.data(params)
          res = Router.route_for(con,ref,params)
          # Router.history.push(res[:path],dat)
          res[:route].execute_handler params,res[:path]
        }
      end

      # used to start the app
      def start_app
        Context.render(Router.current_context)
      end
    end
    
  end


else
  require "ruta/version"
  require 'opal'
  lib_path = File.dirname(File.expand_path('.', __FILE__))
  Opal.append_path lib_path
end
