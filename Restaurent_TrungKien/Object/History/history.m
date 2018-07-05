//
//  history.m
//  Restaurent_TrungKien
//
//  Created by Trung Kiên on 6/7/18.
//  Copyright © 2018 Trung Kiên. All rights reserved.
//

#import "history.h"

@implementation history
-(void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.date forKey:@"date"];
    [encoder encodeObject:self.table  forKey:@"table"];
    [encoder encodeObject:self.price forKey:@"price"];
    
}

-(id)initWithCoder:(NSCoder *)decoder
{
    self.date = [decoder decodeObjectForKey:@"date"];
    self.table = [decoder decodeObjectForKey:@"table"];
    self.price = [decoder decodeObjectForKey:@"price"];
    return self;
}
@end
