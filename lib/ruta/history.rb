require 'native'
module Ruta

  class History
    class << self

      # push new url to history
      #
      # @param [String] url to be added to history
      # @param [Hash] data to be added to history
      # @param [String] title to be added to history, defaults to ""
      def push(url,data,title="")
        `history.pushState(#{data.to_n}, #{title}, #{url})`
      end

      # replace current url in history
      #
      # @param [String] url to replace current item in history
      # @param [Hash] data to replace current item in history
      # @param [String] title to replace current item in history, defaults to ""
      def replace(url,data,title=nil)
        `history.replaceState(#{data.to_n}, #{title}, #{url})`
      end

      # move browser forward
      #
      # @param [Integer] by the amount to go forwards by, defaults to 1
      def forward(by=1)
        `history.go(#{by.to_i})`
      end

      # move browser backwards
      #
      # @param [Integer] by the amount to go backwards by, defaults to 1
      def back(by=1)
        `history.go(#{-by.to_i})`
      end

      # navigate browser to remote path
      #
      # @param [String] path to navigate to
      def navigate_to_remote path
        `location.href = #{path}`
      end

      # get current `thing` from locaction
      #
      # current things supported are:
      #   * query
      #   * fragment
      #   * path
      #   * url
      #   * uri
      # @param [Symbol] thing to get the current value of from the current location
      def current thing
        case thing
        when :query
          `location.query`
        when :fragment
        `  location.fragment`
        when :path
          `location.pathname`
        when :url
          `location.href`
        when :uri
          `location.uri`
        end

      end

      # will turn on a listener for when the forward and backward buttons on the browser are pressed
      def listen_for_pop
        `window.onpopstate = function(event) {
          #{
              Router.find_and_execute(current :path)
          }
        }`
      end

      # will stop listening for when forward and backward buttons on the browser are pressed
      def stop_listening_for_pop
        `window.onpopstate = nil`
      end

      # will stop listening for when the page move away from the current page(refresh or back), will present user with dialogue box
      def stop_listening_for_on_before_load
        `window.onbeforeunload = nil`
      end


      # will turn on a listener for when the page move away from the current page(refresh or back), will present user with dialogue box
      def listen_for_on_before_load
        `window.onbeforeunload = function (evt) {
          var message = 'Are you sure you want to leave?';
         if (typeof evt == 'undefined') {
           evt = window.event;
         }
         if (evt) {
           evt.returnValue = message;
         }
         return message;
        }`
      end
    end
  end
end
