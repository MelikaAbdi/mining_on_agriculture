import re
from google.cloud import storage
from google.oauth2 import service_account
from batch_annotate_offline import sample_async_batch_annotate_images
credentials = service_account.Credentials.from_service_account_file('service_acc_key.json')
client = storage.Client(credentials=credentials)
BUCKET_NAME = 'licenses_ore_jpg'
bucket = client.get_bucket(BUCKET_NAME)
for blob in bucket.list_blobs():
    p = 'gs://' + BUCKET_NAME + '/' + str(blob.name)
    print(p)
    cad_code = re.findall(r'\d+',str(blob.name).split('/')[0])[0]
    sample_async_batch_annotate_images(p,"gs://licenses_ore_json/" + cad_code+'_cropped')