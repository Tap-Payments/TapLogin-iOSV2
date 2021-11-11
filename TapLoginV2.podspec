Pod::Spec.new do |tapLogin|
    
    tapLogin.platform = :ios
    tapLogin.ios.deployment_target = '10.0'
    tapLogin.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.1' }
    tapLogin.name = 'TapLoginV2'
    tapLogin.summary = 'Whole login flow for Tap iOS applications.'
    tapLogin.requires_arc = true
    tapLogin.version = '1.0.3'
    tapLogin.license = { :type => 'MIT', :file => 'LICENSE' }
    tapLogin.author = { 'Osama Rabie' => 'o.rabie@tap.company' }
    tapLogin.homepage = 'https://github.com/Tap-Payments/TapLogin-iOSV2'
    tapLogin.source = { :git => 'https://github.com/Tap-Payments/TapLogin-iOSV2.git', :tag => tapLogin.version.to_s }
    tapLogin.source_files = 'TapLogin/Source/*.swift'
    tapLogin.ios.resource_bundle = { 'TapLoginResources' => 'TapLogin/Resources/*.{storyboard,xcassets}' }
    
    tapLogin.dependency 'EditableTextInsetsTextFieldV2'
    tapLogin.dependency 'TapAdditionsKitV2'
    tapLogin.dependency 'TapBrandBookIOSV2'
    tapLogin.dependency 'TapCountriesKit-UIV2'
    tapLogin.dependency 'TapLocalization-UIV2'
    tapLogin.dependency 'TapMessagingV2'
    tapLogin.dependency 'TapSwiftFixesV2'
    tapLogin.dependency 'TapVideoManagerV2'
    tapLogin.dependency 'TapViewControllerV2'
    tapLogin.dependency 'Toast-Swift'
    
end
