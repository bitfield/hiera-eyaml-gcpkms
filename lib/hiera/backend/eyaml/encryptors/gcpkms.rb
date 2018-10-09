require 'hiera/backend/eyaml/encryptor'
require 'hiera/backend/eyaml/utils'
require 'hiera/backend/eyaml/options'

require 'base64'

class Hiera
  module Backend
    module Eyaml
      module Encryptors

        class GcpKms < Encryptor

          self.tag = "GCPKMS"
          self.options = {
            :key_id => { :desc => "GCP KMS Key ID",
                            :type => :string,
                            :default => "",
            }
          }

          def self.decrypt ciphertext
            plaintext=`echo "#{Base64.encode64(ciphertext)}" | /usr/local/bin/decrypt_kms.sh`
            return plaintext.chomp
          end

        end
      end
    end
  end
end
