module Unpatched
  def self.version
    VERSION
  end

  module VERSION
    extend Comparable

    MAJOR     = 0
    MINOR     = 0
    TINY      = 1
    SIGNATURE = [MAJOR, MINOR, TINY]
    STRING    = SIGNATURE.join '.'

    def self.major; MAJOR  end
    def self.minor; MINOR  end
    def self.tiny;  TINY   end
    def self.to_s;  STRING end

    def self.hash
      STRING.hash
    end

    def self.<=>(other)
      other = other.split('.').map { |i| i.to_i } if other.respond_to? :split
      SIGNATURE <=> Array(other)
    end

    def self.inspect
      STRING.inspect
    end

    def self.respond_to?(meth, *)
      meth.to_s !~ /^__|^to_str$/ and STRING.respond_to? meth unless super
    end

    def self.method_missing(meth, *args, &block)
      return super unless STRING.respond_to?(meth)
      STRING.send(meth, *args, &block)
    end
  end
end
