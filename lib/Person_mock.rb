class Person
    attr_accessor :age
    # attr_reader :age

    def initialize( age = 18)
        @age = age
    end

end

freshman = Person.new
p freshman.age
Tiffany = Person.new(21)
p Tiffany.age

Tiffany.age=25
p Tiffany.age
