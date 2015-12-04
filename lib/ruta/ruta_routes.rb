module Ruta
  class Routes

    class << self
      # TODO allow sub-contextes to be mapable
      attr_reader :collection
      def add ref, route,context, flags
        @collection||= {}
        @collection[contex]||= {}
        @collection[context][ref] = {path:route,handle: flags.delete(:to),flags: flags}
      end

      def remove ref
        @collection.delete(ref)
      end

      def get ref
        @collection[ref]
      end

      def get_and_paramaterize ref,*params
        route = get(ref).dup
        segments = `#{route[:path]}.split('/')`
        path = '/' + segments.map { |item| item[0] == ':' ? params.shift : item }.join('/') + '/'
        route[:path] = path
        route
      end

    end

  end
end
