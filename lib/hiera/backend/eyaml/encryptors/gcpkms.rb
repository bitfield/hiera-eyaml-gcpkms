require 'hiera/backend/eyaml/encryptor'
require 'hiera/backend/eyaml/utils'
require 'hiera/backend/eyaml/options'

require 'base64'
begin
  require 'google/apis/cloudkms_v1'
rescue LoadError
  fail "hiera-eyaml-gcpkms requires the 'google-api-client' gem"
end

class Hiera
  module Backend
    module Eyaml
      module Encryptors

        class GcpKms < Encryptor
          Cloudkms   = Google::Apis::CloudkmsV1 # Alias the module

          self.tag = "GCPKMS"
          self.options = {
            :key_id => { :desc => "GCP KMS key ID",
              :type => :string,
              :default => "",
            },
          }

          def self.init
            # Instantiate the client
            @kms_client = Cloudkms::CloudKMSService.new

            # Set the required scopes to access the Key Management Service API
            # @see https://developers.google.com/identity/protocols/application-default-credentials#callingruby
            @kms_client.authorization = Google::Auth.get_application_default(
              "https://www.googleapis.com/auth/cloud-platform"
            )
            @key_id = self.option :key_id
          end

          def self.encrypt(plaintext)
            self.init()
            encrypt_request = Cloudkms::EncryptRequest.new(:plaintext => plaintext)
            response = @kms_client.encrypt_crypto_key(@key_id, encrypt_request)
            return Base64.encode64(response.ciphertext.chomp)
          end


          def self.decrypt(ciphertext)
            self.init()
            decrypt_request = Cloudkms::DecryptRequest.new(:ciphertext => Base64.decode64(ciphertext))
            response = @kms_client.decrypt_crypto_key(@key_id, decrypt_request)
            return response.plaintext
          end
        end
      end
    end
  end
end
