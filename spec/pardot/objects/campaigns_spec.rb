# frozen_string_literal: true

require File.expand_path("#{File.dirname(__FILE__)}/../../spec_helper")

describe Pardot::Objects::Campaigns do
  create_auth_managers.each do |auth_manager|
    context auth_manager.test_name_suffix do
      let(:client) { auth_manager.create_client }

      describe 'query' do
        def sample_results
          %(<?xml version="1.0" encoding="UTF-8"?>\n<rsp stat="ok" version="1.0">
            <result>
              <total_results>2</total_results>
              <campaign>
                <name>Asdf Campaign</name>
              </campaign>
              <campaign>
                <name>Qwerty Campaign</name>
              </campaign>
            </result>
          </rsp>)
        end

        it 'should take in some arguments' do
          fake_get '/api/campaign/version/3/do/query?id_greater_than=200&format=simple', sample_results

          expect(client.campaigns.query(id_greater_than: 200)).to eq({ 'total_results' => 2,
                                                                      'campaign' => [
                                                                        { 'name' => 'Asdf Campaign' },
                                                                        { 'name' => 'Qwerty Campaign' }
                                                                      ] })
          assert_authorization_header auth_manager
        end
      end

      describe 'create' do
        def sample_results
          %(<?xml version="1.0" encoding="UTF-8"?>\n<rsp stat="ok" version="1.0">
            <campaign>
              <id>12345</id>
              <name>Spring Sale</name>
            </campaign>
          </rsp>)
        end

        it 'should return the campaign' do
          fake_post '/api/campaign/version/3/do/create?name=Spring%20Sale&format=simple', sample_results

          expect(client.campaigns.create(name: 'Spring Sale')).to eq({ 'id' => '12345', 'name' => 'Spring Sale' })
          assert_authorization_header auth_manager
        end
      end

      describe 'read_by_id' do
        def sample_results
          %(<?xml version="1.0" encoding="UTF-8"?>\n<rsp stat="ok" version="1.0">
            <campaign>
              <id>12345</id>
              <name>Spring Sale</name>
            </campaign>
          </rsp>)
        end

        it 'should return the campaign' do
          fake_post '/api/campaign/version/3/do/read/id/12345?format=simple', sample_results

          expect(client.campaigns.read_by_id(12_345)).to eq({ 'id' => '12345', 'name' => 'Spring Sale' })
          assert_authorization_header auth_manager
        end
      end

      describe 'update_by_id' do
        def sample_results
          %(<?xml version="1.0" encoding="UTF-8"?>\n<rsp stat="ok" version="1.0">
            <campaign>
              <id>12345</id>
              <name>Summer Sale</name>
            </campaign>
          </rsp>)
        end

        it 'should return the campaign' do
          fake_post '/api/campaign/version/3/do/update/id/12345?name=Summer%20Sale&format=simple', sample_results

          expect(client.campaigns.update_by_id(12_345, name: 'Summer Sale')).to eq({ 'id' => '12345',
                                                                                    'name' => 'Summer Sale' })
          assert_authorization_header auth_manager
        end
      end

      describe 'delete_by_id' do
        def sample_results
          %(<?xml version="1.0" encoding="UTF-8"?>\n<rsp stat="ok" version="1.0">
            <campaign>
              <id>12345</id>
              <name>Spring Sale</name>
            </campaign>
          </rsp>)
        end

        it 'should return the campaign' do
          fake_post '/api/campaign/version/3/do/delete/id/12345?format=simple', sample_results

          expect(client.campaigns.delete_by_id(12_345)).to eq({ 'id' => '12345', 'name' => 'Spring Sale' })
          assert_authorization_header auth_manager
        end
      end
    end
  end
end
