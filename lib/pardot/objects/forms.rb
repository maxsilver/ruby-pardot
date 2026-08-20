module Pardot
  module Objects
    module Forms
      def forms
        @forms ||= Forms.new self
      end

      class Forms
        def initialize(client)
          @client = client
        end

        def query(params)
          result = get '/do/query', params, 'result'
          result['total_results'] = result['total_results'].to_i if result['total_results']
          result
        end

        def read_by_id(id, params = {})
          get "/do/read/id/#{id}", params
        end

        protected

        def get(path, params = {}, result = 'form')
          response = @client.get 'form', path, params
          result ? response[result] : response
        end
      end
    end
  end
end
