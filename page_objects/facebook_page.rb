class FacebookPage < BasePage
  # Objects:
  EMAIL_FIELD = { id: 'email' }
  PASSWORD_FIELD = { id: 'pass' }
  LOGIN_BTN = { id: 'loginbutton' }
  SIDEBAR_LINKS = { css: '.linkWrap.noCount' }
  COMMENT_FIELD = { xpath: '//textarea[@placeholder="What\'s on your mind, QA?"]' }
  POST_BTN = { xpath: "//button[@data-testid='react-composer-post-button']" }
  NEW_POST = { xpath: "//div[@aria-label='News Feed']/div[1]" }

  def initialize(driver)
    super
    visit
  end

  def login_user(username, password)
    fill_out(EMAIL_FIELD, Base64.decode64(username))
    fill_out(PASSWORD_FIELD, Base64.decode64(password))
    click_on(LOGIN_BTN)
  end

  def go_to_sidebar_link(link_name)
    sidebar_links = driver.find_elements(SIDEBAR_LINKS)
    sidebar_links.each do |t|
      next unless t.text == link_name
      t.click
      break
    end
  end

  def comment_page_reached?
    wait_for { displayed?(COMMENT_FIELD) }
  end

  def make_post(message)
    fill_out(COMMENT_FIELD, message)
    wait_for { driver.find_element(POST_BTN).enabled? }
    driver.find_element(POST_BTN).click
    wait_for { driver.find_element(NEW_POST).text.include?(message) }
  end

  def validate_post(message)
    driver.find_element(NEW_POST).text.include?(message)
  end
end