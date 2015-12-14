require 'native'
module Ruta

  class History
    class << self
      def push(url,data,title=nil)
        `history.pushState(#{data.to_n}, #{title}, #{url})`
      end

      def replace(url,data,title=nil)
        # history.replaceState(data, title, url)
        `history.replaceState(#{data.to_n}, #{title}, #{url})`
      end

      def forward(by=1)
        `history.go(#{by.to_i})`
      end

      def back(by=1)
        `history.go(#{-by.to_i})`
      end




      def navigate_to_remote path
        `location.href = #{path}`
      end

      def location_of thing

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


      def listen_for_pop
        `window.onpopstate = function(event) {
          #{
              Router.find_and_execute(location_of :path)
          }
        }`
      end

      def listen_for_refresh_and_back
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
