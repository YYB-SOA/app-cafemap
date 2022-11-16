# frozen_string_literal: true

module Views
  # View for a single contributor
  class InfoRating
    def initialize(info)
      @info = info
    end
  
    def entity
      @info
    end
  
    def username
        @info.username
    end
  
    def github_profile_url
      "https://github.com/#{@contributor.username}"
    end
  end
end

