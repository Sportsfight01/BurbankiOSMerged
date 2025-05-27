# Uncomment the next line to define a global platform for your project

platform :ios, '15.0'

target 'BurbankApp' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  
  # Pods for MyPlace
  #  pod 'FBSDKCoreKit'
  #  pod 'FBSDKLoginKit'
  pod 'GoogleSignIn', "~> 5.0.0"
#  pod 'GoogleMaps'
  pod 'Google-Maps-iOS-Utils'
  #  pod "YoutubePlayer-in-WKWebView", "~> 0.2.0"
#  pod 'FirebaseAnalytics'
#  pod 'Firebase/Core'
#  pod 'FirebaseAuth'
  #  pod 'Firebase/Firestore'
#  pod 'FirebaseFirestore'
#  pod 'FirebaseCore'
  pod 'SwiftGifOrigin'
  pod 'WARangeSlider'
  #  pod 'IQKeyboardManagerSwift'
  #  pod 'MBProgressHUD'
  pod 'MBCircularProgressBar'
  #  pod 'Harpy'
  pod 'CropViewController'
  pod 'AFNetworking'
  #  pod 'ValidationComponents'
  pod 'SkeletonView'
  #pod 'ImageLoader'
  #pod 'Kingfisher'
  #  pod 'SDWebImage'
  #pod ‘SwiftRangeSlider’
  pod 'FMDB'
  #
  pod 'SideMenu'
  pod 'GrowingTextView'
  pod 'Alamofire'
  pod 'RealmSwift'
  #pod 'PagingCollectionViewLayout'
  
  target 'MyPlaceTests' do
    inherit! :search_paths
    # Pods for testing
  end
  
  target 'MyPlaceUITests' do
    # Pods for testing
  end
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'arm64'
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
        config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'

        if target.name == 'BoringSSL-GRPC'
          %w[OTHER_CFLAGS OTHER_CPLUSPLUSFLAGS WARNING_CFLAGS GCC_PREPROCESSOR_DEFINITIONS].each do |key|
            if config.build_settings[key]
              config.build_settings[key] = config.build_settings[key].gsub(/(\s|^)-G(\s|$)/, ' ')
            end
          end
        end
      end

      if target.name == 'BoringSSL-GRPC'
        target.source_build_phase.files.each do |file|
          next unless file.settings
          if file.settings['COMPILER_FLAGS']
            file.settings['COMPILER_FLAGS'] = file.settings['COMPILER_FLAGS'].gsub(/(\s|^)-G(\s|$)/, ' ')
          end
        end
      end
    end
  end


end
