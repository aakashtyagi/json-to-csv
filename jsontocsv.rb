require 'net/http'
require 'json'
require 'csv'

def flattenjson(data, delim)
    val = {}
    data.each do |key, value|
      if value.class == Hash
        get = flattenjson(value, delim)
        get.each do |key1, value1|
          if value1.kind_of?(Array)
            value1 = '"'+value1.join(",")+'"'
          end
          val[key+delim+key1] = value1
        end
      else
        if value.kind_of?(Array)
          value = '"'+value.join(",")+'"'
        end
        val[key] = value
      end
    end
    return val
end

# GET request
url = 'https://gist.githubusercontent.com/romsssss/6b8bc16cfd015e2587ef6b4c5ee0f232/raw/f74728a6ac05875dafb882ae1ec1deaae4d0ed4b/users.json'
uri = URI(url)
response = Net::HTTP.get(uri)
data = JSON.parse(response)

new_json = []
columns = []
for row in data
  # calling the function to reformat json
  value = flattenjson(row, '.')
  columns.push(value.keys)
  new_json.push(value)
end

# Unique
columns = columns.uniq
CSV.open("ruby.csv", "wb") do |csv|

  # writing headers
  columns.each do |hash|
    csv << hash
  end

  # writing data (values)
  new_json.each do |hash|
    csv << hash.values
  end

end


