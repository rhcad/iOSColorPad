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

void outputrect(CGRect t)
{
    NSLog(@"orgin=(x=%g,y=%g),size=(=%g,height=%g)",t.origin.x,t.origin.y,t.size.width,t.size.height);
}


@interface ViewController ()<UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIView *mainMage;
@property (weak, nonatomic) GiPaintView *mPaintView;
@property (weak, nonatomic) IBOutlet UIView *ButtonView;
@property (strong, nonatomic) UIActionSheet *shapeSheet;
@end




@implementation ViewController

#pragma mark - Initialization

- (void)viewDidLoad
{
    [super viewDidLoad];
    GiViewHelper *helper = [GiViewHelper sharedInstance];
    self.mPaintView = [helper createGraphView:self.mainMage.frame :self.view];
    helper.command = @"splines";
}

- (void)onFirstRegen:(id)view
{
    NSLog(@"- (void)onFirstRegen:(id)view ");
    GiViewHelper *helper = [GiViewHelper sharedInstance];
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                          NSUserDomainMask, YES) objectAtIndex:0];
    [helper startUndoRecord:[path stringByAppendingPathComponent:@"undo"]];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    self.mPaintView.frame = self.mainMage.frame;
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
    outputrect(self.mainMage.frame);
    outputrect(self.ButtonView.frame);
    NSLog(@"pencilPressed ar %ld",(long)sender.tag);

    GiViewHelper *helper = [GiViewHelper sharedInstance];
    helper.lineColor = [[ViewController colors] objectAtIndex:sender.tag];
    
    
}
- (IBAction)eraserPressed:(id)sender
{
    NSLog(@"eraserPressed");
    
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
    NSLog(@"undo button pressed");
    GiViewHelper *helper = [GiViewHelper sharedInstance];
    [helper undo];
}
- (IBAction)testBtn:(id)sender
{

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
    static int fileCounter = 0;
    GiViewHelper *helper = [GiViewHelper sharedInstance];
    [helper saveToFile:[NSString stringWithFormat:@"vgfile%d",fileCounter++ ]];
}

- (IBAction)reset:(id)sender
{
    GiViewHelper *helper = [GiViewHelper sharedInstance];
    [helper clearShapes];
}

@end
