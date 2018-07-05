//
//  OrderViewController.m
//  Restaurent_TrungKien
//
//  Created by Trung Kiên on 5/29/18.
//  Copyright © 2018 Trung Kiên. All rights reserved.
//

#import "OrderViewController.h"
#import "Global.h"
#import "Category.h"
#import "OrderTableViewCell.h"
#import "CatViewController.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "Common.h"
#import "Ulti.h"
#import "HomeViewController.h"
#import "Table.h"
#import "Food.h"

@interface OrderViewController ()

@end

@implementation OrderViewController {
    NSMutableArray *arrDelete;
    int sum;
    NSArray *arrCategory;
    UITextField *tfAddNote;
    NSMutableArray *arrSelectedFood;
    NSMutableArray *arrFoodToDelete;
    int rowcell;
    int i;
    int j;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    arrDelete = [[NSMutableArray alloc]init];
    [_tblView registerNib:[UINib nibWithNibName:@"OrderTableViewCell" bundle:nil] forCellReuseIdentifier:@"OrderTableViewCell"];
    arrSelectedFood = [[NSMutableArray alloc]init];
    arrFoodToDelete = [[NSMutableArray alloc]init];
    NSArray *arrtest = [[Ulti getArrayObjectFromNSUserDefault:ARR_FOOD_SELECTED_SAVE_KEY] mutableCopy];
    arrCategory = [[Ulti getArrayObjectFromNSUserDefault:ARR_CATEGORY_SAVE_KEY] mutableCopy];
    arrSelectedFood = [arrtest mutableCopy];
    [self reloadDataaa];
    // Do any additional setup after loading the view from its nib.
}
#pragma mark ReloadData
-(void)reloadDataaa{
    [_tblView reloadData];
    float total=0;
    for (Category *cat in arrSelectedFood) {
        total = total +[cat.priceCategory intValue] * [cat.numberNameCategory intValue];
    }
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    NSString *groupingSeparator = [[NSLocale currentLocale] objectForKey:NSLocaleGroupingSeparator];
    [formatter setGroupingSeparator:groupingSeparator];
    [formatter setGroupingSize:3];
    [formatter setAlwaysShowsDecimalSeparator:NO];
    [formatter setUsesGroupingSeparator:YES];
    NSString *formattedString = [formatter stringFromNumber:[NSNumber numberWithFloat:total]];
    _lblSumTotal.text = formattedString;

}
-(void)saveSelectedFood{
    [Ulti removeObjectForKey:ARR_FOOD_SELECTED_SAVE_KEY];
    [Ulti saveArrayObjectToNSUserDefault:arrSelectedFood forkey:ARR_FOOD_SELECTED_SAVE_KEY];
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:true];
    
}
#pragma mark TableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrSelectedFood.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (100 - tableView.bounds.size.height/5)?100:tableView.bounds.size.height/5;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Food *food = [_arrFoodImage objectAtIndex:[_indexImage intValue]];
    OrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    Category *cat = [arrSelectedFood objectAtIndex:indexPath.row];
    NSURL *url = [NSURL URLWithString:food.foodImage];
    NSData *data = [NSData dataWithContentsOfURL:url];
    cell.imageFood.image = [UIImage imageWithData:data];
    cell.lblNameCategory.text = cat.nameCategory;
    cell.lblPriceCategory.text = cat.priceCategory;
    cell.lblNumber.text = cat.numberNameCategory;
    cell.accessoryType = cat.isSelected ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    [cell.btnPlus addTarget:self action:(@selector(onPlus:)) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnMinus addTarget:self action:(@selector(onMinus:)) forControlEvents:UIControlEventTouchUpInside];
    cell.btnPlus.tag = indexPath.row;
    cell.btnMinus.tag = indexPath.row;
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    NSString *groupingSeparator = [[NSLocale currentLocale] objectForKey:NSLocaleGroupingSeparator];
    [formatter setGroupingSeparator:groupingSeparator];
    [formatter setGroupingSize:3];
    [formatter setAlwaysShowsDecimalSeparator:NO];
    [formatter setUsesGroupingSeparator:YES];
    NSString *formattedString = [formatter stringFromNumber:[NSNumber numberWithFloat:[[NSString stringWithFormat:@"%d",[cat.priceCategory intValue] * [cell.lblNumber.text intValue]] intValue]]];
    
    cell.lblPrice.text = formattedString;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Category *cat = [arrSelectedFood objectAtIndex:indexPath.row];
    cat.isSelected = !cat.isSelected;
    if (cat.isSelected) {
        [arrFoodToDelete addObject:cat];
    } else {
        [arrFoodToDelete removeObject:cat];
    }
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    [_tblView reloadData];
}
#pragma mark Plus
- (IBAction)onPlus:(id)sender {
    int i = (int)[sender tag];
    Category *obj = [arrSelectedFood objectAtIndex:i];
    int value = [obj.numberNameCategory intValue];
    obj.numberNameCategory = [NSString stringWithFormat:@"%@",[NSNumber numberWithInt:value + 1]];
    [arrSelectedFood replaceObjectAtIndex:i withObject:obj];
    [_tblView reloadData];
    sum = 0;
    for (Category *cat in arrSelectedFood) {
        sum += [cat.priceCategory intValue] * [cat.numberNameCategory intValue];
    }
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    NSString *groupingSeparator = [[NSLocale currentLocale] objectForKey:NSLocaleGroupingSeparator];
    [formatter setGroupingSeparator:groupingSeparator];
    [formatter setGroupingSize:3];
    [formatter setAlwaysShowsDecimalSeparator:NO];
    [formatter setUsesGroupingSeparator:YES];
    NSString *formattedString = [formatter stringFromNumber:[NSNumber numberWithFloat:sum]];
    _lblSumTotal.text = formattedString;
    
    
}
#pragma Minus
- (IBAction)onMinus:(id)sender {
    int i = (int)[sender tag];
    Category *obj = [arrSelectedFood objectAtIndex:i];
    int value = [obj.numberNameCategory intValue];
    if (value > 0) {
        value--;
    } else {
        value = 0;
    }
    obj.numberNameCategory = [NSString stringWithFormat:@"%@",[NSNumber numberWithInt:value]];
    [arrSelectedFood replaceObjectAtIndex:i withObject:obj];
    [_tblView reloadData];
    sum = 0;
    for (Category *cat in arrSelectedFood) {
        sum += [cat.priceCategory intValue] * [cat.numberNameCategory intValue];
    }
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    NSString *groupingSeparator = [[NSLocale currentLocale] objectForKey:NSLocaleGroupingSeparator];
    [formatter setGroupingSeparator:groupingSeparator];
    [formatter setGroupingSize:3];
    [formatter setAlwaysShowsDecimalSeparator:NO];
    [formatter setUsesGroupingSeparator:YES];
    NSString *formattedString = [formatter stringFromNumber:[NSNumber numberWithFloat:sum]];
    _lblSumTotal.text = formattedString;
}
#pragma mark Back
- (IBAction)onBack:(id)sender {
    [self saveSelectedFood];
    [self.navigationController popViewControllerAnimated:true];
}
#pragma mark Delete
- (IBAction)onDelete:(id)sender {
    [arrSelectedFood removeObjectsInArray:arrFoodToDelete];
    [self reloadDataaa];
}
#pragma mark Order
- (IBAction)onOrder:(id)sender {    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,ADD_BOOKING];
    NSDictionary *parameters = @{@"data" : [self createArrayDictionaries]};
    NSString *strJson = [Ulti convertDictionaryToString:parameters];
    NSDictionary *final = @{@"json":strJson};
    [manager POST:urlStr parameters:final success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self performSelectorOnMainThread:@selector(paidMoney) withObject:nil waitUntilDone:NO];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}
