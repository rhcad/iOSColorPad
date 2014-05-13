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

@interface ViewController ()<UIActionSheetDelegate,GiPaintViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *ToolView;
@property (weak, nonatomic) IBOutlet GiPaintView *mainMage;
@property (weak, nonatomic) IBOutlet UIView *ButtonView;
@property (weak, nonatomic) GiPaintView *mPaintView;
@property (weak, nonatomic) IBOutlet UINavigationItem *mNavigationBar;
@property (strong, nonatomic) UIActionSheet *shapeSheet;
@end

@implementation ViewController

#pragma mark - Initialization

- (void)viewDidLoad
{
    [super viewDidLoad];
    GiViewHelper *helper = [GiViewHelper sharedInstance];
    self.mPaintView = self.mainMage;//[helper createGraphView:self.mainMage.bounds :self.mainMage];
    [helper addDelegate:self];
    helper.command = @"splines";
    [self.view bringSubviewToFront:self.ToolView];

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

@end


