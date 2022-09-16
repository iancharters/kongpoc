#!/bin/sh

KONG_CONFIG=../config/kong.yaml
PUB_KEY=pubkey.pem

# Retrieve X509 certificate
curl -o $PUB_KEY $AUTH0_ISSUER_URL/pem

# Extract public key from cert.  This will fail with a non-zero exit code if the
# previous step did not produce a proper certificate for whatever reason.
openssl x509 -pubkey -noout -in $PUB_KEY > .tmp && mv .tmp $PUB_KEY

# Inject public key into auth0 consumer rsa_public_key field
# TODO: https://mikefarah.gitbook.io/yq/usage/tips-and-tricks#split-expressions-over-multiple-lines-to-improve-readability
yq -i '(.consumers[] | select(.username == "auth0")).jwt_secrets[0].rsa_public_key = "'"$(< $PUB_KEY)"'"' $KONG_CONFIG

# Run envsubst across entire file and fail with a non-zero exit code if any vars
# are null or empty.
yq '(.. | select(tag == "!!str")) |= envsubst(ne, nu)' $KONG_CONFIG

# Run command for normal Kong entrypoint
kong docker-start
