Pod::Spec.new do |s|
  s.name     = 'FPPopover'
  s.version  = '1.4'
  s.license  = 'BSD'
  s.summary  = 'This library provides an alternative to the native iOS UIPopoverController, adding support for iPhone and additional opportunities to customize the look and feel of the popovers.'
  s.homepage = 'http://www.50pixels.com/blog/labs/open-library-fppopover-ipad-like-popovers-for-iphone/'
  s.author   = { 'Alvise Susmel' => 'alvise@50pixels.com' }

  s.source   = { :git => 'https://github.com/50pixels/FPPopover.git', :tag => '1.4' }
  s.platform = :ios
  s.source_files = '*.{h,m}'

  s.frameworks = 'QuartzCore', 'UIKit'
end
