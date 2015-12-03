module Ruta
  class Routes

    class << self
      attr_accessor :pointer, :tree, :refs
      def create ref, route, flags
        self.pointer = []
        segments = `#{route}.split('/')`
        attach_to_tree segments,flags
        self.refs[ref] = self.pointer.dup
      end

      private

      def attach_to_tree segments,flags
        segments.each do |segment|
          create_section_at_pos
          set_pos segment, {
            type: segment_type(segment),
            flags: flag
          }
          self.pointer << segment
        end
      end

      def segment_type segment
        (@segment_types|| = {
          ':' => :param,
          '#' => :fragment
        })[segment[0]] || :standard
      end

      def get_pos
        pos
      end

      def set_pos key,value
        pos[key] = value
      end

      def pos
        if self.tree.empty?
          self.tree
        else
          self.pointer.inject(self.tree) do |tree,pos|
            tree[pos]
          end
        end
      end

      def create_section_at_pos
        self.pointer.inject(self.tree) do |tree,pos|
          tree[pos] = {} unless tree[pos]
          tree[pos]
        end
      end
    end

    self.tree = {}
    self.refs = {}

  end
end
