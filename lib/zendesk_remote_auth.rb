require 'digest/md5'

module ZenDesk
  module RemoteAuth
    
=begin
    REQUIRED_PARAMETERS = [:n]
      :name => :required,
      :email => :required,
      :external_id => false,
      :organization => false
    }
=end
    
    def generate_zendesk_remote_auth_url(return_url, token, params)
      #check_parameters(params)
      params[:timestamp] = Time.now.utc.to_i unless params[:timestamp]
      params[:hash] = generate_hash(token, params)

      "#{return_url}?#{params.to_query}"
    end

    private
    def generate_hash(token, params)
      str_to_hash = params[:name].clone
      str_to_hash << params[:email]
      str_to_hash << params[:external_id].to_s if params[:external_id]
      str_to_hash << params[:organization].to_s if params[:organization]
      str_to_hash << token
      str_to_hash << params[:timestamp].to_s
      Digest::MD5.hexdigest(str_to_hash)
    end
    def check_parameters(params)
      
    end
  end
end
