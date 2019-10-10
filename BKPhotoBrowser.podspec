Pod::Spec.new do |s|
  s.name         = 'BKPhotoBrowser'
  s.summary      = 'A simple photo browser'
  s.version      = '0.0.6'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.authors      = { 'BestKai' => 'bestkai9009@gmail.com' }
  s.homepage     = 'https://github.com/BestKai/BKPhotoBrowser'
  s.platform     = :ios, '8.0'
  s.ios.deployment_target = '8.0'
  s.source       = { :git => 'https://github.com/BestKai/BKPhotoBrowser.git', :tag => s.version.to_s }
  
  s.requires_arc = true
  s.source_files = 'BKPhotoBrowser/**/*.{h,m}'
  s.public_header_files = 'BKPhotoBrowser/**/*.{h}'


  s.frameworks = 'Foundation','UIKit'
  s.dependency 'SDWebImage'

end
