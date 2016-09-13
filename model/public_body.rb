# PORO of the information of a public body
class PublicBody

  attr_reader :name, :id

  def initialize(id, name)
    @id = id
    @name = name
  end

end