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

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *mainMage;
@property (weak, nonatomic) IBOutlet UIView *tempDraw;
@property (weak, nonatomic) GiPaintView* mPaintView;
@property (strong, nonatomic) NSArray* colors;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    GiViewHelper *helper = [GiViewHelper sharedInstance];
    self.mPaintView = [helper createGraphView:self.mainMage.bounds :self.view];
    helper.command = @"splines";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)pencilPressed:(UIButton*)sender
{
    NSLog(@"pencilPressed ar %d",sender.tag);
    
    GiViewHelper *helper = [GiViewHelper sharedInstance:self.mPaintView];
    helper.lineColor = self.colors[sender.tag];
    
}
- (IBAction)eraserPressed:(id)sender
{
    NSLog(@"eraserPressed");
}

- (NSArray*)colors
{
    if(!_colors){
        _colors = [[NSArray alloc] initWithObjects:[UIColor blackColor],[UIColor grayColor],[UIColor redColor],nil];
    }
    return _colors;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqual:@"segueForSetting"]){
        ((SettingViewController*)segue.destinationViewController).helper = [GiViewHelper sharedInstance:self.mPaintView];
    }
}
@end
