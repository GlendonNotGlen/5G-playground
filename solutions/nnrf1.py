import collections.abc
#hyper needs the four following aliases to be done manually.
collections.Iterable = collections.abc.Iterable
collections.Mapping = collections.abc.Mapping
collections.MutableSet = collections.abc.MutableSet
collections.MutableMapping = collections.abc.MutableMapping

#Now import hyper
from hyper import HTTP20Connection
try:
  # to NRF
  c = HTTP20Connection('192.168.137.138:32001')
  
  # Search NF Instances
  c.request('GET','/nnrf-nfm/v1/nf-instances')
  data = c.get_response()
  print(data.read())
except:
  pass

