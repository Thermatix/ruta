

if RUBY_ENGINE == 'opal'
  require 'ruta_history'
  require 'ruta_dsl'
  require 'ruta_context'
  require 'ruta_handler'
  require 'ruta_router'
  require 'ruta_version'

else
  require "ruta/ruta_version"
  require 'opal'

  Opal.append_path File.expand_path('./', __FILE__)
  Opal.append_path File.expand_path('./ruta/', __FILE__)
end
