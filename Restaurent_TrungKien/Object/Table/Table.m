//
//  Table.m
//  Restaurent_TrungKien
//
//  Created by Trung Kiên on 5/25/18.
//  Copyright © 2018 Trung Kiên. All rights reserved.
//

#import "Table.h"

@implementation Table
-(void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.tableID forKey:@"tableID"];
    [encoder encodeObject:self.tableStatus  forKey:@"tableStatus"];
    [encoder encodeObject:self.tableOperatorId forKey:@"tableOperatorId"];
}

-(id)initWithCoder:(NSCoder *)decoder
{
    self.tableID = [decoder decodeObjectForKey:@"tableID"];
    self.tableStatus = [decoder decodeObjectForKey:@"tableStatus"];
    self.tableOperatorId = [decoder decodeObjectForKey:@"tableOperatorId"];
    return self;
}
@end
