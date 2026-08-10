module Pardot
  module Objects
    module Accounts
      def accounts
        @accounts ||= Accounts.new self
      end

      class Accounts
        def initialize(client)
          @client = client
        end

        def query(params)
          result = get '/do/query', params, 'result'
          result['total_results'] = result['total_results'].to_i if result['total_results']
          result
        end

        def create(params = {})
          post '/do/create', params
        end

        def read_by_id(id, params = {})
          post "/do/read/id/#{id}", params
        end

        def update_by_id(id, params = {})
          post "/do/update/id/#{id}", params
        end

        def delete_by_id(id, params = {})
          post "/do/delete/id/#{id}", params
        end

        protected

        def get(path, params = {}, result = 'account')
          response = @client.get 'account', path, params
          result ? response[result] : response
        end

        def post(path, params = {}, result = 'account')
          response = @client.post 'account', path, params
          result ? response[result] : response
        end
      end
    end
  end
end
