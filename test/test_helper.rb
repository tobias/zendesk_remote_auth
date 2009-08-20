require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'mocha'
require 'matchy'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'zendesk_remote_auth'

class Test::Unit::TestCase
end
