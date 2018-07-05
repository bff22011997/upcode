//
//  InformationViewController.m
//  Restaurent_TrungKien
//
//  Created by Trung Kiên on 5/29/18.
//  Copyright © 2018 Trung Kiên. All rights reserved.
//

#import "InformationViewController.h"
#import "HomeViewController.h"

@interface InformationViewController ()

@end

@implementation InformationViewController {
    bool shouldStopCountDown;
    int currentValue;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _lblName.text = [NSString stringWithFormat:@"Name : %@",_namePerson];
    _lblBirthday.text = [NSString stringWithFormat:@"Birthday : %@",_birthdayPerson];
    
    NSURL *url = [NSURL URLWithString:_imgaeCoverPerson];
    NSData *data = [NSData dataWithContentsOfURL:url];
    _imageCorver.image = [UIImage imageWithData:data];
    
    
    NSURL *url1 = [NSURL URLWithString:_imageAvatarPerson];
    NSData *data1 = [NSData dataWithContentsOfURL:url1];
    _imageAvatar.image = [UIImage imageWithData:data1];
    
    currentValue = 5;
    shouldStopCountDown = NO;
    self.viewMC.textStyle               = MCPercentageDoughnutViewTextStyleUserDefined;
    self.viewMC.percentage              = 1;
    self.viewMC.linePercentage          = 0.07;
    self.viewMC.animationDuration       = 1;
    self.viewMC.showTextLabel           = YES;
    self.viewMC.animatesBegining        = YES;
    self.viewMC.textLabel.textColor     = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    shouldStopCountDown = NO;
    [MCUtil runOnAuxiliaryQueue:^{
        while (currentValue > 0 && !shouldStopCountDown)
        {
            [MCUtil runOnMainQueue:^{
                [self countDown:nil];
            }];
            [NSThread sleepForTimeInterval:1];
        }
    }];
    
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)countDown:(id)sender {
    currentValue --;
    self.viewMC.textLabel.text = [NSString stringWithFormat:@"%d", currentValue];
    self.viewMC.percentage = (float)currentValue/5.0;
    if (currentValue == 0) {
        HomeViewController *home = [[HomeViewController alloc]init];
        [self.navigationController pushViewController:home animated:true];
    }
}
- (IBAction)onBack:(id)sender {
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
