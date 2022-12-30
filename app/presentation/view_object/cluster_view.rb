# frozen_string_literal: true

module Views
  # View for a single info entity
  class ClusterData
    def initialize(cluster_data)
      @cluster = cluster_data
    end

    def entity
      @cluster
    end

    def wifi_mean
      arr = @cluster.map(&:wifi).map(&:to_f)
      (arr.reduce(:+) / arr.size.to_f).round(1)
    end

    def seat_mean
      arr = @cluster.map(&:seat).map(&:to_f)
      (arr.reduce(:+) / arr.size.to_f).round(1)
    end

    def tasty_mean
      arr = @cluster.map(&:tasty).map(&:to_f)
      (arr.reduce(:+) / arr.size.to_f).round(1)
    end

    def cheap_mean
      arr = @cluster.map(&:cheap).map(&:to_f)
      (arr.reduce(:+) / arr.size.to_f).round(1)
    end

    def music_mean
      arr = @cluster.map(&:music).map(&:to_f)
      (arr.reduce(:+) / arr.size.to_f).round(1)
    end

    def quiet_mean
      arr = @cluster.map(&:quiet).map(&:to_f)
      (arr.reduce(:+) / arr.size.to_f).round(1)
    end
  end
end
