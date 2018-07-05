//
//  Ulti.h
//  Restaurent_TrungKien
//
//  Created by Trung Kiên on 5/25/18.
//  Copyright © 2018 Trung Kiên. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Ulti : NSObject
+ (void)saveArrayObjectToNSUserDefault:(NSArray *)array forkey:(NSString *)key;
+(NSArray*)getArrayObjectFromNSUserDefault:(NSString *)key;
+(NSString*)convertDictionaryToString:(NSDictionary*)dict;
+ (void)removeObjectForKey:(NSString *)key;
@end
