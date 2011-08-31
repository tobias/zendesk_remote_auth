require 'digest/md5'
require 'active_support' #gives us Hash.to_query

##
# Provides a helper to use Zendesk's SSO/remote auth service.
# see: http://www.zendesk.com/api/remote_authentication
module Zendesk

  ##
  # Handles storing the token and auth_url (endpoint) for the Zendesk side.
  class RemoteAuth
    class << self
      attr_writer :auth_url, :token

      def token
        raise ArgumentError.new('Zendesk token must be set. Set with Zendesk::RemoteAuth.token = <token>') unless @token
        @token
      end

      def auth_url
        raise ArgumentError.new('Zendesk auth_url must be set. Set with Zendesk::RemoteAuth.auth_url = <url>') unless @auth_url
        @auth_url
      end
    end
  end

  ##
  # Provides the method that generates the auth url. Mixin where required.
  module RemoteAuthHelper
    ##
    # Takes a hash of parameters and generates the hashed auth
    # url. The hash must include the :name and :email for the user.
    # See: http://www.zendesk.com/api/remote_authentication for a list
    # of all of the parameters.
    #
    # If the :timestamp is not provided, Time.now will be used. If an
    # :external_id is provided, then the :hash will be generated.
    #
    # As a convenience, a user object can be passed instead, but must
    # respond_to? at least :email and :name. The :id of the user
    # object will be used as the :external_id, and if the user
    # responds to :zendesk_organization, that will be used as the
    # :organization. 
    def zendesk_remote_auth_url(user_or_params)
      params = user_or_params.is_a?(Hash) ? user_or_params : user_to_params(user_or_params)
      validate_params(params)
      params[:timestamp] = Time.now.utc.to_i unless params[:timestamp]
      params[:hash] = params[:external_id] ? generate_hash(Zendesk::RemoteAuth.token, params) : ''

      "#{Zendesk::RemoteAuth.auth_url}?#{params.to_query}"
    end

    private
    def user_to_params(user)
      params = { }
      [[:email, :email],
       [:name, :name],
       [:external_id, :id],
       [:organization, :zendesk_organization]].each do |param, field|
        params[param] = user.send(field) if user.respond_to?(field)
      end
      params
    end

    def validate_params(params)
      [:email, :name].each do |param|
        raise ArgumentError.new("Required parameter :#{param} not given") unless params[param]
      end
    end
    
    def generate_hash(token, params)
      str_to_hash = params[:name].clone
      str_to_hash << params[:email]
      str_to_hash << params[:external_id].to_s if params[:external_id]
      str_to_hash << params[:organization].to_s if params[:organization]
      str_to_hash << params[:remote_photo_url].to_s if params[:remote_photo_url]
      str_to_hash << token
      str_to_hash << params[:timestamp].to_s
      Digest::MD5.hexdigest(str_to_hash)
    end

  end
end
