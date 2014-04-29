//
//  ViewController.mm
//  HelloWorld
//
//  Created by Zhang Yungui on 14-4-28.
//  Copyright (c) 2014 github.com/touchvg. All rights reserved.
//

#import "ViewController.h"
#import "GiViewHelper.h"
#import "SettingViewController.h"

@interface ViewController ()<UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIView *mainMage;
@property (weak, nonatomic) IBOutlet UIView *tempDraw;
@property (weak, nonatomic) GiPaintView* mPaintView;
@property (strong, nonatomic) NSArray* colors;
@property (strong, nonatomic) GiViewHelper *helper;
@property (strong, nonatomic) UIActionSheet *shapeSheet;
@end

@implementation ViewController

#pragma mark Initialization

- (void)viewDidLoad
{
    [super viewDidLoad];
    
   // GiViewHelper *helper = [GiViewHelper sharedInstance];
    self.mPaintView = [self.helper createGraphView:self.mainMage.bounds :self.view];
    self.helper.command = @"splines";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (GiViewHelper*)helper
{
    if (!_helper){
        _helper = [GiViewHelper sharedInstance];
    }
    return _helper;
}

- (NSArray*)colors
{
    if(!_colors){
        _colors = [[NSArray alloc] initWithObjects:[UIColor blackColor],[UIColor blueColor],[UIColor redColor],nil];
    }
    return _colors;
}


#pragma mark IBActions

- (IBAction)pencilPressed:(UIButton*)sender
{
    NSLog(@"pencilPressed ar %d",sender.tag);
    
    self.helper.lineColor = self.colors[sender.tag];
    
}
- (IBAction)eraserPressed:(id)sender
{
    NSLog(@"eraserPressed");
    self.helper.lineColor = [UIColor whiteColor];
    self.helper.lineAlpha = 1;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqual:@"segueForSetting"]){
        ((SettingViewController*)segue.destinationViewController).helper = [GiViewHelper sharedInstance:self.mPaintView];
    }
}


- (IBAction)redo:(id)sender
{
    if ([self.helper canRedo]) {
        [self.helper redo];
    }
}

- (IBAction)undo:(id)sender
{
    [self.helper undo];
}
- (IBAction)testBtn:(id)sender
{
    self.helper.command = @"line";
}

#pragma mark ActionSheet
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(actionSheet == self.shapeSheet && buttonIndex!=actionSheet.cancelButtonIndex){
        self.helper.command = [self.shapeSheet buttonTitleAtIndex:buttonIndex];
    }
}

- (UIActionSheet*)shapeSheet
{
    if(!_shapeSheet){
        _shapeSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                  delegate:self
                                         cancelButtonTitle:@"Cancle"
                                    destructiveButtonTitle:nil
                                         otherButtonTitles:@"line",@"splines", nil];
    }
    return _shapeSheet;
}

- (IBAction)choseShape:(id)sender
{
    [self.shapeSheet showInView:self.view];
}


@end
