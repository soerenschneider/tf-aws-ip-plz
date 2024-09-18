#!/usr/bin/env bash

set -ex

ENV=$(basename $(pwd))
NAME=$(basename "$(git rev-parse --show-toplevel)" | sed 's/^tf-//')

if [[ "${ENV}" = "dev" ]]; then
    PASS="thisisnotverysecure,onlyforlocaltesting"
else
    PASS=$(pass infra/opentofu-state/${ENV}/${NAME})
fi

TF_ENCRYPTION=$(cat <<EOF
key_provider "pbkdf2" "mykey" {
  passphrase = "${PASS}"
}
EOF
)

export TF_ENCRYPTION

terragrunt init -upgrade -reconfigure
terragrunt apply

if [[ "${ENV} = "dev" ]]; then
    terragrunt destroy && rm -f terraform.tfstate
fi

