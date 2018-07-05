//
//  RegisterViewController.m
//  Restaurent_TrungKien
//
//  Created by Trung Kiên on 5/29/18.
//  Copyright © 2018 Trung Kiên. All rights reserved.
//

#import "RegisterViewController.h"
#import "DatabaseManager.h"
#import "User.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController {
    int check;
    NSMutableArray *arrUser;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    arrUser = [[NSMutableArray alloc]init];
    arrUser = [[DatabaseManager defaultDatabaseManager] getAllUser];
    UITapGestureRecognizer *tab = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenKB)];
    [self.view addGestureRecognizer:tab];
    _txtUsername.delegate = self;
    _txtPassword.delegate = self;
    _txtConfirm.delegate = self;
    // Do any additional setup after loading the view from its nib.
}
#pragma TextField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _txtUsername) {
        [_txtPassword becomeFirstResponder];
    } else if (textField == _txtPassword) {
        [_txtConfirm becomeFirstResponder];
    } else  {
        [self.view endEditing:YES];
        [self registerAccount];
    }
    return YES;
}
#pragma mark hidden KeyBoard
-(void) hiddenKB {
    [self.view endEditing:YES];
}
#pragma mark Register
-(void) registerAccount {
    if ([_txtUsername.text isEqualToString:@"admin"]) {
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"ERROR"
                                     message:@"Username already exist"
                                     preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* noButton = [UIAlertAction
                                   actionWithTitle:@"OK"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                       
                                       return ;
                                   }];
        
        [alert addAction:noButton];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    if ([_txtUsername.text isEqualToString:@""] || [_txtPassword.text isEqualToString:@""] || [_txtConfirm.text isEqualToString:@""]) {
        UIAlertController * alert =  [UIAlertController
                                      alertControllerWithTitle:@"ERROR"
                                      message:@"Enter the full information"
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"OK"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {
                                        //Handel your yes please button action here
                                        [alert dismissViewControllerAnimated:YES completion:nil];
                                        
                                    }];
        [alert addAction:yesButton];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else if (![_txtPassword.text isEqualToString:_txtConfirm.text]) {
        if (_txtUsername.text || _txtPassword.text || _txtConfirm.text) {
            UIAlertController * alert =  [UIAlertController
                                          alertControllerWithTitle:@"ERROR"
                                          message:@"Password must be as same as Confirm"
                                          preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* yesButton = [UIAlertAction
                                        actionWithTitle:@"OK"
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action)
                                        {
                                            //Handel your yes please button action here
                                            [alert dismissViewControllerAnimated:YES completion:nil];
                                            
                                        }];
            [alert addAction:yesButton];
            [self presentViewController:alert animated:YES completion:nil];
        }
    } else {
        for (int i=0; i<arrUser.count; i++) {
            User *us = [arrUser objectAtIndex:i];
            if ([_txtUsername.text isEqualToString:us.Username]) {
                UIAlertController * alert = [UIAlertController
                                             alertControllerWithTitle:@"ERROR"
                                             message:@"Username already exist"
                                             preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* noButton = [UIAlertAction
                                           actionWithTitle:@"OK"
                                           style:UIAlertActionStyleDefault
                                           handler:^(UIAlertAction * action) {
                                               
                                               return ;
                                           }];
                
                [alert addAction:noButton];
                [self presentViewController:alert animated:YES completion:nil];
                check = 1;
                break;
            }
        }
        if (check == 0) {
            User *u = [[User alloc]init];
            u.Username = _txtUsername.text;
            u.Password = _txtPassword.text;
            [[DatabaseManager defaultDatabaseManager] insertUser:u];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"checkAddUser"];
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"checkAddUser"];
            UIAlertController * alert = [UIAlertController
                                         alertControllerWithTitle:@"SUCCESS"
                                         message:@"Register success"
                                         preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* noButton = [UIAlertAction
                                       actionWithTitle:@"OK"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action) {
                                           [self.navigationController popViewControllerAnimated:true];
                                           return ;
                                       }];
            
            [alert addAction:noButton];
            check = 0;
            [self presentViewController:alert animated:YES completion:nil];
        }
        
    }
}
- (IBAction)onRegister:(id)sender {
    [self registerAccount];
    
}

#pragma mark Back
- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
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
