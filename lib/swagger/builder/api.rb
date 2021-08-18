module Swagger
  module Builder
    class Api < Swagger::Builder::Base
      def initialize
        attribute :swagger, "2.0"
        attribute :info, file_reader('lib', 'swagger', 'json', 'api', 'info.json')
        attribute :host, ENV['DEFAULT_URL_HOST']
        attribute :schemes, [ENV['DEFAULT_URL_PROTOCOL']]
        attribute :base_path, "/"
        attribute :tags, file_reader('lib', 'swagger', 'json', 'api', 'tags.json')
        attribute :paths, dir_reader('lib', 'swagger', 'json', 'api', 'paths')
        attribute :definitions, dir_reader('lib', 'swagger', 'json', 'api', 'models')
        attribute :security_definitions, file_reader('lib', 'swagger', 'json', 'security.json')
      end
    end
  end
end
