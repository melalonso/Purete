
class Request

  attr_accessor :title, :description

  def initialize(title, description, answer_type,
                 format_type, support_type)
    @title = title
    @description = description
    @answer_type = answer_type
    @format_type = format_type
    @support_type = support_type
  end

end