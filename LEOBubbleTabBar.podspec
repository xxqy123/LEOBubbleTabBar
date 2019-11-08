
Pod::Spec.new do |spec|

  spec.name         = "LEOBubbleTabBar"
  spec.version      = "0.1.0"
  spec.summary      = "A custom TabBar with bubble animation when selecting"
  spec.homepage     = "https://github.com/xxqy123/LEOBubbleTabBar"
  spec.license      = "MIT"
  spec.author             = { "xxqy" => "xqy0609@126.com" }
  spec.social_media_url   = "https://xxqy.fun"
  spec.platform     = :ios, "9.0"
  spec.source       = { :git => "https://github.com/xxqy123/LEOBubbleTabBar.git", :tag => spec.version.to_s }
  spec.source_files  = "LEOBubbleTabBar/**/*.{h,m}"
end
