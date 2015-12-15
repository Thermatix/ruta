# @todo: Ensure sub-context routes are mounted into parent context routes
# @todo: Allow empty components to be exists and ensure they are only rendered when they are not blank

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
      # @return [Proc] A proc that can be used as a callback block for an event
      def navigate_to_ref context, ref,*params
        route = Router.route_for(context,ref,params)
        History.push(route[:path],route[:params],route[:title])
        Router.navigate_to(route)
      end

      # used to start the app
      # @example start command placed inside of $document.ready block
      #   $document.ready do
      #     Ruta.start_app
      #   end
      def start_app
        Context.render(Router.current_context)
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
