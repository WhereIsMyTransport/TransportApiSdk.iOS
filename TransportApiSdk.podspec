#
# Be sure to run `pod lib lint TransportApiSdk.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'TransportApiSdk'
  s.version          = '1.1.7'
  s.summary          = 'SDK for the WhereIsMyTransport Transport API.'

  s.description      = <<-DESC
Provides a wrapper for the WhereIsMyTransport Transport API.
                       DESC

  s.homepage         = 'https://github.com/WhereIsMyTransport/TransportApiSdk.iOS'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Chris King' => 'support@whereismytransport.com' }
  s.source           = { :git => 'https://github.com/WhereIsMyTransport/TransportApiSdk.iOS.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/crkingza'

  s.ios.deployment_target = '8.1'

  s.source_files = 'TransportApiSdk/Classes/**/*'

  s.dependency 'SwiftyJSON', '3.1.4'
end
