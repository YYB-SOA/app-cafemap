# frozen_string_literal: true

module Views
  # View for a single project entity
  class Store
    def initialize(store, index = nil)
      @store = store
      @index = index
    end

    def entity
      @store
    end

    def praise_link
      "/project/#{fullname}"
    end

    def index_str
      "project[#{@index}]"
    end

    def contributor_names
      @store.contributors.map(&:username).join(', ')
    end

    def owner_name
      @store.owner.username
    end

    def fullname
      "#{owner_name}/#{name}"
    end

    def http_url
      @store.http_url
    end

    def name
      @store.name
    end
  end
end
