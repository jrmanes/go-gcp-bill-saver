#!/bin/bash

PROJECT_NAME=go-gcp-bill-saver
AUTH_FILE=$1

terraform init ../infra/list/
terraform plan ../infra/list/

