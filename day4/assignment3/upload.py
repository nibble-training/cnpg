"""
A simple script to upload a file to a bucket
"""
import os
from azure.storage.blob import BlobClient

account_name = os.environ['AZ_STORAGE_ACCOUNT_NAME']
sas_token = os.environ['AZ_SAS_TOKEN']
container_name = os.environ['AZ_CONTAINERNAME']
local_file_path = os.environ['LOCAL_PATH']
blob_name = os.environ['BLOB_NAME']
account_url = f"https://{account_name}.blob.core.windows.net/?{sas_token}"

try:
    blob_client = BlobClient(
        account_url=account_url,
        container_name=container_name,
        blob_name=blob_name,
        max_block_size=2**22,      # 2MB is default, change as required
        max_single_put_size=2**26, # 64MB is default, change as required
    )

    # Upload in chunks
    with open(local_file_path, "rb") as data:
        blob_client.upload_blob(
            data,
            overwrite=True,
            max_concurrency=4,  # Adjust based on your system/network
        )

    print(f"Large file '{blob_name}' uploaded successfully.")

except Exception as ex:
    print('Exception:')
    print(ex)
