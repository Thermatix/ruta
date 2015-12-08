module Ruta
  # this class was taken from vienna and modified
  # https://github.com/opal/vienna/blob/master/opal/vienna/router.rb#L42
  class Route

    NAMED = /:(\w+)/

    SPLAT = /\\\*(\w+)/

    OPTIONAL = /\\\((.*?)\\\)/

     attr_reader :regexp, :named, :type, :handler

     def initialize(pattern, flags)

       if flags[:to]
         @type = :handler
         @handler = flags[:to]
       elsif flags[:context]
         @type = :context
         @handler = flags[:context]
       else
         @type = :ref_only
       end


       @named = []


       pattern = Regexp.escape pattern
       pattern = pattern.gsub OPTIONAL, "(?:$1)?"

       pattern.gsub(NAMED) { |m| @named << m[1..-1] }
       pattern.gsub(SPLAT) { |m| @named << m[2..-1] }

       pattern = pattern.gsub NAMED, "([^\\/]*)"
       pattern = pattern.gsub SPLAT, "(.*?)"

       @regexp = Regexp.new "^#{pattern}$"
     end

     def match(path,current_context)
       if match = @regexp.match(path)
         case @type
         when :handler
           params = {}
           @named.each_with_index { |name, i| params[name] = match[i + 1] }
           [Context.collection[current_context].
                             handlers[@handler].
                                        flatten.
                           (&:call, params,path)
           return true
         when :context
           Context.wipe
           Context.render(@handler)
         end
        end
        false
     end

  end
end
