BUNDLE := com.JinyuMeng.Notch-Simulator

.PHONY: all clean

all: clean
	xcodebuild clean build CODE_SIGNING_ALLOWED=NO ONLY_ACTIVE_ARCH=NO CODE_SIGNING_REQUIRED=NO PRODUCT_BUNDLE_IDENTIFIER="$(BUNDLE)" -sdk macosx -scheme "Notch Simulator" -configuration Release -derivedDataPath build
	cp -R build/Build/Products/Release/Notch\ Simulator.app ./
clean:
		rm -rf build Notch\ Simulator.app

