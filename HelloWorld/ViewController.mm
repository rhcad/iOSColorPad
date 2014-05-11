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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    GiViewHelper *helper = [GiViewHelper sharedInstance];
    helper.command = @"line";
}

#pragma mark - IBActions

- (IBAction)pencilPressed:(id)sender {
    UIButton *btn = sender;
    GiViewHelper *helper = [GiViewHelper sharedInstance];
    
    helper.command = @"@draw";
    switch (btn.tag) {
        case 1:
            helper.lineColor = [UIColor blackColor];
            break;
        case 2:
            helper.lineColor = [UIColor redColor];
            break;
        case 3:
            helper.lineColor = [UIColor blueColor];
            break;
        case 4:
            helper.lineColor = [UIColor greenColor];
            break;
        case 5:
            helper.lineColor = [UIColor yellowColor];
            break;
        default:
            break;
    }
}

- (IBAction)eraserPressed:(id)sender {
    GiViewHelper *helper = [GiViewHelper sharedInstance];
    helper.command = @"erase";
}

- (IBAction)settingPressed:(id)sender {
}

@end
