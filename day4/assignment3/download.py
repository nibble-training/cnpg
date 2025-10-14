"""
Download a large blob from Azure Storage in chunks
"""
import os
from azure.storage.blob import BlobServiceClient

account_name = os.environ['AZ_STORAGE_ACCOUNT_NAME']
sas_token = os.environ['AZ_SAS_TOKEN']
container_name = os.environ['AZ_CONTAINERNAME']
local_file_path = os.environ['LOCAL_PATH']
blob_name = os.environ['BLOB_NAME']

account_url = f"https://{account_name}.blob.core.windows.net/?{sas_token}"

try:
    blob_service_client = BlobServiceClient(account_url=account_url)
    container_client = blob_service_client.get_container_client(container_name)
    blob_client = container_client.get_blob_client(blob_name)

    # Stream download in chunks
    with open(local_file_path, "wb") as file:
        stream = blob_client.download_blob()
        for chunk in stream.chunks():
            file.write(chunk)

    print(f"Blob '{blob_name}' successfully downloaded to '{local_file_path}'.")

except Exception as ex:
    print('Exception:')
    print(ex)
