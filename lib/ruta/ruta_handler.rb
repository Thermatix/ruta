# handles url changes
module Ruta
  class Handler
    def define_for context_name, &block
       DSL::Handler.new(Context.collection[context_name],block)
    end
  end
end
