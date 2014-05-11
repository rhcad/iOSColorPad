//
//  ViewController.mm
//  HelloWorld
//
//  Created by Zhang Yungui on 14-4-28.
//  Copyright (c) 2014 github.com/touchvg. All rights reserved.
//

#import "ViewController.h"
#import "GiViewHelper.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet GiPaintView *paintView;

- (IBAction)pencilPressed:(id)sender;
- (IBAction)eraserPressed:(id)sender;
- (IBAction)settingPressed:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    GiViewHelper *helper = [GiViewHelper sharedInstance];
    [helper createGraphView:self.view.bounds :self.view];
    helper.command = @"line";
}

#pragma mark - IBActions

- (IBAction)pencilPressed:(id)sender {
}

- (IBAction)eraserPressed:(id)sender {
}

- (IBAction)settingPressed:(id)sender {
}

@end
