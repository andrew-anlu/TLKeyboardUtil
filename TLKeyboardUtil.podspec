#
# Be sure to run `pod lib lint TLKeyboardUtil.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "TLKeyboardUtil"
  s.version          = "0.0.1"
  s.summary          = "完美实现键盘弹出功能，并且适配iOS各个版本"

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!  
  s.description      = <<-DESC
                    "一款精致的工具，可以帮助你快速实现键盘的弹出，完美解决视图上的控件遮挡问题"
                       DESC

  s.homepage         = "https://github.com/andrew-anlu/TLKeyboardUtil"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Andrew" => "anluanlu123@163.com" }
  s.source           = { :git => "https://github.com/andrew-anlu/TLKeyboardUtil.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

s.source_files = 'Pod/Classes/**/*.{h,m}'
  s.resource_bundles = {
    'TLKeyboardUtil' => ['Pod/Assets/*.png']
  }

  s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
