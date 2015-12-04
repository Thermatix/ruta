module Ruta
  class Routes

    class << self
      # TODO allow sub-contextes to be mapable
      attr_reader :collection
      def add ref, route,context, flags
        @collection||= {}
        @collection[contex]||= {}
        @collection[context][ref] = {re:route,handle: flags.delete(:to),flags: flags}
      end

      def remove ref
        @collection.delete(ref)
      end

      def get ref
        @collection[ref]
      end

      def get_and_paramaterize ref,*params
        segments = `#{get(ref)}.split('/')`
        '/' + segments.map { |item| item[0] == ':' ? params.shift : item }.join('/') + '/'
      end

    end

  end
end
