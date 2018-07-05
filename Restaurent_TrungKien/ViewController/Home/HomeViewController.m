//
//  HomeViewController.m
//  Restaurent_TrungKien
//
//  Created by Trung Kiên on 5/25/18.
//  Copyright © 2018 Trung Kiên. All rights reserved.
//

#import "HomeViewController.h"
#import "CollectionViewCell.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "Common.h"
#import "Table.h"
#import "FoodViewController.h"
#import "Global.h"
#import "Ulti.h"
#import "AppDelegate.h"
@interface HomeViewController ()

@end

@implementation HomeViewController {
    NSMutableArray *arrTable;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"CollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CollectionViewCell"];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:true];
    [self getDataFromAPI];
}
#pragma mark Get data
-(void) getDataFromAPI {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    arrTable = [[NSMutableArray alloc]init];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,ALL_TABLES];
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSArray* arrResponseObjects = [responseObject objectForKey:@"data"];
        [arrTable removeAllObjects];
        for (NSDictionary *object in arrResponseObjects) {
            Table *tb = [[Table alloc]init];
            tb.tableID = [object objectForKey:@"id"];
            tb.tableOperatorId = [object objectForKey:@"operatorId"];
            tb.tableStatus = [object objectForKey:@"status"];
            [arrTable addObject:tb];
        }
        [Ulti saveArrayObjectToNSUserDefault:arrTable forkey:@"table"];
        
        [_collectionView reloadData];
        [MBProgressHUD hideAllHUDsForView:self.view animated:(YES)];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

    }];
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
#pragma mark CollectionView
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return arrTable.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((collectionView.frame.size.width-60)/3,(collectionView.frame.size.width-60)/3-20);
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell" forIndexPath:indexPath];
    Table *tb = [arrTable objectAtIndex:indexPath.row];
    cell.lblNameTable.text = tb.tableID;
    if ([tb.tableStatus intValue] == 2) {
        cell.imageTable.image = [UIImage imageNamed:@"table_not_select.png"];
        cell.lblNameTable.textColor = [UIColor lightGrayColor];
    }
    else {
        cell.imageTable.image = [UIImage imageNamed:@"table_select.png"];
        cell.lblNameTable.textColor = [UIColor redColor];
    }
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    Table *tb = [arrTable objectAtIndex:indexPath.row];
    FoodViewController *food = [[FoodViewController alloc]init];
    food.tableNumber = tb.tableID;
    [self.navigationController pushViewController:food animated:true];
}
#pragma mark Refreash
- (IBAction)onRefresh:(id)sender {
    [self getDataFromAPI];
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
