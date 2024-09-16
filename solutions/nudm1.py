import collections.abc
#hyper needs the four following aliases to be done manually.
collections.Iterable = collections.abc.Iterable
collections.Mapping = collections.abc.Mapping
collections.MutableSet = collections.abc.MutableSet
collections.MutableMapping = collections.abc.MutableMapping

#Now import hyper
from hyper import HTTP20Connection
try:
  # to UDM
  c = HTTP20Connection('192.168.137.138:32010')
  # Get supported slices in the user profile 
  c.request('GET','/nudm-sdm/v2/imsi-999700000000001/am-data')
  data = c.get_response()
  print(data.read())
except:
  pass

