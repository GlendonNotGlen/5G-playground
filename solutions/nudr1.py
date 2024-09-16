import collections.abc
#hyper needs the four following aliases to be done manually.
collections.Iterable = collections.abc.Iterable
collections.Mapping = collections.abc.Mapping
collections.MutableSet = collections.abc.MutableSet
collections.MutableMapping = collections.abc.MutableMapping

#Now import hyper
from hyper import HTTP20Connection
try:
  # to UDR
  c = HTTP20Connection('192.168.137.138:32011')
  # Get subscription data
  c.request('GET','/nudr-dr/v1/subscription-data/imsi-999700000000001/authentication-data/authentication-subscription') ##works
  data = c.get_response()
  print(data.read())
except:
  pass

