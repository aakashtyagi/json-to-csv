require 'net/http'
require 'json'
require 'csv'

=begin

FILE OVERVIEW:

The idea is to :
1. Get the JSON data
2. Simplify the JSON data (convert if nested)
3. Write it into a csv

=end


=begin

flattenjson(param1, param2):
This is a recursive function which converts a nested json object into a simple json object.
This helps in converting it into a csv file format.

It takes 2 parameters:
#1 param1 => JSON object
#2 param2 => a delimiter to join nested child headings with their parent headings

It returns the input value into a simple JSON object

=end

def flattenjson(data, delim)
    val = {}

    # iterating through input JSON
    data.each do |key, value|

      # if value is a nested JSON, call it again
      if value.class == Hash
        get = flattenjson(value, delim)
        get.each do |key1, value1|

          # This is used to preserve the list data as a string in csv
          if value1.kind_of?(Array)
            value1 = '"'+value1.join(",")+'"'
          end
          val[key+delim+key1] = value1
        end
      else

        # This is used to preserve the list data as a string in csv
        if value.kind_of?(Array)
          value = '"'+value.join(",")+'"'
        end
        val[key] = value
      end
    end
    return val
end

# http GET request on the given URL
url = 'https://gist.githubusercontent.com/romsssss/6b8bc16cfd015e2587ef6b4c5ee0f232/raw/f74728a6ac05875dafb882ae1ec1deaae4d0ed4b/users.json'
uri = URI(url)
response = Net::HTTP.get(uri)
data = JSON.parse(response)

new_json = []
columns = []
for row in data
  # calling the function to reformat json
  # converting original data into easier format to enable easy csv conversion
  value = flattenjson(row, '.')
  columns.push(value.keys)
  new_json.push(value)
end

# getting field names for csv
columns = columns.uniq
CSV.open("ruby_output.csv", "wb") do |csv|

  # writing field names into csv file
  columns.each do |hash|
    csv << hash
  end

  # writing field values
  new_json.each do |hash|
    csv << hash.values
  end

end


