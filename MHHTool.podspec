#
# Be sure to run `pod lib lint commonSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MHHTool'
  s.version          = '0.0.1'
  s.summary          = 'A short description of tool.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = "UI控件封装"

  s.homepage         = 'https://github.com/15730898949/MHHTool'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '15730898949' => '15730898949@163.com' }
  s.source           = { :git => 'https://github.com/15730898949/MHHTool.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'


#指定使用arc的目录
#s.requires_arc = false
#s.requires_arc = ['commonSDK/commonSDK/Classes/**/*.m']






  #s.source_files = 'commonSDK/commonSDK/Classes/**/*.{h,m}'
  #s.source_files = 'commonSDK/commonSDK/Classes/**/*.{h,m}'

  #s.source_files  = 'commonSDK/*.{h,m}'
  #s.source_files  = 'commonSDK'
  #s.source_files  = 'commonSDK/**/*.{h,m}'
  
  #s.public_header_files = 'commonSDK/Header/*.h'

   #s.resources  = 'commonSDK/commonSDK/Classes/Frameworks/IQKeyboardManager/Resources/IQKeyboardManager.bundle'

  # s.resource_bundles = {
  #   'commonSDK' => ['commonSDK/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.dependency 'AFNetworking', '~> 2.3'
  # s.dependency 'Masonry',  '~> 1.1.0'
  # s.dependency 'SDWebImage',   '~> 3.7.6'


s.dependency 'commonSDK', '~> 0.1.8'
s.ios.vendored_frameworks='*.framework'
#s.ios.vendored_libraries='commonSDK/commonSDK/Classes/Frameworks/JPush/*.a'




#系统框架
#s.frameworks = ['UIKit', 'UserNotifications','AdSupport','Security','CoreGraphics','SystemConfiguration','CoreTelephony','CoreFoundation','CFNetwork','Foundation']
s.libraries = ['z', 'resolv']


#optional,如果指定 use_frameworks! ,则pod应包含静态库框架.
#s.static_framework = true

s.xcconfig = {'OTHER_LDFLAGS' => '-ObjC'}


end
