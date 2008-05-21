class Module
  # add a _with_index to iterators
  def with_index(*args)
    args.each {|meth|
      module_eval <<-here
      def #{meth.to_s}_with_index(*args)
        i = -1
        send(:#{meth},*args) {|n|
          i = i+1
          yield(n,i)
        }
      end
      here
    }
  end

  # add a 'f' method called with a method rather than a block
  def _f(*args)
    args.each {|meth|
      module_eval <<-here
      def #{meth}f(*args)
        #{meth} {|obj| obj.send(*args)}
      end
      here
    }
  end
end

module Enumerable
  with_index :map
  _f :map
end

a = %w(all your base are belong to us)
p a.map_with_index {|n,i| "(#{i}) #{n}"}
p a.mapf(:reverse)
