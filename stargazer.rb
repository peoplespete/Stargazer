require 'yaml'
require 'httparty'

puts 'Stargazing search initiated...'

config = YAML.load_file('config.yml')

response = HTTParty.get("https://api.openweathermap.org/data/2.5/weather?q=#{config['city']}&appid=#{config['open_weather_map']}")
response = JSON.parse(response.body, symbolize_names: true)

is_clear = response[:clouds][:all] <= 20

today = Date.today
date_string = (today - 7).strftime("%m/%d/%Y")

response = HTTParty.get("http://api.usno.navy.mil/moon/phase?date=#{date_string}&nump=4")
response = JSON.parse(response.body, symbolize_names: true)
new_moon_date = response[:phasedata].find { |h| h[:phase] == 'New Moon' }[:date]

new_moon_date = Date.parse(new_moon_date)
# new_moon_date = Date.parse("FEB7,2018")
difference =  new_moon_date - today

close_to_new_moon = difference.abs < 4

# is_clear = true
# close_to_new_moon = true
if is_clear && close_to_new_moon
  puts 'Great day for stargazing'
  sleep 60 * 50 # 50 minutes
end
