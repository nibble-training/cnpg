#!/bin/bash
set -ex
cd "$(dirname "$(which kubectl)")"
CNPGVERSION="$(curl 'https://api.github.com/repos/cloudnative-pg/cloudnative-pg/releases/latest' | jq -r ".tag_name" | sed 's/^v//')"
CNPGURL=https://github.com/cloudnative-pg/cloudnative-pg/releases/download/v${CNPGVERSION}/kubectl-cnpg_${CNPGVERSION}_linux_$(uname -m).tar.gz
curl -L "${CNPGURL}" | sudo tar -xvz kubectl-cnpg
