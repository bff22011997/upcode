//
//  Food.m
//  Restaurent_TrungKien
//
//  Created by Trung Kiên on 5/25/18.
//  Copyright © 2018 Trung Kiên. All rights reserved.
//

#import "Food.h"

@implementation Food
-(void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.foodID forKey:@"FoodId"];
    [encoder encodeObject:self.foodImage  forKey:@"FoodImage"];
    [encoder encodeObject:self.foodName forKey:@"FoodName"];
}

-(id)initWithCoder:(NSCoder *)decoder
{
    self.foodID = [decoder decodeObjectForKey:@"FoodId"];
    self.foodImage = [decoder decodeObjectForKey:@"FoodImage"];
    self.foodName = [decoder decodeObjectForKey:@"FoodName"];
    return self;
}
@end
