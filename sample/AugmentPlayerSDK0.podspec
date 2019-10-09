#
# Be sure to run `pod lib lint AugmentPlayerSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'AugmentPlayerSDK'
  s.version          = '5.1.3'
  s.summary          = 'Augment Player SDK lets you add Augmented Reality to your application to let your users visualize your products.'

  s.homepage         = 'https://developers.augment.com'
  s.license          = { :file => 'LICENSE' , :type => 'AugmentPlayerSDK' }
  s.author           = { 'Augment' => 'support@augment.com' }

  s.platform         = :ios
  s.swift_version    = '5.0'
  s.source           = { :http => "https://cdn.augment.com/ios-sdk/#{s.version}/AugmentPlayerSDK-#{s.version}-universal.zip" }

  s.ios.deployment_target   = '11.3'
  s.ios.vendored_frameworks = 'AugmentPlayerSDK.framework'
  s.ios.dependency 'Alamofire', '4.8.2'
  s.ios.dependency 'Moya', '13.0.1'
  s.ios.dependency 'JWTDecode'
end
