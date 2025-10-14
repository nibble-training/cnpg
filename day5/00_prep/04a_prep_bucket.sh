#!/bin/bash
AZRG=nbl-training
AZSA=nblstorageaccount
AZLOCATION=westeurope
AZSKU=Standard_LRS
EPOCH_IN_ONE_YEAR=$(($(date +%s) + 365 * 24 * 60 * 60))
DATE_IN_ONE_YEAR="$(date +%Y-%m-%d --date=@${EPOCH_IN_ONE_YEAR})"

az storage account create \
  --name "${AZSA}" \
  --resource-group "${AZRG}" \
  --location "${AZLOCATION}" \
  --sku "${AZSKU}"

KEY1=$(
  az storage account keys list \
    --resource-group "${AZRG}" \
    --account-name "${AZSA}" | jq '.[0].value' -r
)

for NS in azureuser student1 student2; do
  kubectl get ns "${NS}" >/dev/null 2>&1 || kubectl create ns "${NS}"
  az storage container create \
    --name "${NS}" \
    --account-name "${AZSA}" \
    --account-key "${KEY1}"

  TOKEN1=$(
    az storage container generate-sas \
     --account-name "${AZSA}" \
     --name "${NS}" \
     --permissions rwl \
     --expiry="${DATE_IN_ONE_YEAR}T23:59:00Z" \
     --account-key "$KEY1" \
     --output tsv
  )

  kubectl get secret -n "${NS}" azure-creds >/dev/null 2>&1 && \
    kubectl delete secret -n "${NS}" azure-creds
  kubectl create secret -n "${NS}" generic azure-creds \
    --type "Opaque" \
    --from-literal="AZ_STORAGE_ACCOUNT=${KEY1}" \
    --from-literal="AZ_SAS_TOKEN=${TOKEN1}"
done
