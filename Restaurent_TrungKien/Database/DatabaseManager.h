//
//  DatabaseManager.h
//  Restaurent_TrungKien
//
//  Created by Trung Kiên on 5/29/18.
//  Copyright © 2018 Trung Kiên. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "User.h"
@interface DatabaseManager : NSObject {
    sqlite3_stmt  *stmt;
}
+ (DatabaseManager *)defaultDatabaseManager;
-(void) insertUser :(User *)u;
-(NSMutableArray *) getAllUser;
-(void)deleteUserWithID:(NSString *)ID;

@end
