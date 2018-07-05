//
//  InformationViewController.h
//  Restaurent_TrungKien
//
//  Created by Trung Kiên on 5/29/18.
//  Copyright © 2018 Trung Kiên. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCPercentageDoughnutView.h"

@interface InformationViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblBirthday;
@property (weak, nonatomic) IBOutlet UIImageView *imageAvatar;
@property (weak, nonatomic) IBOutlet UIImageView *imageCorver;
@property (strong,nonatomic) NSString *namePerson;
@property (strong,nonatomic) NSString *birthdayPerson;
@property (strong,nonatomic) NSString *imageAvatarPerson;
@property (strong,nonatomic) NSString *imgaeCoverPerson;
@property (weak, nonatomic) IBOutlet MCPercentageDoughnutView *viewMC;

@end
