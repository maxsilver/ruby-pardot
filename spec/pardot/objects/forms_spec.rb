# frozen_string_literal: true

require File.expand_path("#{File.dirname(__FILE__)}/../../spec_helper")

describe Pardot::Objects::Forms do
  create_auth_managers.each do |auth_manager|
    context auth_manager.test_name_suffix do
      let(:client) { auth_manager.create_client }

      describe 'query' do
        def sample_results
          %(<?xml version="1.0" encoding="UTF-8"?>\n<rsp stat="ok" version="1.0">
            <result>
              <total_results>2</total_results>
              <form>
                <name>Demo Request</name>
              </form>
              <form>
                <name>Contact Us</name>
              </form>
            </result>
          </rsp>)
        end

        it 'should take in some arguments' do
          fake_get '/api/form/version/3/do/query?id_greater_than=200&format=simple', sample_results

          expect(client.forms.query(id_greater_than: 200)).to eq({ 'total_results' => 2,
                                                                    'form' => [
                                                                      { 'name' => 'Demo Request' },
                                                                      { 'name' => 'Contact Us' }
                                                                    ] })
          assert_authorization_header auth_manager
        end
      end

      describe 'read_by_id' do
        def sample_results
          %(<?xml version="1.0" encoding="UTF-8"?>\n<rsp stat="ok" version="1.0">
            <form>
              <id>38756</id>
              <name>Demo Request</name>
            </form>
          </rsp>)
        end

        it 'should return the form' do
          fake_get '/api/form/version/3/do/read/id/38756?format=simple', sample_results

          expect(client.forms.read_by_id(38_756)).to eq({ 'id' => '38756', 'name' => 'Demo Request' })
          assert_authorization_header auth_manager
        end
      end
    end
  end
end
