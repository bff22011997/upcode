//
//  Ulti.m
//  Restaurent_TrungKien
//
//  Created by Trung Kiên on 5/25/18.
//  Copyright © 2018 Trung Kiên. All rights reserved.
//

#import "Ulti.h"

@implementation Ulti
+ (void)saveArrayObjectToNSUserDefault:(NSArray *)array forkey:(NSString *)key{
    NSUserDefaults *userDefault =[NSUserDefaults standardUserDefaults];
    NSData *data =[NSKeyedArchiver archivedDataWithRootObject:[NSArray arrayWithArray:array]];
    [userDefault setObject:data forKey:key];
    [userDefault synchronize];
}
+(NSArray*)getArrayObjectFromNSUserDefault:(NSString *)key{
    NSUserDefaults *userDefault =[NSUserDefaults standardUserDefaults];
    NSData *data =[userDefault objectForKey:key];
    return (NSArray*)[NSKeyedUnarchiver unarchiveObjectWithData:data];
}
+(NSString*)convertDictionaryToString:(NSDictionary*)dict{
    NSError* error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict
                                                       options:0
                                                         error:&error];
    NSString *jsonString=@"";
    if (!jsonData) {
        NSLog(@"Error %@", error);
    } else {
        jsonString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
        //NSLog(@&quot;JSON OUTPUT: %@&quot;,JSONString);
    }
    return jsonString;
}
+ (void)removeObjectForKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
