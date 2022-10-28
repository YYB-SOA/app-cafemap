# frozen_string_literal: false
require_relative "../gateways/cafe_api.rb"
# require_relative 'status_mapper'
require_relative 'info_mapper' 

word_term = '新竹市'

module Transfer
  # Provides access to contributor data
  module StoreMapper
    class Data_Input
    # 拉user input word term 資料
      def initialize(wordterm)
        @wordterm = wordterm
      end
      
      def get_wordterm()
        @wordterm
      end

      def get_nomad()
        CafeMap::CafeNomad::InfoMapper.new("Cafe_api").load_several
      end
    end
    class Data_Output      
      def initialize(wordterm)
          @@nomad_obj = Transfer::StoreMapper::Data_Input.new(wordterm).get_nomad 
          @@user_wordterm = Transfer::StoreMapper::Data_Input.new(wordterm).get_wordterm
      end

      def filtered_store
        @store_array = @@nomad_obj.select { |obj| obj.address.include?  @@user_wordterm }.map(&:name)
        @store_array.empty?? "Warming: It's not ligit word term." : @store_array 
      end

      def output_filtered_store()
        @store_array = filtered_store()
      end
    end
  end
end


token_name = "Cafe_api"
word_term = "嘉義"
temp1 = Transfer::StoreMapper::Data_Output.new(word_term)
puts temp1.output_filtered_store



