#
# Be sure to run `pod lib lint JZTPerformanceMonitor.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'JZTPerformanceMonitor'
  s.version          = '1.1.1'
  s.summary          = 'JZTPerformanceMonitor. 检测性能 抓包 崩溃记录'
  s.homepage         = 'https://github.com/LZRight123/JZTPerformanceMonitor'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '350442340@qq.com' => '350442340@qq.com' }
  s.source           = { :git => 'https://github.com/LZRight123/JZTPerformanceMonitor.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'

  s.source_files = 'JZTPerformanceMonitor/**/*.{h,m}'
  s.resource = 'JZTPerformanceMonitor/JZTPerformanceMonitor.bundle'

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'Social', 'CoreTelephony'
  s.dependency 'YYKit'
  s.dependency 'Masonry'
  s.dependency 'MBProgressHUD'
  s.dependency 'MJRefresh'
  s.requires_arc = true
end
