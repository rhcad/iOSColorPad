//
//  ViewController.mm
//  HelloWorld
//
//  Created by Zhang Yungui on 14-4-28.
//  Copyright (c) 2014 github.com/touchvg. All rights reserved.
//

#import "ViewController.h"
#import "GiViewHelper.h"
#import "GiPaintView.h"
#import "SettingViewController.h"

@interface ViewController ()<UIActionSheetDelegate, GiPaintViewDelegate,
                            UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *ToolView;
@property (weak, nonatomic) IBOutlet GiPaintView *mPaintView;
@property (weak, nonatomic) IBOutlet UIView *ButtonView;
@property (weak, nonatomic) IBOutlet UINavigationItem *mNavigationBar;
@property (strong, nonatomic) UIActionSheet *shapeSheet;
@end

@implementation ViewController

#pragma mark - Initialization

- (void)viewDidLoad
{
    [super viewDidLoad];
    GiViewHelper *helper = [GiViewHelper sharedInstance];
    [helper addDelegate:self];
    helper.command = @"splines";

    UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc]initWithTitle:@"Save"
                                                               style:UIBarButtonItemStylePlain
                                                              target:self
                                                              action:@selector(save:)];
    
    UIBarButtonItem *loadBtn = [[UIBarButtonItem alloc]initWithTitle:@"Load"
                                                               style:UIBarButtonItemStylePlain
                                                              target:self
                                                              action:@selector(load:)];
    
    NSArray *mRightBtns =[[NSArray alloc]initWithObjects:loadBtn,saveBtn, nil];
    self.mNavigationBar.rightBarButtonItems = mRightBtns;
    
    /*
    CGRect extent = helper.displayExtent;
    CGRect box    = helper.boundingBox;
    
    NSLog(@"%g %g %g %g",extent.origin.x,extent.origin.y,extent.size.width,extent.size.height);
    */
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.mPaintView dynamicShapeView:YES];
    [self.view bringSubviewToFront:self.ToolView];
    
    [super viewDidAppear:animated];
}

- (void)onFirstRegen:(id)view
{
    GiViewHelper *helper = [GiViewHelper sharedInstance];
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                          NSUserDomainMask, YES) objectAtIndex:0];
    [helper startUndoRecord:[path stringByAppendingPathComponent:@"undo"]];
}

+ (NSArray*)colors
{
    NSArray *_colors = [[NSArray alloc] initWithObjects:[UIColor blackColor],[UIColor blueColor],[UIColor redColor],nil];
    return _colors;
}

+ (NSArray*)commands
{
    //NSArray *_commands = [[NSArray alloc] initWithObjects:@"erase",@"ellipse",@"dot",@"splines",@"grid",@"select",@"circle",@"polygon",@"spline_mouse",@"arc3p",@"rect",@"diamond",@"quadrangle",@"triangle",@"arc_cse",@"square",@"line",@"lines",@"parallel",@"arc_tan", nil];
        NSArray *_commands = [[NSArray alloc] initWithObjects:@"ellipse",@"splines",@"select",@"circle",@"rect",@"quadrangle",@"triangle",@"square",@"line",@"Cancle",nil];
    return _commands;
}


#pragma mark - IBActions

- (IBAction)pencilPressed:(UIButton*)sender
{
    NSLog(@"pencilPressed ar %ld",(long)sender.tag);
    GiViewHelper *helper = [GiViewHelper sharedInstance];
    helper.lineColor = [[ViewController colors] objectAtIndex:sender.tag];
}

- (IBAction)eraserPressed:(id)sender
{
    GiViewHelper *helper = [GiViewHelper sharedInstance];
    helper.command = @"erase";
    
}

- (IBAction)redo:(id)sender
{
    GiViewHelper *helper = [GiViewHelper sharedInstance];
    [helper redo];
}

- (IBAction)undo:(id)sender
{
    GiViewHelper *helper = [GiViewHelper sharedInstance];
    [helper undo];
}
- (IBAction)addImage:(id)sender
{
    DoImagePickerController *cont = [[DoImagePickerController alloc] initWithNibName:@"DoImagePickerController" bundle:nil];
    cont.delegate = self;
    cont.nResultType = DO_PICKER_RESULT_UIIMAGE;
    cont.nMaxCount = 5;
    cont.nColumnCount = 4;
    
    [self presentViewController:cont animated:YES completion:nil];

}

+ (void)addImage:(UIImage*)image withPath:(NSString*)path andName:(NSString*)name
{
    NSData *imageData = UIImagePNGRepresentation(image);
    NSString *fullPath;
    if ([path  characterAtIndex:path.length=='/']){
        fullPath = [path stringByAppendingString:name];
    }
    else{
        fullPath = [path stringByAppendingPathComponent:name];
    }
    [imageData writeToFile:fullPath atomically:YES];
    GiViewHelper *helper = [GiViewHelper sharedInstance];
    [helper insertImageFromFile:fullPath];
}

