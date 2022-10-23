# frozen_string_literal: true

require 'json'

module PlaceInfo
  class CafeFilter # rubocop:disable Style/Documentation
    # Get Cafe data
    def read_cafe(path)
      JSON.parse(File.read(path))
    end

    def location_filter(input, attribute, word_term)
      input['row_data'].select! { |key| key[attribute].include? word_term }
    end

    def read_cafe_attribute(data_hash, attribute = nil)
      box = []
      if attribute.nil?
        box = data_hash
      else
        data_hash.select { |ele| box << ele[attribute] }
      end
      box
    end

    def noise_filter(name_str)
      # Normalization
      name_str.gsub('()', '').gsub(' ', '').gsub("\b", '')
    end

    def data_clean(box)
      # Input: string array of cafe name
      box.map { |name_str| noise_filter(name_str) }
    end

    # 回傳包含特定字元
    # def filter_keyword(input, keyword)
    #     input.select { |key| key.include? keyword}
    # end

    # word_term一定要給
    def main(word_term)
      # call_place_url
      cafe_raw = read_cafe('db/sample/cafe_nomad9.json')
      # filter by location
      regional_cafe = location_filter(cafe_raw, 'address', word_term)
      # select data column for goolge place api
      regional_cafe_name = read_cafe_attribute(regional_cafe, 'name')
      # data_cleaning
      cafe_clean_name = data_clean(regional_cafe_name)

      first_element_array = []
      first_element_array.append(cafe_clean_name[0])
      # puts "第一筆 #{first_element_array}"
      word_term.nil? ? first_element_array : cafe_clean_name # 這邊之後要加上raise error
    end
  end
end
