# frozen_string_literal: false
require_relative "../gateways/cafe_api.rb"
require_relative 'info_mapper' 

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
        # return string array
        CafeMap::CafeNomad::InfoMapper.new("Cafe_api").load_several
      end
    end
    class Data_Output
      @@fake_store = ['R5小餐館','蜂巢咖啡','KURUMI哭哭咖啡二店','橋恩咖啡','心尚咖啡館','Fuelwood Coffee 燃木咖啡研究所','義大利咖啡師訓練中心']

        nomad_store = Transfer::Store.Data_Input.get_nomad
        user_wordterm = Transfer::Store.Data_Input.get_wordterm
        def initialize(user_wordterm, nomad_store = @@fake_store)
            @nomad_store = nomad_store 
            @user_wordterm = user_wordterm
        end

        def filterArray
            @nomad_store
        end

        def filtered_store(word_term =  @user_wordterm, filterArray = @nomad_store)
            filterArray.includes(word_term)? word_term : "Warming: It's not ligit word term."  
        end

    end
  end
end

# CafeNomad::CafeApi::InfoMapper.new(token, gateway_class = CafeNomad::Api).build_entity()
# find(token, gateway_class = CafeNomad::Api)
word_term = "Cafe_api"
temp1 = Transfer::StoreMapper::Data_Output.new(word_term)
puts temp1.filterData
# data = CafeMap::CafeNomad::Api
# a = CafeMap::CafeNomad::InfoMapper.new(word_term).load_several
# puts a.load_several


