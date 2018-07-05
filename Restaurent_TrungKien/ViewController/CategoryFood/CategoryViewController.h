//
//  CategoryViewController.h
//  Restaurent_TrungKien
//
//  Created by Trung Kiên on 5/29/18.
//  Copyright © 2018 Trung Kiên. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tblView;

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong,nonatomic) NSString* tableNumber;
@property (nonatomic, strong) NSMutableArray *searchResult;
@property (strong, nonatomic) NSString *idCategory;
@property (strong,nonatomic) NSMutableArray *arrFoodImage;
@property (strong,nonatomic) NSString *indexImage;
@end
