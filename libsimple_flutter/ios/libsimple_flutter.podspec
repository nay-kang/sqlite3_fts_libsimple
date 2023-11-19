#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint libsimple_flutter.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'libsimple_flutter'
  s.version          = '0.0.3'
  s.summary          = 'A new Flutter plugin project.'
  s.description      = <<-DESC
A new Flutter plugin project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'sqlite3','>= 3.43.1'
  s.dependency 'sqlite3/fts5'
  s.dependency 'sqlite3/perf-threadsafe'
  s.dependency 'sqlite3/rtree'
  s.platform = :ios, '13.0'
  s.vendored_libraries = 'libsimple.a'
  s.libraries = 'c++'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
end
