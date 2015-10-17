Pod::Spec.new do |s|
  s.name             = "PXWebSnapshot"
  s.version          = "0.1.2"
  s.summary          = "Takes a screenshot of a website."
  s.description      = <<-DESC
                       Load the website, waits until it's fully done loading, takes a screenshot.
                       DESC
  s.homepage         = "https://github.com/pixio/PXWebSnapshot/"
  s.license          = 'MIT'
  s.author           = { "Daniel Blakemore" => "DanBlakemore@gmail.com" }
  s.source = {
   :git => "https://github.com/pixio/PXWebSnapshot.git",
   :tag => s.version.to_s
  }

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'

  s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
  s.dependency 'UIView-Screenshot'
  s.dependency 'PXUtilities'
end
