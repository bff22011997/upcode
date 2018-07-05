//
//  Category.h
//  Restaurent_TrungKien
//
//  Created by Trung Kiên on 5/29/18.
//  Copyright © 2018 Trung Kiên. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Category : NSObject
@property (strong,nonatomic) NSString *IDCategory;
@property (strong,nonatomic) NSString *nameCategory;
@property (strong,nonatomic) NSString *codeCategory;
@property (strong,nonatomic) NSString *priceCategory;
@property (strong,nonatomic) NSString *numberNameCategory;
@property (strong,nonatomic) NSString *categoryId;
@property (assign,nonatomic) BOOL isSelected;
@end
