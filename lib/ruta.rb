

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

      attr_accessor :context
      def get_url_for ref, *params
        Router.route ref,params
      end



      def navigate_to_ref ref,*params
        con = Context.current_context
        proc {
        dat = Router.data(params)
        res = Router.route_for(con,ref,params)
        # Router.history.push(res[:path],dat)
        res[:route].execute_handler params,res[:path]
      }
      end

      def start_app
        Context.render(Router.current_context)
      end
    end
    @Context = :no_context
  end


else
  require "ruta/version"
  require 'opal'
  lib_path = File.dirname(File.expand_path('.', __FILE__))
  Opal.append_path lib_path
end
