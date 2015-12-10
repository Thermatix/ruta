module Ruta
  class Routes

    class << self
      # TODO allow sub-contextes to be mapable
      attr_reader :collection
      def add ref, route,context, flags
        @collection||= {}
        create_section_for context
        pos(context)[ref] = Route.new(route,context,flags)
      end

      def remove context, ref
        pos(context).delete(ref)
      end

      


      private

      def find ref,tree
        tree.each do |segment_ref,segment|
          if segment.respond_to? :flags
            if ref == segment_ref
              return segment
            end
          else
            return find(ref,segment)
          end
        end
        raise "#{ref} doesn't exist"
      end

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
