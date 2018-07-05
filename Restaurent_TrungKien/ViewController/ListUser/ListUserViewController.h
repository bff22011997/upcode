//
//  ListUserViewController.h
//  Restaurent_TrungKien
//
//  Created by Trung Kiên on 6/7/18.
//  Copyright © 2018 Trung Kiên. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListUserViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tblView;

@end
