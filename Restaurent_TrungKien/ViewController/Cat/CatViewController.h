//
//  CatViewController.h
//  Restaurent_TrungKien
//
//  Created by Trung Kiên on 5/29/18.
//  Copyright © 2018 Trung Kiên. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayPalMobile.h"
#import "PayPalConfiguration.h"
#import "PayPalPaymentViewController.h"


@interface CatViewController : UIViewController  <UITableViewDelegate,UITableViewDataSource,PayPalPaymentDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lblTotal;
@property (weak, nonatomic) IBOutlet UITableView *tblView;
@property (strong,nonatomic) NSString *tableId;
@property (strong,nonatomic) PayPalConfiguration *payPalconfig;
@property (weak, nonatomic) IBOutlet UIButton *btnPay;



@end
