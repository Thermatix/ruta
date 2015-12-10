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

      def get ref, params=nil
        puts "mapping #{ref}"
        puts @collection
        # route = pos(context)[ref]
        route = find(ref,@collection)
        path = if params
          paramaterize route.url.dup,params
        else
          route.url
        end
        {
            path: path,
            page_name: route.flags[:page_name],
            route: route
        }
      end

      def paramaterize url, params
        segments = url.split('/')
        '/' + segments.map { |item| item[0] == ':' ? params.shift : item }.join('/') + '/'
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
