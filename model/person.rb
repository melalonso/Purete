class Person

  #attr_accessor :name, :last_name ...

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