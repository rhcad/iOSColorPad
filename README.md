# iOSHelloWorld

In this tutorial, you will create a vector drawing app based on TouchVG. See [touchvg/Readme.txt](touchvg/Readme.txt) to copy files required to compile.

- Create a project with the `Single View Application` wizard.

- Add the libraries and header files of TouchVG to this project.

   - `cd' to the 'ios' directory of the [TouchVGTest](https://github.com/touchvg/TouchVGTest) project.
   - Type `./build.sh` or `./build.sh -arch arm64` to compile libraries outputed to the `ios/output` directory.
   - Add `TouchVG`, `TouchVGCore`, `libTouchVG.a` and `libTouchVGCore.a` to this project.
   - Change 'Library Search Paths' of the HelloWorld target from '.../iOSHelloWorld/touchvg' to the relative path 'touchvg'.

- Add `QuartzCore.framework` and `libc++.dylib` in 'Link Binary With Libraries' of the target.

   - Add libc++.dylib for ViewController.m or change ViewController.m to ViewController.mm to use Obj-C++ classes of TouchVG.

- Add a vector drawing view in ViewController.mm/.m:

   - Add `#import "GiViewHelper.h"` to use `helper = [GiViewHelper sharedInstance]`.
   - Add a drawing view in self.view via `[helper createGraphView:self.view.bounds :self.view];`.
   - Start the free-hand splines command via `helper.command = @"splines";`. The names of all commands will be printed in logging after the app runs.

- Enjoy the simple drawing app now! You can fork this project and add drawing UI  reference to [ColorPad wizard](http://www.raywenderlich.com/18840/how-to-make-a-simple-drawing-app-with-uikit).

## ColorPad

按照“ColorPad向导”设置绘图界面：

1. 添加按钮图片资源。我将原文的图片改小为高60，@2x的高为120，所有图片见提交历史。

2. 在一个Storyboard（Main_iPhone）中的View下插入一个全屏UIView，将其类改为GiPaintView，Label为paintView（以便在Storyboard中区分）。在Main_iPad也做同样的操作。

3. 打开Assistant Editor，在Main_iPhone中按下Ctrl拖动paintView到ViewController中，创建名为paintView的outlet属性：  

		@interface ViewController ()
		@property (weak, nonatomic) IBOutlet GiPaintView *paintView;
		@end
		@implementation ViewController

   然后切换到另一个Storyboard，在ViewController中拖动outlet到Storyboard中，建立paintView与属性的连接。

4. 在Main_iPhone中插入一个按钮到paintView上，设置类型为 Custom，去掉缺省标题文字，Image 选为 Black.png, size 属性为 10×60, 然后将按钮放到屏幕的左下角。