require_relative 'base_page'

class RubyGemsPage < BasePage

  # Objects:
  SEARCH_FIELD = { id: 'home_query' }
  SEARCH_ICON = { class: 'home__search__icon' }
  SEARCH_PAGE_LINK = { class: 't-link--black' }
  RESULTS = { xpath: "//a[@class='gems__gem']/span/h2" }
  RUNTIME_DEPENDENCIES = { xpath: "//div[@id='runtime_dependencies']//a[@class='t-list__item']" }
  GEM_AUTHORS = { xpath: "//div[@class='gem__members']/ul/li" }

  def initialize(driver)
    super
    visit
  end

  def search(search_item)
    fill_out(SEARCH_FIELD, search_item)
    click_on(SEARCH_ICON)
  end

  def first_search_result?(result)
    wait_for { displayed?(SEARCH_PAGE_LINK) }
    expect(page_title).to eq("search | RubyGems.org | your community gem host")
    results = driver.find_elements(RESULTS)
    results.each do |t|
      next unless t.text.include?(result)
      t.click
      break
    end
  end

  def result_page_reached?(title)
    page_title == title
  end

  def return_dependencies
    dependencies = driver.find_elements(RUNTIME_DEPENDENCIES)
    puts 'RUNTIME DEPENDENCIES:'
    dependencies.each do |d|
      puts d.text
    end
  end

  def return_authors
    authors = driver.find_element(GEM_AUTHORS).text
    puts 'AUTHORS:'
    names = authors.split(',')
    names.map! { |name| puts name.strip }
  end
end