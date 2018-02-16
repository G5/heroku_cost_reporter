class Request
  class << self
    def where(resource_path, options = {})
      response, status = get_json(resource_path)
      status == 200 ? response : errors(response)
    end

    def get(id)
      response, status = get_json(id)
      status == 200 ? response : errors(response)
    end

    def errors(response)
      error = { errors: { status: response['status'], message: response['message'] } }
      response.merge(error)
    end

    def get_json(root_path)
      response = api.get(root_path)
      [JSON.parse(response.body), response.status]
    end

    def api
      Connection.api
    end
  end
end
