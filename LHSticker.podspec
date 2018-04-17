#
# Be sure to run `pod lib lint LHSticker.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'LHSticker'
  s.version          = '0.1.1'
  s.summary          = '分块加载的 View 使用的协议'
  s.description      = <<-DESC
                       分块加载的 View 使用的协议.
                       DESC
  s.homepage         = 'https://github.com/loohawe/LHSticker'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'loohawe@gmail.com' => 'loohawe@gmail.com' }
  s.source           = { :git => 'git@github.com:loohawe/LHSticker.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'LHSticker/**/*.{h,m,swift}'
  
  s.resource_bundles = {
    'Resources' => ['LHSticker/**/*.{png,xib}']
  }
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'SnapKit'
  s.dependency 'SDWebImage'
end
