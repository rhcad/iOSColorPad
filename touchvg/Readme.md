Compile libraries for iOS application:

1. `cd' to the 'ios' directory of the [TouchVGTest](https://github.com/touchvg/TouchVGTest) project.
2. Type `./build.sh` or `./build.sh -arch arm64` to compile libraries outputed to the `ios/output` directory.
3. Copy libTouchVG.a and libTouchVGCore.a to here, and copy the 'TouchVG' and 'TouchVGCore' folders too.
4. Copy TouchVG.bundle from TouchVGTest/ios/tests/Resources to here.
