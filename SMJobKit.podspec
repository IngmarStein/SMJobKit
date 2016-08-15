Pod::Spec.new do |s|
  s.name         = "SMJobKit"
  s.version      = "0.0.14"
  s.summary      = "Framework that simplifies SMJobBless."
  s.homepage     = "https://github.com/IngmarStein/SMJobKit"
  s.authors      = { "Ian MacLeod" => "ian@nevir.net", "Ingmar Stein" => "IngmarStein@gmail.com" }
  s.source       = { :git => "https://github.com/IngmarStein/SMJobKit.git", :tag => "0.0.14" }
  s.platform     = :osx, 10.9
  s.source_files = 'Sources/**/*.{h,swift}'
  s.framework    = 'ServiceManagement', 'Security'
  s.requires_arc = true
  s.public_header_files = 'Sources/*.h'
  s.license      = { :type => "Apache License, Version 2.0", :file => "LICENSE.txt" }
  s.description  = <<-DESC
Using SMJobBless and friends is rather ...painful. SMJobKit does everything in its power to alleviate that and get you back to writing awesome OS X apps.

SMJobKit is more than just a framework/library to link against. It gives you:
- A Xcode target template for SMJobBless-ready launchd services, completely configured for proper code signing!
- A client abstraction that manages installing/upgrading your app's service(s).
- A service library that pulls in as little additional code as possible. Less surface area for security vulnerabilities!
DESC
end
