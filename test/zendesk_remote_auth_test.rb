require 'test_helper'

class ZendeskRemoteAuthTest < Test::Unit::TestCase
  
  def setup
    @auth = Object.new
    @auth.extend(ZenDesk::RemoteAuth)
  end

  context 'url generation' do 
    should 'check parameters' do
      params = { }
      @auth.expects(:check_parameters).with(params)
      @auth.generate_zendesk_remote_auth_url(params)
    end
  end

  context 'required parameters' do
    should 'require name' do
      ZenDesk::RemoteAuth::PARAMETERS[:name].should == :required
    end

    should 'require email' do
      ZenDesk::RemoteAuth::PARAMETERS[:email].should == :required
    end
  end

  context 'check parameters' do
    should 'raise error when required fields are not present' do
      assert_raise ArgumentError do
        @auth.send(:check_parameters, { })
      end
    end
  end
end
