//
//  Category.m
//  Restaurent_TrungKien
//
//  Created by Trung Kiên on 5/29/18.
//  Copyright © 2018 Trung Kiên. All rights reserved.
//

#import "Category.h"

@implementation Category
-(void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.IDCategory forKey:@"IDCategory"];
    [encoder encodeObject:self.nameCategory  forKey:@"nameCategory"];
    [encoder encodeObject:self.codeCategory forKey:@"codeCategory"];
    [encoder encodeObject:self.priceCategory forKey:@"priceCategory"];
    [encoder encodeObject:self.numberNameCategory  forKey:@"numberNameCategory"];
    [encoder encodeObject:self.categoryId forKey:@"categoryId"];
}

-(id)initWithCoder:(NSCoder *)decoder
{
    self.IDCategory = [decoder decodeObjectForKey:@"IDCategory"];
    self.nameCategory = [decoder decodeObjectForKey:@"nameCategory"];
    self.codeCategory = [decoder decodeObjectForKey:@"codeCategory"];
    self.priceCategory = [decoder decodeObjectForKey:@"priceCategory"];
    self.numberNameCategory = [decoder decodeObjectForKey:@"numberNameCategory"];
    self.categoryId = [decoder decodeObjectForKey:@"categoryId"];
    return self;
}
@end
