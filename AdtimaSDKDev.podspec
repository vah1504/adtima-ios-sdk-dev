#
#  Be sure to run `pod spec lint AdtimaSDKDev.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|
  spec.name         = 'AdtimaSDKDev'
  spec.version      = '1.7.26'
  spec.summary      = 'Adtima AdtimaSDK for Dev Mode'

  spec.description  = <<-DESC
  Adtima SDK for iOS 
  Document: https://github.com/adtima/adtima-ios-sdk/wiki
  DESC

  spec.homepage     = 'https://github.com/adtima/adtima-ios-sdk/wiki'
  spec.license      = { :type => 'MIT', :file => 'LICENSE' }
  spec.author       = { 'Khiem Nguyen' => 'khiemnd@vng.com.vn' }
  spec.source       = { :git => 'https://github.com/adtima/adtima-ios-sdk.git', :tag => '1.7.26.20190920_TPL41' }

  spec.ios.deployment_target = '8.0'
  spec.ios.vendored_frameworks = 'AdtimaSDK/Frameworks/ZAD_AdtimaMobileSDK.framework'  
  spec.xcconfig = { 'HEADER_SEARCH_PATHS' => '$(SDKROOT)/usr/include/libxml2' }
  spec.frameworks = 'CFNetwork', 'CoreGraphics', 'QuartzCore', 'StoreKit', 'AVFoundation', 'CoreMedia', 'MessageUI', 'CoreTelephony', 'AudioToolbox', 'AdSupport', 'MobileCoreServices', 'SystemConfiguration'
  spec.weak_frameworks = 'Foundation', 'MediaPlayer', 'UIKit', 'WebKit', 'CoreFoundation'
  spec.libraries = 'sqlite3.0', 'z', 'c++', 'xml2'
  spec.pod_target_xcconfig = { 'OTHER_LDFLAGS' => '-lObjC' }
  spec.dependency 'ZaloSDK'
  spec.dependency 'Google-Mobile-Ads-SDK', '~> 7.40.0'
end
