require 'minitest/spec'
require 'minitest/autorun' # 把 minitest/autorun require 進來：
require_relative '../main/Person.rb'


class AgeTest < Minitest::Test # 注意: Class名稱需要是大寫開頭
    def test_default_age # 注意: 需要以test開頭
        human = Person.new
        assert_equal 18, human.age
    end

    # test "default_age" do
    #     human = Person.new
    #     assert_equal 18, human.age
    # end
end
