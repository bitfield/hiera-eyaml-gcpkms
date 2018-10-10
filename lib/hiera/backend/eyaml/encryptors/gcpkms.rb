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

          self.tag = "GCPKMS"
          self.options = {
            :key_id => { :desc => "GCP KMS key ID",
              :type => :string,
              :default => "",
            },
            :location_id => { :desc => "GCP KMS key location",
              :type => :string,
              :default => "global",
            },
            :project_id => { :desc => "GCP project",
              :type => :string,
              :default => "",
            }

          }

          def self.init
            # Instantiate the client
            Cloudkms   = Google::Apis::CloudkmsV1 # Alias the module
            kms_client = Cloudkms::CloudKMSService.new

            # Set the required scopes to access the Key Management Service API
            # @see https://developers.google.com/identity/protocols/application-default-credentials#callingruby
            kms_client.authorization = Google::Auth.get_application_default(
              "https://www.googleapis.com/auth/cloud-platform"
            )

            # The resource name of the location associated with the key rings
            parent = "projects/#{project_id}/locations/#{location_id}"

            # Request list of key rings
            response = kms_client.list_project_location_key_rings parent

            # List all key rings for your project
            puts "Key Rings: "
            if response.key_rings
              response.key_rings.each do |key_ring|
                puts key_ring.name
              end
            else
              puts "No key rings found"
            end

          end

          def self.decrypt ciphertext
            plaintext=`echo "#{Base64.encode64(ciphertext)}" | /usr/local/bin/decrypt_kms.sh`
            return plaintext.chomp
          end

        end
      end
    end
  end
end
