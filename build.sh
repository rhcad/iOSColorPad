#!/bin/sh
# Type './build.sh' to make iOS libraries.
# Type './build.sh -arch arm64' to make iOS libraries for iOS 64-bit.
# Type './build.sh clean' to remove object files.

vgpath=../TouchVGTest/ios

cd $vgpath; sh build.sh $1 $2; cd ../../iOSColorPad

cp -R $vgpath/output/libTouchVG*.a touchvg
cp -R $vgpath/output/TouchVG touchvg
cp -R $vgpath/output/TouchVGCore touchvg
cp -R $vgpath/tests/Resources/TouchVG.bundle Resources/TouchVG.bundle
