//
//  SettingViewController.m
//  HelloWorld
//
//  Created by ljlin on 14-4-29.
//  Copyright (c) 2014年 github.com/touchvg. All rights reserved.
//

#import "SettingViewController.h"


@interface SettingViewController ()
@property (weak, nonatomic) IBOutlet UISlider *brushSlider;
@property (weak, nonatomic) IBOutlet UISlider *opacitySlider;

@end

@implementation SettingViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self){
        NSLog(@"settingvc initWithCoder");
    }
    return  self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    GiViewHelper *helper = [GiViewHelper sharedInstance];
    self.brushSlider.value   = helper.strokeWidth;
    self.opacitySlider.value = helper.lineAlpha;

}


- (IBAction)valueChange:(UISlider*)sender
{
    GiViewHelper *helper = [GiViewHelper sharedInstance];
    switch (sender.tag) {
        case 0:{
            helper.strokeWidth = sender.value;
            break;
        }
        case 1:{
            helper.lineAlpha = sender.value;
        }
        default:
            break;
    }

}


@end
