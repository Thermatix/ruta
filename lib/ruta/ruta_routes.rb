module Ruta
  class Routes

    class << self
      # TODO allow sub-contextes to be mapable
      attr_reader :collection
      def add ref, route,context, flags
        @collection||= {}
        create_section_for context
        pos(context)[ref] = Route.new(route,flags)
      end

      def remove context, ref
        pos(context).delete(ref)
      end

      def get context, ref
        pos(context)[ref]
      end

      private
      def pos pointer
        if @collection.empty?
          @collection
        else
          pointer.inject(@collection) do |tree,pos|
            tree[pos]
          end
        end
      end

      def create_section_for pointer
        pointer.inject(@collection) do |tree,pos|
          tree[pos] = {} unless tree[pos]
          tree[pos]
        end
      end

    end

  end
end
