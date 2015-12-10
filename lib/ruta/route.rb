module Ruta
  # this class was taken from vienna and modified
  # https://github.com/opal/vienna/blob/master/opal/vienna/router.rb#L42
  class Route

    NAMED = /:(\w+)/

    SPLAT = /\\\*(\w+)/

    OPTIONAL = /\\\((.*?)\\\)/

     attr_reader :regexp, :named, :type, :handlers, :url,:flags

     def initialize(pattern, flags)

       if flags[:to]
         @type = :handlers
         @handlers = [flags.delete :to].flatten
       elsif flags[:context]
         @type = :context
         @handlers = flags.delete :context
       else
         @type = :ref_only
       end
       @flags = flags
       @url = pattern
       @named = []


       pattern = Regexp.escape pattern
       pattern = pattern.gsub OPTIONAL, "(?:$1)?"

       pattern.gsub(NAMED) { |m| @named << m[1..-1] }
       pattern.gsub(SPLAT) { |m| @named << m[2..-1] }

       pattern = pattern.gsub NAMED, "([^\\/]*)"
       pattern = pattern.gsub SPLAT, "(.*?)"

       @regexp = Regexp.new "^#{pattern}$"
       puts @named
       puts @Regexp
     end

     def match(path,current_context)
       puts "matching #{path}"
       if match = @regexp.match(path)
         case @type
         when :handler
           params = {}
           @named.each_with_index { |name, i| params[name] = match[i + 1] }
           [Context.collection[current_context].handlers[@handler]].flatten.each(params,path,&:call)
           return true
         when :context
           Context.wipe
           Context.render @handler
         end
        end
        false
     end

  end
end
