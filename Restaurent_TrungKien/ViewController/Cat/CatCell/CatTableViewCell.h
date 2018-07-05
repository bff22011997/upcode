//
//  CatTableViewCell.h
//  Restaurent_TrungKien
//
//  Created by Trung Kiên on 5/31/18.
//  Copyright © 2018 Trung Kiên. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CatTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblNumber;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;

@end
