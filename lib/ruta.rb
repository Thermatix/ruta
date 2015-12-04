

if RUBY_ENGINE == 'opal'
  require 'browser'
  require 'browser/history'

  require 'ruta_context'
  require 'ruta_handler'
  require 'ruta_history'
  require 'ruta_routes'
  require 'ruta_router'
  require 'ruta_version'

else
  require "ruta/ruta_version"
  require 'opal'

  Opal.append_path File.expand_path('./', __FILE__)
  Opal.append_path File.expand_path('./ruta/', __FILE__)
end

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
      Dom {
        Context.collection[Router.current_context].elements.each do |element|
          div.
        end
      }.append_to($document.body)

    end
  end
end
