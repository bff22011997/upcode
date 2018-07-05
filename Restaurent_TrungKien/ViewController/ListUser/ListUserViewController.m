//
//  ListUserViewController.m
//  Restaurent_TrungKien
//
//  Created by Trung Kiên on 6/7/18.
//  Copyright © 2018 Trung Kiên. All rights reserved.
//

#import "ListUserViewController.h"
#import "ListUserTableViewCell.h"
#import "DatabaseManager.h"
#import "User.h"

@interface ListUserViewController ()

@end

@implementation ListUserViewController {
    NSMutableArray *arrUser;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [_tblView registerNib:[UINib nibWithNibName:@"ListUserTableViewCell" bundle:nil] forCellReuseIdentifier:@"ListUserTableViewCell"];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:true];
    arrUser = [[NSMutableArray alloc]init];
    arrUser = [[DatabaseManager defaultDatabaseManager] getAllUser];
    [_tblView reloadData];
}
#pragma mark Back
- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}
#pragma mark Table View
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrUser.count+1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return false;
    } else
    return true;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row !=0) {
        User *u = [arrUser objectAtIndex:indexPath.row];
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            UIAlertController * alert = [UIAlertController
                                         alertControllerWithTitle:@"Delete User From List"
                                         message:@"Are You Sure Want to Delete!"
                                         preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* yesButton = [UIAlertAction
                                        actionWithTitle:@"YES"
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action) {
                                            [[DatabaseManager defaultDatabaseManager] deleteUserWithID:u.Username];
                                            [arrUser removeObjectAtIndex:indexPath.row];
                                            [_tblView reloadData];
                                        }];
            
            UIAlertAction* noButton = [UIAlertAction
                                       actionWithTitle:@"NO"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action) {
                                           
                                       }];
            [alert addAction:yesButton];
            [alert addAction:noButton];
            
            [self presentViewController:alert animated:YES completion:nil];
            
        }
    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ListUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListUserTableViewCell"];
    
    if (indexPath.row ==0) {
        cell.lblPassword.text = @"admin";
        cell.lblUsername.text = @"admin";
    } else {
        User *u = [arrUser objectAtIndex:indexPath.row-1];
        cell.lblUsername.text = u.Username;
        cell.lblPassword.text = u.Password;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

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
