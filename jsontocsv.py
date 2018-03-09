import requests
import csv

def flattenjson(data, delim):
  val = {}
  for key, value in data.items():
    if isinstance(value, dict):
      # print value
      get = flattenjson(value, delim)
      for key1, value1 in get.items():
        if isinstance(value1, list):
          value1 = '"'+','.join(value1)+'"'
        val[key+delim+key1] = value1
    else:
      if isinstance(value, list):
        value = '"'+','.join(value)+'"'
      val[key] = value
  return val

inputUrl = 'https://gist.githubusercontent.com/romsssss/6b8bc16cfd015e2587ef6b4c5ee0f232/raw/f74728a6ac05875dafb882ae1ec1deaae4d0ed4b/users.json'
r = requests.get(inputUrl)


if r.status_code == 200:
  data = r.json()
  new_json = []
  for row in data:
    value = flattenjson(row,'.')
    new_json.append(value)
    
  columns = [ x for row in new_json for x in row.keys() ]
  columns = list( set( columns ) )
  with open( "output.csv", 'wb' ) as out_file:
    csv_w = csv.writer( out_file )
    csv_w.writerow( columns )

    for i_r in new_json:
        csv_w.writerow( map( lambda x: i_r.get( x, "" ), columns ) )
  

  

