

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

      def navigate_to_ref ref,*params
        dat = Router.data(params)
        res = Routes.get(ref,params)
        Router.history.push(res[:path],dat)
        res[:route].match(res[:path])
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
