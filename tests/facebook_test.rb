require 'selenium-webdriver'
require 'rspec/expectations'
require 'pry'
require 'base64'
include RSpec::Matchers

current_folder = File.expand_path('../../', __FILE__) # get absolute directory
Dir["#{current_folder}/page_objects/*.rb"].each { |f| require_relative f }

def setup
  options = Selenium::WebDriver::Chrome::Options.new
  # necessary to bypass the facebook notification pop-up
  options.add_argument('--disable-notifications')
  @driver = Selenium::WebDriver.for :chrome, options: options
  ENV['url'] = 'https://facebook.com'
end

def teardown
  @driver.quit
end

def run
  setup
  yield
  teardown
end
ENV['username'] = 'cWEuYXV0b21hdGlvbi41Mg=='
ENV['pwd'] = 'UWFBdXRvbWF0aW9uMQ=='

run {
  facebook = FacebookPage.new(@driver)
  facebook.login_user(ENV['username'], ENV['pwd'])
  facebook.go_to_sidebar_link('News Feed')
  expect(facebook.comment_page_reached?).to be_truthy
  facebook.make_post('Hello World!')
  expect(facebook.validate_post('Hello World!')).to be_truthy
}