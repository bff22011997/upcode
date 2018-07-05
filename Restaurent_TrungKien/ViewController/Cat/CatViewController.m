//
//  CatViewController.m
//  Restaurent_TrungKien
//
//  Created by Trung Kiên on 5/29/18.
//  Copyright © 2018 Trung Kiên. All rights reserved.
//

#import "CatViewController.h"
#import "Global.h"
#import "Category.h"
#import "CatTableViewCell.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "Common.h"
#import "Category.h"
#import "HomeViewController.h"
#import "history.h"
#import "Ulti.h"
@interface CatViewController ()

@end

@implementation CatViewController {
    NSMutableArray *arrFoodOrdered;
    NSMutableArray *arrHistoty;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    arrHistoty = [[NSMutableArray alloc]init];
    NSArray *arr = [[Ulti getArrayObjectFromNSUserDefault:@"history"] mutableCopy];
    arrHistoty = [[NSMutableArray alloc]initWithArray:arr];
    [_tblView registerNib:[UINib nibWithNibName:@"CatTableViewCell" bundle:nil] forCellReuseIdentifier:@"CatTableViewCell"];
    [self initData];
    
    // Do any additional setup after loading the view from its nib.
}
#pragma mark Get data
-(void)initData{
    arrFoodOrdered = [[NSMutableArray alloc] init];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,SHOW_CART];
    NSDictionary *parameters = @{@"tableId" : _tableId};
    [manager GET:urlStr parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSArray *arrResponseObject = [responseObject objectForKey:@"data"];
        for (NSDictionary *obj in arrResponseObject) {
            Category *foodObj = [[Category alloc]init];
            foodObj.nameCategory = [obj objectForKey:@"cartName"];
            foodObj.priceCategory = [obj objectForKey:@"price"];
            foodObj.IDCategory =[obj objectForKey:@"cartId"];
            foodObj.numberNameCategory = [obj objectForKey:@"numberCart"];
            [arrFoodOrdered addObject:foodObj];
        }
        if (arrFoodOrdered.count ==0) {
            _btnPay.userInteractionEnabled = NO;
            [_btnPay setAlpha:0.3];
        } else {
            _btnPay.userInteractionEnabled = YES;
            [_btnPay setAlpha:1];
        }
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self reloadDataa];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
    }];
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
#pragma mark Reload Data
-(void)reloadDataa{
    [_tblView reloadData];
    int subTotal=0;
    for (Category * obj in arrFoodOrdered) {
        subTotal = subTotal + [obj.priceCategory intValue] * [obj.numberNameCategory intValue];
    }
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    NSString *groupingSeparator = [[NSLocale currentLocale] objectForKey:NSLocaleGroupingSeparator];
    [formatter setGroupingSeparator:groupingSeparator];
    [formatter setGroupingSize:3];
    [formatter setAlwaysShowsDecimalSeparator:NO];
    [formatter setUsesGroupingSeparator:YES];
    NSString *formattedString = [formatter stringFromNumber:[NSNumber numberWithFloat:subTotal]];
    _lblTotal.text = formattedString;
}
#pragma mark Table View
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CatTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    Category *cat = [arrFoodOrdered objectAtIndex:indexPath.row];
    cell.lblNumber.text = cat.numberNameCategory;
    cell.lblName.text = cat.nameCategory;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    NSString *groupingSeparator = [[NSLocale currentLocale] objectForKey:NSLocaleGroupingSeparator];
    [formatter setGroupingSeparator:groupingSeparator];
    [formatter setGroupingSize:3];
    [formatter setAlwaysShowsDecimalSeparator:NO];
    [formatter setUsesGroupingSeparator:YES];
    NSString *formattedString = [formatter stringFromNumber:[NSNumber numberWithFloat:[[NSString stringWithFormat:@"%d",[cat.numberNameCategory intValue] * [cat.priceCategory intValue]] intValue]]];
    cell.lblPrice.text = formattedString;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrFoodOrdered.count;
}
#pragma mark Pay
- (IBAction)onPay:(id)sender {
    UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Payment"
                                                                  message:@"Pay"
                                                           preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* money = [UIAlertAction actionWithTitle:@"Money"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action)
    {
        
        if (arrFoodOrdered.count ==0) {
            [self performSelectorOnMainThread:@selector(paidMoney) withObject:nil waitUntilDone:NO];
            return;
        }
        NSMutableArray *arrFoodId = [[NSMutableArray alloc]init];
        for (Category* objTest in arrFoodOrdered) {
            if (![arrFoodId containsObject:objTest.IDCategory]) {
                [arrFoodId addObject:objTest.IDCategory];
            }
        }
        
        NSString *cateId = [arrFoodId firstObject];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,ADD_HISTORY];
        NSDictionary *parameters = @{@"tableId" : _tableId,
                                     @"cartId":cateId};
        [manager GET:urlStr parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            
            [self performSelectorOnMainThread:@selector(paidMoney) withObject:nil waitUntilDone:NO];
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
        }];
    }];
    
    UIAlertAction* paypal = [UIAlertAction actionWithTitle:@"Paypal"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action)
    {
//        NSString *stringWithouCurrent = [_lblTotal.text
//                                         stringByReplacingOccurrencesOfString:@"$" withString:@""];
        NSString *stringWithouCurrent = [_lblTotal.text substringFromIndex:1];
        NSString *stringPrice = [stringWithouCurrent
                                         stringByReplacingOccurrencesOfString:@"," withString:@""];
        
        PayPalItem *item1 = [PayPalItem itemWithName:[NSString stringWithFormat:@"Payment Table %@",_tableId] withQuantity:1 withPrice:[NSDecimalNumber decimalNumberWithString:stringPrice] withCurrency:@"USD" withSku:@"Pay"];
        NSArray *item = @[item1];
        NSDecimalNumber *subtotal = [NSDecimalNumber decimalNumberWithString:stringPrice];
        //NSDecimalNumber *subtotal = [PayPalItem totalPriceForItems:item];
        NSDecimalNumber *shipping = [[NSDecimalNumber alloc]initWithString:@"0"];
        NSDecimalNumber *tax = [[NSDecimalNumber alloc]initWithString:@"0"];
        PayPalPaymentDetails *paymentdetails = [PayPalPaymentDetails paymentDetailsWithSubtotal:subtotal withShipping:shipping withTax:tax];
        NSDecimalNumber *toal = [[subtotal decimalNumberByAdding:shipping] decimalNumberByAdding:tax];
        PayPalPayment *payment = [[PayPalPayment alloc]init];
        payment.amount = toal;
        payment.currencyCode = @"USD";
        payment.shortDescription = [NSString stringWithFormat:@"Payment Table %@",_tableId];
        payment.items = item;
        payment.paymentDetails = paymentdetails;
        PayPalPaymentViewController *paymentViewController = [[PayPalPaymentViewController alloc]initWithPayment:payment configuration:self.payPalconfig delegate:self];
        [self presentViewController:paymentViewController animated:true completion:nil];
    }];
    UIAlertAction* cancel = [UIAlertAction
                                actionWithTitle:@"Cancel"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    //Handel your yes please button action here
                                    [alert dismissViewControllerAnimated:YES completion:nil];
                                    
                                }];
    
    [alert addAction:money];
    [alert addAction:paypal];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}
