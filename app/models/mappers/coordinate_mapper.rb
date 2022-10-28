# frozen_string_literal: false
require_relative "../gateways/cafe_api.rb"
# require_relative 'status_mapper'
require_relative 'info_mapper' 


module Transfer
  # Provides access to contributor data
  module StoreMapper
    class DataInput
    # Get the store name array inside
      def initialize(wordterm)
        @wordterm = wordterm
      end
      
      def wordterm()
        @wordterm
      end

      def nomad()
        CafeMap::CafeNomad::InfoMapper.new("Cafe_api").load_several
      end
    end
    class DataOutput
      def initialize(wordterm)
          @nomad_obj = Transfer::StoreMapper::DataInput.new(wordterm).nomad 
          @user_wordterm = Transfer::StoreMapper::DataInput.new(wordterm).wordterm
      end

      def filtered_store
        store_array = @nomad_obj.select { |obj| obj.address.include?  @user_wordterm }.map(&:name)
        store_array.empty? ? "Warming: It's not ligit word term." : store_array
      end
    end
  end
end


# word_term = "嘉義"
# temp1 = Transfer::StoreMapper::DataOutput.new(word_term)
# puts temp1.filtered_store


