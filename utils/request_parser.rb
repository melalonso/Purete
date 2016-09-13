# Utility used to parse the request needed by the API
# to post a new information demand
class RequestParser

  def initialize(person, public_body, req_info)
    @person = person
    @public_body = public_body
    @req_info = req_info
  end

  # Parses the information using the person, public_body and req_info objects
  def parse
    @req = Hash.new
    add_person_attrs
    add_public_body_attrs
    add_req_info_attrs
    @req
  end

  def add_public_body_attrs
    @req['institucionID'] = @public_body.id
  end

  def add_person_attrs
    @req['mail'] = @person.mail
    @req['nombre'] = @person.name
    @req['apellido'] = @person.last_name
    @req['domicilio'] = @person.home
    @req['distritoID'] = @person.district_id
    @req['telefono'] = @person.phone
    @req['sexo'] = @person.gender
    @req['nacionalidad'] = @person.nationality
    @req['fechaNacimiento'] = @person.birthday
  end

  def add_req_info_attrs
    @req['titulo'] = @req_info.title
    @req['descripcion'] = @req_info.description
    @req['tipoRespuestaID'] = @req_info.answer_type
    @req['formatoID'] = @req_info.format_type
    @req['soporteID'] = @req_info.support_type
  end

  private :add_person_attrs, :add_public_body_attrs, :add_req_info_attrs

end