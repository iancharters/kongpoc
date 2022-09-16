#!/bin/sh

# TODO: Figure out how we can guarantee container does not start if any of these
# functions fail
set -e

KONG_CONFIG=../config/kong.yaml
PUB_KEY=pubkey.pem

# Retrieve X509 certificate
echo "Pulling X509 certificate from $AUTH0_ISSUER_URL"
curl -o $PUB_KEY ${AUTH0_ISSUER_URL%/}/pem

# Extract public key from cert.  This will fail with a non-zero exit code if the
# previous step did not produce a proper certificate for whatever reason.
openssl x509 -pubkey -noout -in $PUB_KEY > .tmp && mv .tmp $PUB_KEY

echo "Injecting Kong config"

# Inject public key into auth0 consumer rsa_public_key field
# TODO: https://mikefarah.gitbook.io/yq/usage/tips-and-tricks#split-expressions-over-multiple-lines-to-improve-readability
yq -i '(.consumers[] | select(.username == "auth0")).jwt_secrets[0].rsa_public_key = "'"$(< $PUB_KEY)"'"' $KONG_CONFIG

# Remove so this doesn't linger when running locally
rm pubkey.pem

# Run envsubst across entire file and fail with a non-zero exit code if any vars
# are null or empty.
yq -i '(.. | select(tag == "!!str")) |= envsubst(ne, nu)' $KONG_CONFIG


echo "Starting Kong"

# Run command for normal Kong entrypoint
# kong docker-start
