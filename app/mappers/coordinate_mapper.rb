# frozen_string_literal: false

require_relative ''
require_relative ''

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
        filter_store = Transfer::Store.Data_Input.get_nomad
        user_wordterm = Transfer::Store.Data_Input.get_wordterm
        def initialize(filter_store, user_wordterm)
            @filter_store = filter_store 
            @user_wordterm = user_wordterm 
        end    

        def filterArray
            @filter_store
        end

        def filtered_data(word_term =  @user_wordterm, filterArray = @filter_store)
            filterArray.includes?? (word_term) == true, word_term : "Warming: It's not ligit word term."        
        end
    end
  end
end
