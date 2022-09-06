require 'eyes_selenium'
require 'webdrivers'

options = Selenium::WebDriver::Options.ie
options.browser_version = '11'
options.platform_name = 'Windows 10'
sauce_options = {
  name: "Ruby classic test",
  build: "build",
  username: ENV['SAUCE_USERNAME'],
  access_key: ENV['SAUCE_ACCESS_KEY']
}
options.add_option('sauce:options', sauce_options)

web_driver = Selenium::WebDriver.for :remote,
                                     url: 'https://applitools-dev:' + ENV['SAUCE_ACCESS_KEY'] + '@ondemand.us-west-1.saucelabs.com:443/wd/hub',
                                     capabilities: options

classic_runner = Applitools::ClassicRunner.new

eyes = Applitools::Selenium::Eyes.new(runner: classic_runner)
eyes.send_dom = true

eyes.configure do |conf|
  conf.api_key = ENV['APPLITOOLS_API_KEY']
  conf.batch = Applitools::BatchInfo.new("Ruby RCA IE11")
  conf.app_name = 'Ruby RCA IE11'
  conf.test_name = 'Ruby RCA IE11 test'
  conf.viewport_size = Applitools::RectangleSize.new(800, 600)
end

begin
  driver = eyes.open(driver: web_driver, app_name: "Ruby test app", test_name: "Ruby test")
  driver.get('https://the-internet.herokuapp.com/dynamic_content')
  eyes.check('Dynamic Page', Applitools::Selenium::Target.window.fully)
  eyes.close
ensure
  driver.quit
  eyes.abort_async
end


