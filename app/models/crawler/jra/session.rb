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
    ENV['SELENIUM_DRIVER_URL'].present? ? remote_driver : local_driver

    Capybara::Session.new(:chrome)
  end

  def local_driver
    Capybara.register_driver :chrome do |app|
      options = Selenium::WebDriver::Chrome::Options.new
      options.add_argument('window-size=1280,960')

      Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
    end
  end

  def remote_driver
    Capybara.register_driver :chrome do |app|
      url = ENV.fetch('SELENIUM_DRIVER_URL')
      options = Selenium::WebDriver::Chrome::Options.new
      options.add_argument('window-size=1280,960')
      caps = ::Selenium::WebDriver::Remote::Capabilities.chrome(
        'goog:chromeOptions' => {
          'args' => [
            'no-sandbox',
            'headless',
            'disable-gpu',
            'window-size=1280,960'
          ]
        }
      )

      Capybara::Selenium::Driver.new(app, url: url, browser: :remote, desired_capabilities: caps)
    end
  end
end
