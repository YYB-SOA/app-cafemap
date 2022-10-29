city_arr = %w[新竹 台北 宜蘭 臺北 新北 桃園 苗栗 台中 ]
user_wordterm = "新竹"
puts city_arr.select{ |city| city== user_wordterm}
