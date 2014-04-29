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
    // Do any additional setup after loading the view.
    self.brushSlider.value = self.helper.strokeWidth;
    self.opacitySlider.value = self.helper.lineAlpha;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)valueChange:(UISlider*)sender
{

    switch (sender.tag) {
        case 0:{
            //self.helper.lineWidth = sender.value;
            self.helper.strokeWidth = sender.value;
            //NSLog(@"self.helper.strokeWidth = %g   sender.value = %g",self.helper.strokeWidth,sender.value);
            break;
        }
        case 1:{
            self.helper.lineAlpha = sender.value;
        }
        default:
            break;
    }

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
