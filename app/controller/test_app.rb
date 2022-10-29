region = "新竹"
city_arr = %w[新竹 台北 宜蘭 臺北 新北 桃園 苗栗 台中]

puts city_arr.any?(region)
puts (region.split(" ").count >= 2)
puts city_arr.any?(region)&&(region.split(/ /).count >= 2)