#pragma mark Update Status
-(void)paidMoney{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,UP_STATUS];
    NSDictionary *parameters = @{@"TableId" : _tableNumber,
                                 @"status":@"1"};
    [manager GET:urlStr parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Succsess"
                                     message:@"Success"
                                     preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* noButton = [UIAlertAction
                                   actionWithTitle:@"OK"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                       [self.navigationController popViewControllerAnimated:true];
                                       return ;
                                   }];
        
        [alert addAction:noButton];
        [self presentViewController:alert animated:YES completion:^ {
            [self performSelectorOnMainThread:@selector(btnHomeClick:) withObject:nil waitUntilDone:NO];
        }];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }];
}
-(NSArray*)createArrayDictionaries{
    NSMutableArray *arrDictionnaries = [[NSMutableArray alloc]init];
    if (![[NSUserDefaults standardUserDefaults] stringForKey:_tableNumber].length){
        NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
        NSNumber *timeStampObj = [NSNumber numberWithDouble: timeStamp];
        NSString *timeStampString = [NSString stringWithFormat:@"%.0f",[timeStampObj floatValue]];
        [[NSUserDefaults standardUserDefaults] setObject:timeStampString forKey:_tableNumber];
    }
    for (Category *obj in arrSelectedFood) {
        NSDictionary *objectFoodDictionary =@{NUMBER_CART:obj.numberNameCategory,
                                              PRICE:obj.priceCategory,
                                              CART_NAME:obj.nameCategory,
                                              @"cartID":[[NSUserDefaults standardUserDefaults] stringForKey:_tableNumber],
                                              TABLE_ID:_tableNumber,
                                              NOTE:@"",
                                              PRODUCT_ID:obj.IDCategory};
        [arrDictionnaries addObject:objectFoodDictionary];
    }
    return arrDictionnaries;
    
}
#pragma mark Home
- (IBAction)btnHomeClick:(id)sender {
    for (UIViewController *controller in self.navigationController.viewControllers)
    {
        if ([controller isKindOfClass:[HomeViewController class]])
        {
            [self.navigationController popToViewController:controller animated:YES];
            
            break;
        }
    }
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
