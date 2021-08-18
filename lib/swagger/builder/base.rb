module Swagger
  module Builder
    class Base
      attr_reader :attributes

      def attribute(attr, val = {})
        @attributes ||= {}
        @attributes[attr.to_s.camelize(:lower)] = val
      end

      def file_reader(*dir)
        JSON.parse(File.read(File.join(Rails.root, *dir)))
      end

      def dir_reader(*dir)
        json_files = File.join(Rails.root, *dir, "*.json")
        Dir.glob(json_files).inject({}){|res, i| res.merge(JSON.parse(File.read(i)))}
      end
    end
  end
end
