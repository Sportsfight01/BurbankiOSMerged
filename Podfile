# Uncomment the next line to define a global platform for your project

platform :ios, '10.0'

target 'BurbankApp' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for MyPlace
  pod 'FBSDKCoreKit'
  pod 'FBSDKLoginKit'
  pod 'GoogleSignIn', "~> 5.0.0"
  pod 'GoogleMaps'
  pod 'Google-Maps-iOS-Utils'
  pod "YoutubePlayer-in-WKWebView", "~> 0.2.0"
  pod 'FirebaseAnalytics'
  pod 'FirebaseCore'
  pod 'SwiftGifOrigin'
  pod 'WARangeSlider'
  pod 'IQKeyboardManagerSwift'
  pod 'MBProgressHUD'
  pod 'MBCircularProgressBar'
  pod 'Harpy'
  pod 'CropViewController'
  pod 'AFNetworking'
  pod 'Firebase/Auth'
  pod 'Firebase/Firestore'
  pod 'ValidationComponents'
  pod 'SkeletonView'
  #pod 'ImageLoader'
  #pod 'Kingfisher'
  pod 'SDWebImage'
  #pod ‘SwiftRangeSlider’
  pod 'FMDB'
#  pod 'Firebase/Core'
pod 'SideMenu'
pod 'GrowingTextView'
pod 'Alamofire'
#pod 'PagingCollectionViewLayout'

  target 'MyPlaceTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'MyPlaceUITests' do
    # Pods for testing
  end
  
  post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
      config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
    end
  end

end
