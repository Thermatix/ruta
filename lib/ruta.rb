

if RUBY_ENGINE == 'opal'
  require 'browser'
  require 'browser/history'

  require 'ruta/context'
  require 'ruta/handler'
  require 'ruta/history'
  require 'ruta/route'
  require 'ruta/routes'
  require 'ruta/router'
  require 'ruta/version'

  module Ruta
    class << self
      def get_url_for ref, *params
        Router.route ref,params
      end

      def navigate_to ref,*params
        d = Router.data(params)
        r = Router.route(ref,params)
        History.add_to_history r[:path], r[:flags][:page_name],d
        Router.get_handler_for get_fragment
      end

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
