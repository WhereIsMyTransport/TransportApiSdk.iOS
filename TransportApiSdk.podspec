#
# Be sure to run `pod lib lint TransportApiSdk.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'TransportApiSdk'
  s.version          = '0.3.0'
  s.summary          = 'SDK for the WhereIsMyTransport Transport API.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Provides a wrapper for the WhereIsMyTransport Transport API.
                       DESC

  s.homepage         = 'https://github.com/chrisk1ng/TransportApiSdk.iOS'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Chris King' => 'support@whereismytransport.com' }
  s.source           = { :git => 'https://github.com/chrisk1ng/TransportApiSdk.iOS.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/crkingza'

  s.ios.deployment_target = '8.1'

  s.source_files = 'TransportApiSdk/Classes/**/*'

  s.dependency 'RestEssentials', '~> 3.0'
  s.dependency 'SwiftyJSON'
end
