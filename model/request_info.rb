
class RequestInfo

  attr_reader :title, :description, :answer_type,
                :format_type, :support_type

  def initialize(title, description, answer_type,
                 format_type, support_type)
    @title = title
    @description = description
    @answer_type = answer_type
    @format_type = format_type
    @support_type = support_type
  end

end