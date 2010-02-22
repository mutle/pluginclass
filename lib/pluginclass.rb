module PluginClass

  module ObjectExtensions
    def is_a?(klass)
      if klass.respond_to?(:root_klass) && klass.respond_to?(:current_klass)
        return super(klass.root_klass) || super(klass.current_klass)
      end
      super(klass)
    end

    def instance_of?(klass)
      if klass.respond_to?(:root_klass) && klass.respond_to?(:current_klass)
        return super(klass.root_klass) || super(klass.current_klass)
      end
      super(klass)
    end
  end

  class Proxy
    attr_reader :root_klass, :current_klass

    def initialize(klass)
      @root_klass = @current_klass = klass
      @extended = false
    end

    def extend_class(&block)
      unless @extended
        @current_klass = Class.new(@root_klass)
        @extended = true
      end
      @current_klass.class_eval &block
    end

    def reset_class
      @current_klass = @root_klass
      @extended = false
    end

    def method_missing(meth, *args)
      @current_klass.send(meth, *args)
    end

  end


  class << self
    def extend_class(name, &block)
      if klass = plugin_classes[name]
        klass.extend_class &block
      end
    end

    def plugin_classes
      @plugin_classes ||= {}
    end

    def extended(mod)
      super(mod)
      proxy = Proxy.new(mod)
      name = mod.name
      plugin_classes[name] = proxy
      Object.send(:remove_const, name)
      Object.const_set(name, proxy)
    end
  end

end

Object.send(:include, PluginClass::ObjectExtensions)
