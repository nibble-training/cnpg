"""
A simple script to upload a file to a bucket
"""
import os
from datetime import datetime, timedelta
from azure.storage.blob import BlobServiceClient, generate_account_sas, ResourceTypes, AccountSasPermissions

account_name = os.environ['AZ_STORAGE_ACCOUNT_NAME']
sas_token = os.environ['AZ_SAS_TOKEN']
container_name = os.environ['AZ_CONTAINERNAME']
local_file_path = os.environ['LOCAL_PATH']
blob_name = os.environ['BLOB_NAME']
url = f"https://{account_name}.blob.core.windows.net/?{sas_token}"
try:
    # create BlobServiceClient
    blob_service_client = BlobServiceClient(account_url=url)

    # open container
    container_client = blob_service_client.get_container_client(container_name)

    # Upload data
    with open(local_file_path, "rb") as data:
        container_client.upload_blob(name=blob_name, data=data, overwrite=True)

    print(f"Dump successfully uploaded to container '{container_name}'.")

except Exception as ex:
    print('Exception:')
    print(ex)