#pragma mark Paypal Delegate
- (void)payPalPaymentDidCancel:(nonnull PayPalPaymentViewController *)paymentViewController {
    NSLog(@"Paypal payment cencal");
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)payPalPaymentViewController:(nonnull PayPalPaymentViewController *)paymentViewController didCompletePayment:(nonnull PayPalPayment *)completedPayment {
    NSLog(@"Paypal payment successful");
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Payment" message:@"success" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *buttomAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:buttomAction];
    
    NSMutableArray *arrFoodId = [[NSMutableArray alloc]init];
    for (Category* objTest in arrFoodOrdered) {
        if (![arrFoodId containsObject:objTest.IDCategory]) {
            [arrFoodId addObject:objTest.IDCategory];
        }
    }
    NSString *cateId = [arrFoodId firstObject];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,ADD_HISTORY];
    NSDictionary *parameters = @{@"tableId" : _tableId,
                                 @"cartId":cateId};
    [manager GET:urlStr parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        [self performSelectorOnMainThread:@selector(paidMoney) withObject:nil waitUntilDone:NO];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
    }];
    [self presentViewController:alert animated:TRUE completion:nil];
    [self dismissViewControllerAnimated:true completion:nil];
    
}
#pragma mark update Status
-(void)paidMoney{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,UP_STATUS];
    NSDictionary *parameters = @{@"TableId" : _tableId,
                                 @"status":@"2"};
    [manager GET:urlStr parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        history *h = [[history alloc]init];
        h.date = [dateFormatter stringFromDate:[NSDate date]];
        h.table = [NSString stringWithFormat:@"%@",_tableId];
        h.price = _lblTotal.text;
        [arrHistoty addObject:h];
        [Ulti saveArrayObjectToNSUserDefault:arrHistoty forkey:@"history"];
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
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
     [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
    
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
