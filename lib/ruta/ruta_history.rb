
module Ruta
  class History
    attr_reader :window, :location, :history

    def initialize
       @location = Window.location
       @history = Window.history
    end

    def back by=1
      self.history.back by
    end

    def forward by=1
      self.history.forward by
    end

    def current_path
      self.location.path
    end

    def set_current_path path,page_name=nil,data={}
      self.history.replaceState(data, page_name, path)
    end

    def add_to_history path, page_name=nil,data={}
      self.history.pushState(data,page_name,path )
    end

    def current_uri
     self.location.uri
    end

  end
end
