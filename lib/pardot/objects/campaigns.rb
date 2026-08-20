module Pardot
  module Objects
    module Campaigns
      def campaigns
        @campaigns ||= Campaigns.new self
      end

      class Campaigns
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
          get "/do/read/id/#{id}", params
        end

        def update_by_id(id, params = {})
          post "/do/update/id/#{id}", params
        end

        protected

        def get(path, params = {}, result = 'campaign')
          response = @client.get 'campaign', path, params
          result ? response[result] : response
        end

        def post(path, params = {}, result = 'campaign')
          response = @client.post 'campaign', path, params
          result ? response[result] : response
        end
      end
    end
  end
end
