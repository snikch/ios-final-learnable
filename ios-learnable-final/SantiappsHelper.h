//
//  SantiappsHelper.h
//  iGlobe
//
//  Created by Marcio Valenzuela on 2/19/10.
//  Copyright 2010 Personal. All rights reserved.
//

#import <Foundation/Foundation.h>
#define USE_TEST_SERVER 0
#define USE_CACHED_DATA 1
@interface SantiappsHelper : NSObject {
}

+(NSArray *)fetchPoints:(NSString*)usuario;
// Fetches jsonEncoded Array of dictionaries
+(NSArray *)fetchUsers;
// Returns a dictionary with info about the given username.
// This method is synchronous (it will block the calling thread).
// FETCHINFOFOR--UDID
+ (NSArray *)fetchInfoForUDID:(NSString *)udid;

// Returns an array of status updates for the given username.
// This method is synchronous (it will block the calling thread).
// FETCHINFOFOR--TAG
+ (NSArray *)fetchTimelineForUser:(NSString *)user;

//Post to twitter
+ (BOOL)updateStatus:(NSString *)status forUsername:(NSString *)username withPassword:(NSString *)password;

// Returns YES if the status update succeeded, otherwise NO.
// POSTNEWTAGTO---DB
+ (BOOL)updateTags:(NSString *)status forUDID:(NSString *)udid;// withPassword:(NSString *)password;
//+ (BOOL)postNewTag:(Tag*)passingObject;// from gamebumpconnector
@end
