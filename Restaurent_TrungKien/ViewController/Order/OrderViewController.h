//
//  OrderViewController.h
//  Restaurent_TrungKien
//
//  Created by Trung Kiên on 5/29/18.
//  Copyright © 2018 Trung Kiên. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tblView;
@property (weak, nonatomic) IBOutlet UILabel *lblSumTotal;
@property (strong, nonatomic) NSString *tableNumber;
@property (strong,nonatomic) NSMutableArray *arrFoodImage;
@property (strong,nonatomic) NSString *indexImage;

@end
