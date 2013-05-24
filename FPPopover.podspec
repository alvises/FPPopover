Pod::Spec.new do |s|
  s.name     = 'Kwarter-FPPopover'
  s.version  = '1.4.5'
  s.license  = 'BSD'
  s.summary  = 'Alternative to the native iOS UIPopoverController, with iPhone support and look and feel customization.'

  s.homepage = 'http://www.gingerbeard.me'
  s.author   = { 'Alvise Susmel' => 'alvise@50pixels.com' }

  s.source   = { :git => 'https://github.com/kwarter/Kwarter-FPPopover.git', :tag => '1.4.5' }
  s.platform = :ios
  s.source_files = '*.{h,m}'

  s.frameworks = 'QuartzCore', 'UIKit'
end
