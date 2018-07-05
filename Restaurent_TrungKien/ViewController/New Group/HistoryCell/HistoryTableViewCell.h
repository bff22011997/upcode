//
//  HistoryTableViewCell.h
//  Restaurent_TrungKien
//
//  Created by Trung Kiên on 6/7/18.
//  Copyright © 2018 Trung Kiên. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *lblTable;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;

@end
