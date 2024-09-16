import collections.abc
#hyper needs the four following aliases to be done manually.
collections.Iterable = collections.abc.Iterable
collections.Mapping = collections.abc.Mapping
collections.MutableSet = collections.abc.MutableSet
collections.MutableMapping = collections.abc.MutableMapping
#Now import hyper
from hyper import HTTP20Connection

try:
    # Create a connection to the AUSF
    c = HTTP20Connection('192.168.137.138:32003')

    # Set the request headers
    headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
    }

    # Send a POST request to the /nausf-auth/v1/ue-authentications endpoint
    body = '{"supiOrSuci":"imsi-999700000000001","servingNetworkName":"5G:mnc70.mcc999.3gppnetwork.org"}'
    c.request('POST', '/nausf-auth/v1/ue-authentications', body, headers)

    # Get the response
    response = c.get_response()

    # Read and print the response data
    data = response.read()
    print(data.decode('utf-8'))

except Exception as e:
    print(f"An error occurred: {e}")
