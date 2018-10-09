require 'hiera/backend/eyaml/encryptor'
require 'hiera/backend/eyaml/utils'
require 'hiera/backend/eyaml/options'

class Hiera
  module Backend
    module Eyaml
      module Encryptors

        class GcpKms < Encryptor

          self.tag = "GCPKMS"

          def self.decrypt ciphertext
            plaintext=`/usr/local/bin/decrypt_kms.sh #{ciphertext}`
            return plaintext
          end

        end
      end
    end
  end
end
