//
//  OrderTableViewCell.m
//  Restaurent_TrungKien
//
//  Created by Trung Kiên on 5/29/18.
//  Copyright © 2018 Trung Kiên. All rights reserved.
//

#import "OrderTableViewCell.h"

@implementation OrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
}
- (IBAction)onPlus:(id)sender {
    int i = [_lblNumber.text intValue];
    if (i<20) {
        i++;
    } else i=20;
    _lblNumber.text = [NSString stringWithFormat:@"%d",i];
}
- (IBAction)onMinus:(id)sender {
    int i = [_lblNumber.text intValue];
    if (i>0) {
        i--;
    }else {
        i = 0;
    }
    
    _lblNumber.text = [NSString stringWithFormat:@"%d",i];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
