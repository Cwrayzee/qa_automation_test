require 'selenium-webdriver'
require 'rspec/expectations'
require 'pry'
include RSpec::Matchers

current_folder = File.expand_path('../../', __FILE__) # get absolute directory
Dir["#{current_folder}/page_objects/*.rb"].each { |f| require_relative f }

def setup
  @driver = Selenium::WebDriver.for :chrome
  ENV['url'] = 'https://rubygems.org'
end

def teardown
  @driver.quit
end

def run
  setup
  yield
  teardown
end

run {
  rubygems = RubyGemsPage.new(@driver)
  rubygems.search('ruby-debug19')
  rubygems.first_search_result?('ruby-debug19')
  expect(rubygems.result_page_reached?("ruby-debug19 | RubyGems.org | your community gem host")).to be_truthy
  puts
  rubygems.return_dependencies
  puts
  rubygems.return_authors
}