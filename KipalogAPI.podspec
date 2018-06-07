Pod::Spec.new do |s|

  s.name         = "KipalogAPI"
  s.version      = "0.0.1"
  s.summary      = "Swift wrapper for Kipalog API"
  s.description  = "Swift wrapper for Kipalog API (http://kipalog.com)"
  s.homepage     = "https://github.com/nam-dh/kipalog-api-swift"
  s.license      = "MIT"
  s.author       = { "Nam Doan" => "namdoanhoai89@gmail.com" }

  s.platform     = :ios, "9.0"
  s.source       = { :git => "https://github.com/nam-dh/kipalog-api-swift", :tag => s.version }
  s.source_files = "KipalogAPI/*.swift", "KipalogAPI/**/*.swift"
  s.requires_arc = true

end
