# frozen_string_literal: true

require 'capybara'
require 'capybara/dsl'
require 'selenium-webdriver'

class Crawler::JRA::Session
  include Capybara::DSL
  # Capybara.current_session.driver.quit

  Capybara.configure do |config|
    config.default_driver = :chrome
    config.javascript_driver = :chrome
    config.save_path = Dir.pwd
  end

  def initialize
    Capybara.register_driver :chrome do |app|
      options = Selenium::WebDriver::Chrome::Options.new
      options.add_argument('window-size=1280,960')

      Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
    end

    Capybara::Session.new(:chrome)
  end
end
