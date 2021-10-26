build_config:
	brew update
	bundle install
	bundle exec pod install

debug:
	xcodebuild \
	-sdk iphoneos \
	-configuration Debug \
	-workspace Direction-Sample.xcworkspace \
	-scheme Direction-Sample \
	build CODE_SIGNING_ALLOWED=NO

test:
	xcodebuild \
	-sdk iphoneos \
	-configuration Debug \
	-workspace Direction-Sample.xcworkspace \
	-scheme Direction-Sample \
	-destination 'platform=iOS Simulator,name=iPhone 12 Pro,OS=14.4' \
	clean test CODE_SIGNING_ALLOWED=NO
