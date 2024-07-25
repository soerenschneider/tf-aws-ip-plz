#!/usr/bin/env bash

set -e

TF_ENCRYPTION=$(cat <<EOF
key_provider "pbkdf2" "mykey" {
  passphrase = "somekeynotverysecure"
}
EOF
)
export TF_ENCRYPTION

terragrunt init -upgrade -reconfigure

terragrunt apply

terragrunt destroy && rm -f terraform.tfstate

