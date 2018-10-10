begin
  require 'google/apis/cloudkms_v1'
rescue LoadError
  fail "hiera-eyaml-gcpkms requires the 'google-api-client' gem"
end
require 'base64'

Cloudkms   = Google::Apis::CloudkmsV1 # Alias the module
kms_client = Cloudkms::CloudKMSService.new

# Set the required scopes to access the Key Management Service API
# @see https://developers.google.com/identity/protocols/application-default-credentials#callingruby
kms_client.authorization = Google::Auth.get_application_default(
  "https://www.googleapis.com/auth/cloud-platform"
)

project_id = 'cz-prod-kms'
location_id = 'global'
key_id = 'projects/cz-prod-kms/locations/global/keyRings/prod/cryptoKeys/infra'

encrypt_request = Cloudkms::EncryptRequest.new(:plaintext => "foobar")
response = kms_client.encrypt_crypto_key(key_id, encrypt_request)
puts Base64.encode64(response.ciphertext)