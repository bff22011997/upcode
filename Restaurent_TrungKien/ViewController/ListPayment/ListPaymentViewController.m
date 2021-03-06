//
//  ListPaymentViewController.m
//  Restaurent_TrungKien
//
//  Created by Trung Kiên on 5/29/18.
//  Copyright © 2018 Trung Kiên. All rights reserved.
//

#import "ListPaymentViewController.h"
#import "HomeViewController.h"
#import "ListUserViewController.h"
#import "HistoryViewController.h"
#import "AppDelegate.h"

@interface ListPaymentViewController ()

@end

@implementation ListPaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _btnListUser.layer.cornerRadius = 8;
    _btnListPayment.layer.cornerRadius = 8;
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)onListUser:(id)sender {
    ListUserViewController *list = [[ListUserViewController alloc]init];
    [self.navigationController pushViewController:list animated:true];
}
#pragma mark Logout
- (IBAction)onBack:(id)sender {
    UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"NOTIFICATION"
        message:@"Do you want logout"
        preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"YES"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action)
                                {
                                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"check"];
                                    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"check"];
                                    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                                    [appdelegate checkViewLogin];
                                }];
    
    UIAlertAction* noButton = [UIAlertAction actionWithTitle:@"NO"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action)
                               {
                                   
                               }];
    
    [alert addAction:yesButton];
    [alert addAction:noButton];
    
    [self presentViewController:alert animated:YES completion:nil];
}
- (IBAction)onListPayment:(id)sender {
    HistoryViewController *his = [[HistoryViewController alloc]init];
    [self.navigationController pushViewController:his animated:true];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onTable:(id)sender {
    HomeViewController *home = [[HomeViewController alloc]init];
    [self.navigationController pushViewController:home animated:true];
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
