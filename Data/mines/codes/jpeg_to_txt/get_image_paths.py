from google.cloud import storage
from google.oauth2 import service_account
from batch_annotate_offline import sample_async_batch_annotate_images
credentials = service_account.Credentials.from_service_account_file('service_acc_key.json')
client = storage.Client(credentials=credentials)
BUCKET_NAME = 'amar99_cadastre'
bucket = client.get_bucket(BUCKET_NAME)
for blob in bucket.list_blobs(prefix='raw images/'):
  if blob.name!='raw images/':
    p = 'gs://' + BUCKET_NAME + '/' + str(blob.name)
    print(p)
    sample_async_batch_annotate_images(p,"gs://amar99_cadastre/json files/" + str(blob.name).split('/')[1])