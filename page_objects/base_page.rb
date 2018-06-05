require 'pry'

class BasePage
  attr_reader :driver

  def initialize(driver)
    @driver = driver
  end

  def wait_for(seconds=5)
    Selenium::WebDriver::Wait.new(:timeout => seconds).until { yield }
  end

  def page_title
    driver.title
  end

  def visit(url='/')
    driver.get(ENV['url'] + url)
  end

  def displayed?(locator)
    driver.find_element(locator).displayed?
  end

  def fill_out(locator, input)
    driver.find_element(locator).send_keys input
  end

end

