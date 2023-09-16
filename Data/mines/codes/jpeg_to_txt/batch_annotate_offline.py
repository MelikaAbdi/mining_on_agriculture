
from google.cloud import vision
from google.oauth2 import service_account
#print("Waiting for operation to complete...")

def sample_async_batch_annotate_images(
    input_image_uri="gs://batch-image-offline-results/127022.jpeg",
    output_uri="gs://batch-image-offline-results",
):
    """Perform async batch image annotation."""
    credentials = service_account.Credentials.from_service_account_file('service_acc_key.json')
    client = vision.ImageAnnotatorClient(credentials=credentials)

    source = {"image_uri": input_image_uri}
    image = {"source": source}
    features = [
        {"type_": vision.Feature.Type.DOCUMENT_TEXT_DETECTION},
        #{"type_": vision_v1.Feature.Type.LANDMARK_DETECTION},
        #{"type_": vision.Feature.Type.IMAGE_PROPERTIES},
    ]

    # Each requests element corresponds to a single image.  To annotate more
    # images, create a request element for each image and add it to
    # the array of requests
    requests = [{"image": image, "features": features}]
    gcs_destination = {"uri": output_uri}

    # The max number of responses to output in each JSON file
    batch_size = 1
    output_config = {"gcs_destination": gcs_destination,
                     "batch_size": batch_size
                    }

    operation = client.async_batch_annotate_images(requests=requests, output_config=output_config)

    print("Waiting for operation to complete...")
    response = operation.result(10000)

    # The output is written to GCS with the provided output_uri as prefix
    gcs_output_uri = response.output_config.gcs_destination.uri
    print("Output written to GCS with prefix: {}".format(gcs_output_uri))

#sample_async_batch_annotate_images("gs://batch-image-offline-results/127022.jpeg","gs://batch-image-offline-results/outout")