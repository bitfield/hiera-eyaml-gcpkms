require 'hiera/backend/eyaml/encryptor'
require 'hiera/backend/eyaml/utils'
require 'hiera/backend/eyaml/options'

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
            return "sekrit_password"
          end

        end
      end
    end
  end
end
