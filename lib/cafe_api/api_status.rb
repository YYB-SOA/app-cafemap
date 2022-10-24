# frozen_string_literal: true

require_relative 'api_info'

module CafeNomad
  # 這裡要做的事情是取得資料的狀態
  class Apistatus
    # 丟進來的應該是我們已經處理過的 Yaml 檔案，並且搜集資料狀態（如：status、amount、header）
    def initialize(cofanomad_data)
      @cofanomad_data = cofanomad_data
    end

    def status
      @cofanomad_data['status'] # 理論上會是 ok
    end

    def amount
      @cofanomad_data['amount'] # amount = 3488
    end

    def header
      @cofanomad_data['header'] # 取得所有 header 狀態
    end
  end
end
