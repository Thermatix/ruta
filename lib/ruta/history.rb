
module Ruta
  class History
    class << self
      def back by=1
        @history.back by
      end

      def forward by=1
        @history.forward by
      end

      def set_current_path path,page_name=nil,data={}
        @history.replaceState(data, page_name, path)
      end

      def add_to_history path, page_name=nil,data={}
        @history.pushState(data,page_name,path )
      end
    end
    @history = Window.history

  end
end
