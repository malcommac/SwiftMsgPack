Pod::Spec.new do |spec|
  spec.name = 'SwiftMsgPack'
  spec.version = '0.9.0'
  spec.summary = 'MsgPack Encoder/Decoder in pure Swift'
  spec.homepage = 'https://github.com/malcommac/SwiftMsgPack'
  spec.license = { :type => 'MIT', :file => 'LICENSE' }
  spec.author = { 'Daniele Margutti' => 'me@danielemargutti.com' }
  spec.social_media_url = 'http://twitter.com/danielemargutti'
  spec.source = { :git => 'https://github.com/malcommac/SwiftMsgPack.git', :tag => "#{spec.version}" }
  spec.source_files = 'Sources/**/*.swift'
  spec.ios.deployment_target = '8.0'
  spec.osx.deployment_target = '10.10'
  spec.tvos.deployment_target = '9.0'
  spec.requires_arc = true
  spec.module_name = 'SwiftMsgPack'
end

post_install do |installer|
  installer.project.targets.each do |target|
    target.build_configurations.each do |configuration|
      target.build_settings(configuration.name)['ARCHS'] = '$(ARCHS_STANDARD_64_BIT)'
    end
  end
end