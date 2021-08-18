class ApplicationSerializer
  include ActiveModel::Serializers::JSON

  # Default serialized object
  attr_reader :object
  attr_reader :meta

  def initialize(obj, meta: {}, _attr_opt: {})
    @object = obj
    @meta = meta || {}
    @attr_opt = _attr_opt
  end

  # Return list of all Attributes
  def attributes
    @attributes ||= self.class.attributes.map { |k, _| [k, nil] }.to_h
  end

  # With default @attr_opt (forwarded from parent serializer)
  def as_json(options = {})
    options.present? ? super(options) : super(@attr_opt)
  end

  class << self
    attr_reader :attributes

    # Wrap list
    def wrap(objects, meta: {}, _attr_opt: {})
      if objects.respond_to?(:to_ary)
        (objects.to_ary || [objects]).map { |o| wrap(o, meta: meta, _attr_opt: _attr_opt) }
      else
        self.new(objects, meta: meta, _attr_opt: _attr_opt)
      end
    end

    # DSL to set attribute
    # opt[:source]
    # opt[:field]
    # opt[:with]
    def attribute(attr, opt = {})
      @attributes ||= {}
      @attributes[attr.to_s] = { source: opt[:source], field: opt[:field] }

      if opt[:source].present?
        define_serialization_getter(attr, opt[:source], opt)
      end
    end


    private

    # DSL to create getter + wrapper
    def define_serialization_getter(attr, source, opt = {})
      define_method attr do
        value = self.send(source).try(opt[:field] || attr)
        return value unless opt[:with].present?

        if value.nil?
          value
        elsif opt[:if].present? && !value.send(opt[:if])
          nil
        elsif opt[:with].is_a?(Class) && (opt[:with] <= ApplicationSerializer)
          attr_opt = opt.slice(:except, :only, :include)
          opt[:with].wrap(value, meta: @meta, _attr_opt: attr_opt)
        else
          opt[:with].call(value)
        end
      end
    end
  end
end
