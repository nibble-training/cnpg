#!/bin/bash
az storage account create \
	--name nblstorageaccount \
	--resource-group nbl-training \
	--location westeurope \
	--sku Standard_LRS

KEY1=$(az storage account keys list --resource-group nbl-training --account-name nblstorageaccount | jq '.[0].value' -r)

az storage container create \
	--name example-1 \
	--account-name nblstorageaccount \
	--account-key "${KEY1}"

EPOCH_IN_ONE_YEAR=$(($(date +%s) + 365 * 24 * 60 * 60))
DATE_IN_ONE_YEAR="$(date +%Y-%m-%d --date=@${EPOCH_IN_ONE_YEAR})"

TOKEN1=$(az storage container generate-sas --account-name nblstorageaccount --name example-1 --permissions rwl --expiry="${DATE_IN_ONE_YEAR}T23:59:00Z" --account-key "$KEY1" --output tsv)

kubectl create secret generic azure-creds \
	--type "Opaque" \
	--from-literal="AZ_STORAGE_ACCOUNT=${KEY1}" \
	--from-literal="AZ_SAS_TOKEN=${TOKEN1}"
