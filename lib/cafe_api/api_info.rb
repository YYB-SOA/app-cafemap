# frozen_string_literal: true

module CafeNomad
  class ApiInfo # 從 CafeNomad 的 api 從取得每一間咖啡廳的資料
    def initialize(cofanomad_data) # 這邊一樣餵進來已經處理過的 Yaml 檔，從中取得所有的店家資料。
      @cofanomad_data = cofanomad_data
    end
    def id
        @cofanomad_data['id']
    end
  
    def name
        @cofanomad_data['name']
    end
  
    def city
        @cofanomad_data['city']
    end
    def wifi_score
      @cofanomad_data['wifi']
    end

    def seat
      @cofanomad_data['seat']
    end

    def quiet
      @cofanomad_data['quiet']
    end

    def wifi_score
      @cofanomad_data['wifi']
    end

    def seat
      @cofanomad_data['seat']
    end

    def quiet
      @cofanomad_data['quiet']
    end

    def tasty
      @cofanomad_data['tasty']
    end

    def cheap
      @cofanomad_data['cheap']
    end

    def music
      @cofanomad_data['music']
    end
  end
end