- (IBAction)imageInfo:(id)sender
{
    GiViewHelper *helpr = [GiViewHelper sharedInstance];
    NSString *path = [helpr getImagePath];
    NSLog(@"%@",path);
}
- (IBAction)takePhoto:(id)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeCamera]==YES){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.allowsEditing = NO;
        picker.delegate = self;
        
        [self presentViewController:picker animated:YES completion:nil];

    }

}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    void (^addImage)()= ^(){
        NSString *name = [[[NSUUID UUID] UUIDString] stringByAppendingString:@".png"];
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        NSData *imageData = UIImagePNGRepresentation(image);
        NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:name];
        [imageData writeToFile:path atomically:YES];
        NSLog(@"%@",path);
        GiViewHelper *helper = [GiViewHelper sharedInstance];
        [helper insertImageFromFile:path];
    };
    [picker dismissViewControllerAnimated:YES completion:addImage];

}




- (IBAction)testBtn:(id)sender
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                          NSUserDomainMask, YES) objectAtIndex:0];
    static int order = 0;
    NSString *filename = [NSString stringWithFormat:@"%@/page%d.png", path, order++ % 10];
    
    id obj = self.mPaintView;
    
    if ([obj performSelector:@selector(exportPNG:) withObject:filename]) {
        NSString *msg = [NSString stringWithFormat:@"%@",
                         [filename substringFromIndex:[filename length] - 19]];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Save" message:msg
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}




#pragma mark - ActionSheet

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    GiViewHelper *helper = [GiViewHelper sharedInstance];
    if(actionSheet == self.shapeSheet && buttonIndex!=actionSheet.cancelButtonIndex){
        if ([[self.shapeSheet buttonTitleAtIndex:buttonIndex] isEqual:@"Cancle"]){
            return;
        }
        helper.command = [self.shapeSheet buttonTitleAtIndex:buttonIndex];
        NSLog(@"press shape sheet at index %ld title %@",(long)buttonIndex,[self.shapeSheet buttonTitleAtIndex:buttonIndex]);
    }
}

- (UIActionSheet*)shapeSheet
{
    if(!_shapeSheet){
        /*_shapeSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                  delegate:self
                                         cancelButtonTitle:@"Cancle"
                                    destructiveButtonTitle:nil
                                         otherButtonTitles:@"line",@"lines",@"select",@"splines",@"hittest", nil];
         */
        _shapeSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                  delegate:self
                                         cancelButtonTitle:nil
                                    destructiveButtonTitle:nil
                                         otherButtonTitles:nil];
        NSUInteger cmdCount = [[ViewController commands] count];
        for (int i=0; i < cmdCount ; i++) {
            NSString *cmd = [[ViewController commands] objectAtIndex:i];
            [_shapeSheet addButtonWithTitle:cmd];
            NSLog(@"%@",cmd);
        }
        NSLog(@"number of buttons = %ld  cmdCount = %lu ",(long)[_shapeSheet numberOfButtons],(unsigned long)cmdCount);
    }
    return _shapeSheet;
}

- (IBAction)choseShape:(id)sender
{
    [self.shapeSheet showInView:self.view];
}

#pragma mark - operate

- (IBAction)save:(id)sender
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                          NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filename = [NSString stringWithFormat:@"%@/mPaint", path];

    //static int fileCounter = 0;
    GiViewHelper *helper = [GiViewHelper sharedInstance];
    [helper saveToFile:filename];
}

- (IBAction)reset:(id)sender
{
    GiViewHelper *helper = [GiViewHelper sharedInstance];
    [helper clearShapes];
}

- (void)load:(id)sender
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                          NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filename = [NSString stringWithFormat:@"%@/mPaint", path];
    GiViewHelper *helper = [GiViewHelper sharedInstance];
    [helper loadFromFile:filename];
}

#pragma mark - DoImagePickerControllerDelegate
- (void)didCancelDoImagePickerController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didSelectPhotosFromDoImagePickerController:(DoImagePickerController *)picker result:(NSArray *)aSelected
{
    [self dismissViewControllerAnimated:YES completion:nil];
    static int count = 0;
    for (UIImage* image in aSelected){
        NSString *name = [NSString stringWithFormat:@"photo%d.png",count++];
        [ViewController addImage:image withPath:NSTemporaryDirectory() andName:name];
    }
    
}
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake){
        [self reset:nil];
    }
}

@end


