Pod::Spec.new do |spec|
    spec.name = "L13MessageKit"
    spec.version = "1.0.0"
    spec.summary = "Simple framework to communicate with user's"

    spec.description  = <<-DESC
                           A lightweight, simple framework to create, present, and manage messages with in an application
                        DESC

    spec.homepage = "https://github.com/Lucky13Tech/L13MessageKit"
    spec.license = { :type => "MIT", :file => "LICENSE" }

    spec.author       = "Luke Davis"
    spec.ios.deployment_target = "9.0"
    # spec.osx.deployment_target = "10.9"
    # spec.tvos.deployment_target = '9.0'

    spec.source = { :git => "https://github.com/Lucky13Tech/L13MessageKit.git", :tag => "v#{spec.version}" }
    spec.source_files = "L13MessageKit/**/*.{swift,h,m}"

    spec.public_header_files = [
        'L13MessageKit/L13MessageKit.h',
        ]

   spec.exclude_files = [
       ]

    spec.framework = "XCTest"
    spec.requires_arc = true
    spec.pod_target_xcconfig = { 'ENABLE_BITCODE' => 'NO' }
end
