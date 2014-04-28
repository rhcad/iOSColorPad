# iOSHelloWorld

In this tutorial, you will create a vector drawing app based on TouchVG.

- Create a project with the `Single View Application` wizard.

- Add the libraries and header files of TouchVG to this project.

   - `cd' to the 'ios' directory of the TouchVG project.
   - Type `./build.sh` to compile libraries outputed to the 'ios/output' directory.
   - Add `TouchVG`, `TouchVGCore`, `libTouchVG.a` and `libTouchVGCore.a` to this project.
   - Change 'Library Search Paths' of the HelloWorld target from '.../iOSHelloWorld/touchvg' to the relative path 'touchvg'.

- Add `QuartzCore.framework` and `libc++.dylib` in 'Link Binary With Libraries' of the target.

   - Add libc++.dylib for ViewController.m or change ViewController.m to ViewController.mm to use Obj-C++ classes of TouchVG.

- Add a vector drawing view in ViewController.mm/.m:

   - Add `#import "GiViewHelper.h"` to use `helper = [GiViewHelper sharedInstance]`.
   - Add a drawing view in self.view via `[helper createGraphView:self.view.bounds :self.view];`.
   - Start the free-hand splines command via `helper.command = @"splines";`. The names of all commands will be printed in logging after the app runs.

- Enjoy the simple drawing app now!
