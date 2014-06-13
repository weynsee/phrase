require 'net/http'
require 'uri'

module Phrase
  module Api
    class Client
      module Http

        # Mixin Factory
        def self.included(base)
          klass = RUBY_VERSION < "2.0" ? Http1X : Http2X
          base.send :include, klass
        end

        def handle_ssl_cert(client)
          client.use_ssl = true if Phrase::Api::Config.api_use_ssl?
          client.verify_mode = OpenSSL::SSL::VERIFY_NONE if Phrase::Api::Config.skip_ssl_validation?
          client.ca_file = File.join(File.dirname(__FILE__), "..", "..", "..", "..", "cacert.pem")
          client
        end

        module Http2X
          def http_client
            client = Net::HTTP.new(Phrase::Api::Config.api_host, Phrase::Api::Config.api_port)
            handle_ssl_cert(client)
          end
        end

        module Http1X
          class InvalidProxyError < StandardError; end

          def http_client
            proxy_user, proxy_pass, proxy_host, proxy_port = nil, nil, nil, nil
            if Phrase::Api::Config.proxy.present?
              begin
                uri = URI.parse(Phrase::Api::Config.proxy)
                proxy_user, proxy_pass = uri.userinfo.split(/:/) if uri.userinfo
                proxy_host = uri.host
                proxy_port = uri.port
              rescue URI::InvalidURIError => e
                raise InvalidProxyError.new(e)
              end
            end

            client = Net::HTTP.new(
              Phrase::Api::Config.api_host, Phrase::Api::Config.api_port,
              proxy_host, proxy_port, proxy_user, proxy_pass
            )
            handle_ssl_cert(client)
          end
        end

      end
    end
  end
end
