# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Direction-Sample' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
#  use_frameworks!
  pod 'GoogleMaps'
end

target 'Direction-SampleTests' do
  pod 'GoogleMaps'
end
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
      config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
    end
  end
end