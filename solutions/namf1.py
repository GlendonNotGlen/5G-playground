import collections.abc
#hyper needs the four following aliases to be done manually.
collections.Iterable = collections.abc.Iterable
collections.Mapping = collections.abc.Mapping
collections.MutableSet = collections.abc.MutableSet
collections.MutableMapping = collections.abc.MutableMapping

import json
from hyper import HTTP20Connection  # Import HTTP2 connection

try:
    # Create a connection to the AMF
    c = HTTP20Connection('192.168.137.138:32002')

    # Set the request headers
    headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
    }

    # Prepare the body of the request
    ### works! ue deregistered...
    body = {
	"deregReason":	"SUBSCRIPTION_WITHDRAWN",
	"accessType":	"3GPP_ACCESS",
        "flagValue":	"UE_DOS_s9873f7sd"
    }

    # Convert dictionary to JSON string
    body_json = json.dumps(body)

    # Send a POST request to the /namf-comm/v1/ue-contexts endpoint
    c.request('POST', '/namf-callback/v1/imsi-999700000000001/dereg-notify', body_json, headers)

    # Get the response
    response = c.get_response()

    # Read and print the response data
    data = response.read()
    print(data.decode('utf-8'))

except Exception as e:
    print(f"An error occurred: {e}")
