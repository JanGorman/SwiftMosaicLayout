Pod::Spec.new do |s|
  s.name             = 'SwiftMosaicLayout'
  s.version          = '1.0.0'
  s.summary          = 'A mosaic UICollectionViewLayout written in Swift'

  s.homepage         = 'https://github.com/JanGorman/SwiftMosaicLayout'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Jan Gorman' => 'gorman.jan@gmail.com' }
  s.source           = { :git => 'https://github.com/JanGorman/SwiftMosaicLayout.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/JanGorman'

  s.ios.deployment_target = '12.0'

  s.source_files = 'SwiftMosaicLayout/**/*'
end