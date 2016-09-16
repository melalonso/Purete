# Utility used to parse the request needed by the API
# to post a new information demand
class RequestParser

  def initialize(info_request, outgoing_message)
    @info_request = info_request
    @outgoing_message = outgoing_message
  end

  # Parses the information using the info_request and outgoing_message objects
  def parse
    @req = Hash.new
    add_info_request_attrs
    add_outgoing_message_attrs
    add_other_values
    @req
  end

  def add_outgoing_message_attrs
    @req['descripcion'] = @outgoing_message.body
  end

  def add_info_request_attrs
    @req['titulo'] = @info_request.title
    @req['nombre'] = @info_request.user.name
    @req['mail'] = @info_request.user.email
  end

  def add_other_values
    @req['apellido'] = ' ' # Waiting for response
    @req['institucionID'] = 1 # -> DB

    @req['domicilio'] = '' # Waiting for response
    @req['distritoID'] = 1 # Waiting for response

    @req['nacionalidad'] = '' # Waiting for response

    @req['tipoRespuestaID'] = 1 # Via email
    @req['formatoID'] = 0 # None of the available
    @req['soporteID'] = 2 # Digital Media

    # Non obligatory according to
    # http://informacionpublica.paraguay.gov.py/portal/#!/hacer_solicitud#busqueda
    @req['telefono'] = ''
    @req['sexo'] = ''
    @req['fechaNacimiento'] = ''
  end

  private :add_outgoing_message_attrs, :add_info_request_attrs, :add_other_values

end