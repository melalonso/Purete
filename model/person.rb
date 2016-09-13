# PORO of the information of a person
class Person

  attr_reader :name, :last_name, :mail, :district_id, :home,
                :phone, :gender, :birthday, :nationality

  def initialize(name, last_name, mail, district_id, home,
                 phone, gender, birthday, nationality)
    @name = name
    @last_name = last_name
    @mail = mail
    @district_id = district_id
    @home = home
    @phone = phone
    @gender = gender
    @birthday = birthday
    @nationality = nationality
  end

end