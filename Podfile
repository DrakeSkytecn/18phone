source 'https://github.com/CocoaPods/Specs.git'
platform :ios, "9.0"

use_frameworks!

target :"18phone" do
    pod 'R.swift', '~> 3.1.0'
    pod 'SwiftDate', '~> 4.0.5'
    pod 'ActionSheetPicker-3.0'
    pod 'RealmSwift', '~> 2.0.2'
    pod 'SwiftHTTP'
    pod 'MBProgressHUD'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
