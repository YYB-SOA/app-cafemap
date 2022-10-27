# frozen_string_literal: false

require_relative '' # 要require 元詰的mapper
require_relative '' # 要require Tim的mapper

module Transfer
  # Provides access to contributor data
  module Store
    # 資料Entity類別名為module
    class Data_Input
    # 拉資料
      def initialize(word_term)
        @word_term = word_term
      end

      def get_wordterm(@word_term)
        @word_term
      end

      def get_nomad
        # return string array
        CafeNomad::ApiInfo.new(@word_term).get_store_name
      end
    end

    class Data_Output
        nomad_store = Transfer::Store.Data_Input.get_nomad
        user_wordterm = Transfer::Store.Data_Input.get_wordterm
        def initialize(nomad_store, user_wordterm)
            @nomad_store = nomad_store 
            @user_wordterm = user_wordterm 
        end    

        def filterArray
            @nomad_store
        end

        def filterData(word_term =  @user_wordterm, filterArray = @nomad_store)
            filterArray.includes?? (word_term) == true, word_term : "Warming: It's not ligit word term."        
        end
    end
  end
end
