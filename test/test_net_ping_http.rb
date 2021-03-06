#################################################################################
# test_net_ping_http.rb
#
# Test case for the Net::PingHTTP class. This should be run via the 'test' or
# 'test:http' Rake task.
#################################################################################
require 'rubygems'
gem 'test-unit'

require 'test/unit'
require 'net/ping/http'

class TC_Net_Ping_HTTP < Test::Unit::TestCase
  def setup
    @uri  = 'http://www.google.com/index.html'
    @http = Net::Ping::HTTP.new(@uri, 80, 30)      
    @bad  = Net::Ping::HTTP.new('http://www.blabfoobarurghxxxx.com') # One hopes not
  end

  test 'ping basic functionality' do
    assert_respond_to(@http, :ping)
    assert_nothing_raised{ @http.ping }
  end

  test 'ping returns a boolean value' do
    assert_boolean(@http.ping?)
    assert_boolean(@bad.ping?)
  end

  test 'ping? is an alias for ping' do
    assert_alias_method(@http, :ping?, :ping)
  end

  test 'pingecho is an alias for ping' do
    assert_alias_method(@http, :pingecho, :ping)
  end

  test 'ping should succeed for a valid website' do
    assert_true(@http.ping?)
  end

  test 'ping should fail for an invalid website' do
    assert_false(@bad.ping?)
  end

  test 'duration basic functionality' do
    assert_respond_to(@http, :duration)
    assert_nothing_raised{ @http.ping }
  end

  test 'duration returns a float value on a successful ping' do
    assert_true(@http.ping)
    assert_kind_of(Float, @http.duration)
  end

  test 'duration is nil on an unsuccessful ping' do
    assert_false(@bad.ping)
    assert_nil(@http.duration)
  end

  test 'host attribute basic functionality' do
    assert_respond_to(@http, :host)
    assert_respond_to(@http, :host=)
    assert_equal('http://www.google.com/index.html', @http.host)
  end

  test 'uri is an alias for host' do
    assert_alias_method(@http, :uri, :host)
    assert_alias_method(@http, :uri=, :host=)
  end

  test 'port attribute basic functionality' do
    assert_respond_to(@http, :port)
    assert_respond_to(@http, :port=)
  end

  test 'port attribute expected value' do
    assert_equal(80, @http.port)
  end

  test 'timeout attribute basic functionality' do
    assert_respond_to(@http, :timeout)
    assert_respond_to(@http, :timeout=)
  end

  test 'timeout attribute expected values' do
    assert_equal(30, @http.timeout)
    assert_equal(5, @bad.timeout)
  end

  test 'exception attribute basic functionality' do
    assert_respond_to(@http, :exception)
    assert_nil(@http.exception)
  end

  test 'exception attribute is nil if the ping is successful' do
    assert_true(@http.ping)
    assert_nil(@http.exception)
  end

  test 'exception attribute is not nil if the ping is unsuccessful' do
    assert_false(@bad.ping)
    assert_not_nil(@bad.exception)
  end

  test 'warning attribute basic functionality' do
    assert_respond_to(@http, :warning)
    assert_nil(@http.warning)
  end

  test 'ping with user agent' do
    @http.user_agent = "KDDI-CA32"
    assert_true(@http.ping)
  end

  def teardown
    @uri  = nil
    @http = nil
  end
end
