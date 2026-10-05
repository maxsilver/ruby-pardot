# frozen_string_literal: true

module Pardot
  module Objects
    module VisitorActivities
      def visitor_activities
        @visitor_activities ||= VisitorActivities.new self
      end

      class VisitorActivities
        def initialize(client)
          @client = client
        end

        def query(params)
          result = get "/do/query", params, "result"
          result["total_results"] = result["total_results"].to_i if result["total_results"]
          activities = result["visitorActivity"]
          if activities.is_a?(Array)
            activities.each { |activity| add_activity_type(activity) }
          elsif activities.is_a?(Hash)
            add_activity_type(activities)
          end
          result
        end

        def read(id, params = {})
          add_activity_type(post("/do/read/id/#{id}", params))
        end

        protected

        # Adds the documented activity type name (e.g. 'Open', 'Bounced')
        # alongside Pardot's own unreliable type_name. See VisitorActivityTypes.
        def add_activity_type(record)
          record["activity_type"] = VisitorActivityTypes.name_for(record["type"]) if record.is_a?(Hash)
          record
        end

        def get(path, params = {}, result = "visitorActivity")
          response = @client.get "visitorActivity", path, params
          result ? response[result] : response
        end

        def post(path, params = {}, result = "visitorActivity")
          response = @client.post "visitorActivity", path, params
          result ? response[result] : response
        end
      end
    end
  end
end
