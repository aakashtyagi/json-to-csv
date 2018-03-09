import requests
import csv


"""
flattenjson(param1, param2):
This is a recursive function which converts a nested json object into a simple json object.
This helps in converting it into a csv file format.

It takes 2 parameters:
#1 param1 => JSON object
#2 param2 => a delimiter to join nested child headings with their parent headings

It returns the input value into a simple JSON object
"""
def flattenjson(data, delim):
  val = {}

  # iterating through input JSON
  for key, value in data.items():

    # if value is a nested JSON, call it again
    if isinstance(value, dict):
      get = flattenjson(value, delim)
      for key1, value1 in get.items():

        # This is used to preserve the list data as a string in csv
        if isinstance(value1, list):
          value1 = '"'+','.join(value1)+'"'

        val[key+delim+key1] = value1
    else:

      # This is used to preserve the list data as a string in csv
      if isinstance(value, list):
        value = '"'+','.join(value)+'"'

      val[key] = value
      
  return val

def main():
  # http GET request on the given URL
  inputUrl = 'https://gist.githubusercontent.com/romsssss/6b8bc16cfd015e2587ef6b4c5ee0f232/raw/f74728a6ac05875dafb882ae1ec1deaae4d0ed4b/users.json'
  r = requests.get(inputUrl)

  # if the response from URL is good
  if r.status_code == 200:
    data = r.json()
    new_json = []

    # converting original data into easier format to enable easy csv conversion
    for row in data:
      value = flattenjson(row,'.')
      new_json.append(value)
      
    # getting field names for csv
    columns = [ x for row in new_json for x in row.keys() ]
    columns = list( set( columns ) )

    # writing into csv file
    with open( "python_output.csv", 'wb' ) as out_file:
      csv_w = csv.writer( out_file )
      csv_w.writerow( columns )

      # writing field values
      for i_r in new_json:
          csv_w.writerow( map( lambda x: i_r.get( x, "" ), columns))
  else:
    # if the JSON request is not good
    print "Could not retrieve JSON from given URL"

if __name__ == "__main__":
    main()
  

  

