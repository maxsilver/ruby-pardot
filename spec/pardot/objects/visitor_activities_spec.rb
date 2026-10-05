# frozen_string_literal: true

require File.expand_path("#{File.dirname(__FILE__)}/../../spec_helper")

describe Pardot::Objects::VisitorActivities do
  create_auth_managers.each do |auth_manager|
    context auth_manager.test_name_suffix do
      let(:client) { auth_manager.create_client }

      describe "query" do
        def sample_results
          %(<?xml version="1.0" encoding="UTF-8"?>\n<rsp stat="ok" version="1.0">
            <result>
              <total_results>2</total_results>
              <visitorActivity>
                <type>11</type>
                <type_name>Email</type_name>
                <details>Some details</details>
              </visitorActivity>
              <visitorActivity>
                <type>1</type>
                <type_name>Click</type_name>
                <details>More details</details>
              </visitorActivity>
            </result>
          </rsp>)
        end

        it "should take in some arguments" do
          fake_get "/api/visitorActivity/version/3/do/query?id_greater_than=200&format=simple", sample_results

          expect(client.visitor_activities.query(id_greater_than: 200)).to eq({"total_results" => 2,
                                                                                "visitorActivity" => [
                                                                                  {"type" => "11",
                                                                                   "type_name" => "Email",
                                                                                   "activity_type" => "Open",
                                                                                   "details" => "Some details"},
                                                                                  {"type" => "1",
                                                                                   "type_name" => "Click",
                                                                                   "activity_type" => "Click",
                                                                                   "details" => "More details"}
                                                                                ]})
          assert_authorization_header auth_manager
        end

        it "should add the documented activity_type to a single result" do
          single_result = %(<?xml version="1.0" encoding="UTF-8"?>\n<rsp stat="ok" version="1.0">
            <result>
              <total_results>1</total_results>
              <visitorActivity>
                <type>36</type>
                <type_name>Email</type_name>
                <details>Indirect bounce</details>
              </visitorActivity>
            </result>
          </rsp>)
          fake_get "/api/visitorActivity/version/3/do/query?id_greater_than=200&format=simple", single_result

          result = client.visitor_activities.query(id_greater_than: 200)
          expect(result["visitorActivity"]["activity_type"]).to eq("Indirect Bounce")
          expect(result["visitorActivity"]["type_name"]).to eq("Email")
          assert_authorization_header auth_manager
        end

        it "should label undocumented type codes as Unknown" do
          unknown_result = %(<?xml version="1.0" encoding="UTF-8"?>\n<rsp stat="ok" version="1.0">
            <result>
              <total_results>1</total_results>
              <visitorActivity>
                <type>99</type>
                <type_name>Something New</type_name>
                <details>Mystery</details>
              </visitorActivity>
            </result>
          </rsp>)
          fake_get "/api/visitorActivity/version/3/do/query?id_greater_than=200&format=simple", unknown_result

          expect(client.visitor_activities.query(id_greater_than: 200)["visitorActivity"]["activity_type"]).to eq("Unknown")
          assert_authorization_header auth_manager
        end
      end

      describe "read" do
        def sample_results
          %(<?xml version="1.0" encoding="UTF-8"?>
          <rsp stat="ok" version="1.0">
            <visitorActivity>
              <type>13</type>
              <type_name>Email</type_name>
              <details>More details</details>
            </visitorActivity>
          </rsp>)
        end

        it "should return the prospect" do
          fake_post "/api/visitorActivity/version/3/do/read/id/10?format=simple", sample_results

          expect(client.visitor_activities.read(10)).to eq({"details" => "More details", "type" => "13",
                                                             "type_name" => "Email", "activity_type" => "Bounced"})
          assert_authorization_header auth_manager
        end
      end
    end
  end
end
