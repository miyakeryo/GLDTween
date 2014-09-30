#
#  Be sure to run `pod spec lint GLDTween.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = "GLDTween"
  s.version      = "0.0.1"
  s.platform     = :ios, "7.0"
  s.license      = { :type => "MIT", :file => "FILE_LICENSE" }
  s.summary      = "Fancy Animation Engine for iOS written with Swift"

  s.description  = <<-DESC
                   iOS needs better animation engine. CAAnimation is not so handy, so we did.
                   DESC

  s.homepage     = "https://github.com/theguildjp/GLDTween"


  s.author             = { "Takayuki Fukatsu" => "fukatsu@gmail.com" }
  s.social_media_url   = "http://twitter.com/fladdict"


  s.requires_arc = true

  s.source       = { :git => "https://github.com/theguildjp/GLDTween.git", :tag => "0.0.1" }


  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  CocoaPods is smart about how it includes source code. For source files
  #  giving a folder will include any h, m, mm, c & cpp files. For header
  #  files it will include any header in the folder.
  #  Not including the public_header_files will make all headers public.
  #

  s.source_files  = "GLDTween/**/*.{h,m,swift}"



end
