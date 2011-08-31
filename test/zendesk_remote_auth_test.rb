require 'test_helper'

class ZendeskRemoteAuthTest < Test::Unit::TestCase
  
  def setup
    @auth = Object.new
    @auth.extend(Zendesk::RemoteAuthHelper)
  end
  
  context 'RemoteAuth' do
    setup do
      Zendesk::RemoteAuth.token = Zendesk::RemoteAuth.auth_url = nil
    end
    
    should 'raise exception if token is not set' do
      assert_raise ArgumentError do
        Zendesk::RemoteAuth.token
      end
    end

    should 'return the token without exception if it is set' do
      Zendesk::RemoteAuth.token = 'blah'
      Zendesk::RemoteAuth.token.should == 'blah'
    end


    should 'raise exception if auth_url is not set' do
      assert_raise ArgumentError do
        Zendesk::RemoteAuth.auth_url
      end
    end

    should 'return the auth_url without exception if it is set' do
      Zendesk::RemoteAuth.auth_url = 'blah'
      Zendesk::RemoteAuth.auth_url.should == 'blah'
    end
  end
  

  context 'url generation' do
    setup do
      Zendesk::RemoteAuth.token = 'the_token'
      Zendesk::RemoteAuth.auth_url = 'the_url'
      @valid_params = { :email => 'test@example.com', :name => 'blah'}
    end
    
    context 'required fields' do
      should 'raise an argument error the name is not provided' do
        assert_raise ArgumentError do
          @valid_params.delete(:name)
          @auth.zendesk_remote_auth_url(@valid_params)
        end
      end

      should 'raise an argument error the email is not provided' do
        assert_raise ArgumentError do
          @valid_params.delete(:email)
          @auth.zendesk_remote_auth_url(@valid_params)
        end
      end

    end
    
    should 'return a url that starts with the auth_url' do
      @auth.zendesk_remote_auth_url(@valid_params)
    end

    should 'have an empty hash param if external_id not provided' do
      @auth.zendesk_remote_auth_url(@valid_params).should =~ /hash=(&|$)/
    end

    should 'have a hash param if external_id provided' do
      @auth.zendesk_remote_auth_url(@valid_params.merge(:external_id => 'id')).should_not =~ /hash=(&|$)/
    end

    should 'have a different hash param if external_id and remote_photo_url provided ' do
      a=@auth.zendesk_remote_auth_url(@valid_params.merge(:external_id => 'id')).match(/(hash=[^&]*)/)[1]
      b=@auth.zendesk_remote_auth_url(@valid_params.merge(:external_id => 'id', :remote_photo_url => 'photo_url')).match(/(hash=[^&]*)/)[1]
      a.should_not == b
    end

    context 'given a user object' do
      setup do
        @user = mock
        @user.expects(:name).returns('a_name')
        @user.expects(:email).returns('an_email')
      end
      
      should 'pull the name from the user' do
        @auth.zendesk_remote_auth_url(@user).should =~ /name=a_name/
      end
      
      should 'pull the email from the user' do
        @auth.zendesk_remote_auth_url(@user).should =~ /email=an_email/
      end
      
      should 'pull the id from the user' do
        @user.expects(:id).returns('an_id')
        @auth.zendesk_remote_auth_url(@user).should =~ /external_id=an_id/
      end

      should 'pull the organization from the user if available' do
        @user.expects(:zendesk_organization).returns('org')
        @auth.zendesk_remote_auth_url(@user).should =~ /organization=org/
      end
      
    end
  end
end
