
Pod::Spec.new do |s|
  s.name         = "RNExactTarget"
  s.version      = "1.0.0"
  s.summary      = "RNExactTarget"
  s.description  = <<-DESC
                  RNExactTarget
                   DESC
  s.homepage     = ""
  s.license      = "MIT"
  # s.license      = { :type => "MIT", :file => "MIT" }
  s.author             = { "author" => "Eric Nograles" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/ericnograles/react-native-sfmc-journey-builder.git", :tag => "master" }
  s.source_files  = "RNExactTarget/**/*.{h,m}"
  s.requires_arc = true


  s.dependency "React"
  #s.dependency "others"

end

  