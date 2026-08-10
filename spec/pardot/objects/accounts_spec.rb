# frozen_string_literal: true

require File.expand_path("#{File.dirname(__FILE__)}/../../spec_helper")

describe Pardot::Objects::Accounts do
  create_auth_managers.each do |auth_manager|
    context auth_manager.test_name_suffix do
      let(:client) { auth_manager.create_client }

      describe 'query' do
        def sample_results
          %(<?xml version="1.0" encoding="UTF-8"?>\n<rsp stat="ok" version="1.0">
            <result>
              <total_results>2</total_results>
              <account>
                <name>Acme Corp</name>
              </account>
              <account>
                <name>Globex</name>
              </account>
            </result>
          </rsp>)
        end

        it 'should take in some arguments' do
          fake_get '/api/account/version/3/do/query?id_greater_than=200&format=simple', sample_results

          expect(client.accounts.query(id_greater_than: 200)).to eq({ 'total_results' => 2,
                                                                      'account' => [
                                                                        { 'name' => 'Acme Corp' },
                                                                        { 'name' => 'Globex' }
                                                                      ] })
          assert_authorization_header auth_manager
        end
      end

      describe 'create' do
        def sample_results
          %(<?xml version="1.0" encoding="UTF-8"?>\n<rsp stat="ok" version="1.0">
            <account>
              <id>12345</id>
              <name>Acme Corp</name>
            </account>
          </rsp>)
        end

        it 'should return the account' do
          fake_post '/api/account/version/3/do/create?name=Acme%20Corp&format=simple', sample_results

          expect(client.accounts.create(name: 'Acme Corp')).to eq({ 'id' => '12345', 'name' => 'Acme Corp' })
          assert_authorization_header auth_manager
        end
      end

      describe 'read_by_id' do
        def sample_results
          %(<?xml version="1.0" encoding="UTF-8"?>\n<rsp stat="ok" version="1.0">
            <account>
              <id>12345</id>
              <name>Acme Corp</name>
            </account>
          </rsp>)
        end

        it 'should return the account' do
          fake_post '/api/account/version/3/do/read/id/12345?format=simple', sample_results

          expect(client.accounts.read_by_id(12_345)).to eq({ 'id' => '12345', 'name' => 'Acme Corp' })
          assert_authorization_header auth_manager
        end
      end

      describe 'update_by_id' do
        def sample_results
          %(<?xml version="1.0" encoding="UTF-8"?>\n<rsp stat="ok" version="1.0">
            <account>
              <id>12345</id>
              <name>Acme Worldwide</name>
            </account>
          </rsp>)
        end

        it 'should return the account' do
          fake_post '/api/account/version/3/do/update/id/12345?name=Acme%20Worldwide&format=simple', sample_results

          expect(client.accounts.update_by_id(12_345, name: 'Acme Worldwide')).to eq({ 'id' => '12345',
                                                                                      'name' => 'Acme Worldwide' })
          assert_authorization_header auth_manager
        end
      end

      describe 'delete_by_id' do
        def sample_results
          %(<?xml version="1.0" encoding="UTF-8"?>\n<rsp stat="ok" version="1.0">
            <account>
              <id>12345</id>
              <name>Acme Corp</name>
            </account>
          </rsp>)
        end

        it 'should return the account' do
          fake_post '/api/account/version/3/do/delete/id/12345?format=simple', sample_results

          expect(client.accounts.delete_by_id(12_345)).to eq({ 'id' => '12345', 'name' => 'Acme Corp' })
          assert_authorization_header auth_manager
        end
      end
    end
  end
end
