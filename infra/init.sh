#!/usr/bin/env bash

pushd ../bootstrap >> /dev/null
STATE_BUCKET=$(terraform output -raw bucket_name)
popd >> /dev/null

terraform init -backend-config="bucket=$STATE_BUCKET" -reconfigure
