require 'dry/monads'

module CafeMap
    module Service
        class ListCities
            include Dry::Monads::Result::Mixin
            def call
                cities = Repository::For.klass(Entity::Info).find_all_city
                Success(cities)
            end
            rescue StandardError
                Failure('Could not access database')
        end
    end
end