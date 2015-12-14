require 'native'
module Ruta

  class History
    class << self

      attr_reader :window,:history, :location
      def push(url,data,title=nil)
        history.pushState(data, title, url)
      end

      def replace(url,data,title=nil)
        history.replaceState(data, title, url)
      end

      def forward(by=1)
        history.go(by.to_i)
      end

      def back(by=1)
        history.go(-by.to_i)
      end

      def listen
        
      end

      def navigate_to_remote path
        location[:href] = path
      end

      def current thing

        case thing
        when :query
          location[:query]
        when :fragment
          location[:fragment]
        when :path
          location[:pathname]
        when :url
          location[:href]
        when :uri
          location[:uri]
        end

      end
    end

    @window = Native(`window`)
    @history =  window[:History]
    @location = window[:location]
  end

end
