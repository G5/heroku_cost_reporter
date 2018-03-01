class Request
  def self.where(resource_path, cache_params, options = {})
    response, status = get_json(resource_path, cache_params)
    status == 200 ? response : errors(response)
  end

  # def self.get(id, cache_params)
    # response, status = get_json(id, cache_params)
    # status == 200 ? response : errors(response)
  # end

  def self.errors(response)
    error = { errors: { status: response['status'], message: response['message'] } }
    response.merge(error)
  end

  def self.get_json(root_path, cache_params)
    response =  Rails.cache.fetch(root_path, cache_params) do
      api.get(root_path)
    end

    [JSON.parse(response.body), response.status]
  end

  def self.api
    Connection.api
  end
end
