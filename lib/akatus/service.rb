module Akatus

  class Service

    def send_request

      path   = self.class::PATH
      method = self.class::METHOD

      url     = Akatus.config.api_url + path + ".json"
      payload = self.to_payload

      begin

        if method == :post
          data = RestClient.post(url, payload.to_json, :content_type => :json, :accept => :json)
        elsif method == :get
          data = RestClient.get(url, { :params => payload })
        else
          raise "Invalid method: #{method}"
        end

        JSON.parse(data)['resposta']

      rescue RestClient::UnprocessableEntity => exc
        message = retrieve_message(exc.response)
        raise Akatus::UnprocessableEntityError.new(message)
      end

    end

    private
    def retrieve_message(response)
      resposta = JSON.load(response)['resposta']

      if resposta.include? 'mensagem'
        resposta['mensagem']
      else
        resposta['descricao']
      end
    end

  end

end
