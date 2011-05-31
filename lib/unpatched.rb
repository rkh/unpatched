require 'unpatched/version'

module Unpatched
  MINUTE = 60
  HOUR   = 60  * MINUTE
  DAY    = 24  * HOUR
  MONTH  = 30  * DAY
  YEAR   = 365 * DAY

  module Utils
    extend self

    def wrapped(value)
      NormalWrapper.new(value)
    end

    def unwrapped(value)
      value = value.__instance_eval__ { @value } while Wrapper === value
      value
    end

    def numeric(value)
      case value
      when Numeric then value
      when Wrapper then numeric unwrapped(value)
      else
        begin
          Integer value
        rescue ArgumentError
          Float value
        end
      end
    end

    alias num numeric
  end

  class Wrapper < defined?(BasicObject) ? BasicObject : Object
    def self.const_missing(const) ::Unpatched.const_get(const) end
    alias __instance_eval__ instance_eval

    if superclass == Object
      instance_methods.each do |m|
        undef_method(m) if m.to_s !~ /(?:^__|^send$|^object_id$)/
      end
    else  
      undef ==
      undef equal?
      undef instance_eval
    end

    def initialize(value)
      @value = Utils.unwrapped(value)
    end

    def inspect
      @value.inspect
    end

    def and(value = (undefined = true))
      return self if undefined
      if Wrapper === value
        Utils.wrapped @value + unwrapped(value)
      else
        MultiWrapper.new self, value
      end
    end

    alias_method :but, :and
  end

  class MultiWrapper < Wrapper
    def initialize(base, value)
      @base, @value = base, Utils.wrapped(value)
    end

    private
    def method_missing(*a, &b)
      @base + @value.__send__(*a, &b)
    end
  end

  class NormalWrapper < Wrapper
    def second
      value = Utils.unwrapped @value
      if value.respond_to? :second
        value.second
      else
        Utils.wrapped Utils.num(value)
      end
    rescue TypeError, ArgumentError => err
      raise err unless value.respond_to? :[]
      value[1]
    end

    def underscore
      to_s.
        gsub(/::/, '/').
        gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
        gsub(/([a-z\d])([A-Z])/,'\1_\2').
        tr("-", "_").
        downcase
    end

    def seconds; Utils.wrapped Utils.num(@value)          end
    def minute;  Utils.wrapped Utils.num(@value) * MINUTE end
    def hour;    Utils.wrapped Utils.num(@value) * HOUR   end
    def day;     Utils.wrapped Utils.num(@value) * DAY    end
    def month;   Utils.wrapped Utils.num(@value) * MONTH  end
    def year;    Utils.wrapped Utils.num(@value) * YEAR   end

    def before(other)
      Utils.wrapped Utils.unwrapped(other) - @value
    end

    def after(other)
      Utils.wrapped Utils.unwrapped(other) + @value
    end

    def ago
      before Time.now
    end


    def from_now
      after Time.now
    end

    alias minutes minute
    alias hours   hour
    alias days    day
    alias months  month
    alias years   year

    private

    def method_missing(m, *a, &b)
      a.map! { |e| Utils.unwrapped e }
      if m[-1] == ?! and NormalWrapper.method_defined?(method = m[0..-2])
        result = __send__(method, *a, &b)
        Utils.unwrapped result
      else
        Utils.wrapped @value.__send__(m, *a, &b)
      end
    end
  end

  module Unfancy
    private
    def _(value)
      Utils.wrapped(value)
    end
  end

  module Fancy
    include Unfancy
    %w[about exactly like is some].each do |meth|
      alias_method meth, :_
      private meth
    end
  end

  def self.[](value)
    Utils.wrapped(value)
  end

  include Fancy
end
