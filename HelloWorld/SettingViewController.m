//
//  SettingViewController.m
//  HelloWorld
//
//  Created by ljlin on 14-4-29.
//  Copyright (c) 2014年 github.com/touchvg. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()<UINavigationControllerDelegate>
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
/*
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"segueToPicker"]){
            UIImagePickerController *pickerController = segue.destinationViewController;
            pickerController.delegate = self;
            pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            pickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
            pickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    static int ord = 0;
    NSString *name = [NSString stringWithFormat:@"camera%d.png",ord++];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSData *imageData = UIImagePNGRepresentation(image);
    NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:name];
    [imageData writeToFile:path atomically:YES];
    
    GiViewHelper *helper = [GiViewHelper sharedInstance];
    [helper insertImageFromFile:path];
    [picker dismissViewControllerAnimated:YES completion:nil];
}
*/
@end
