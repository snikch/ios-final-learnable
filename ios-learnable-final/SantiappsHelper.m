//
//  SantiappsHelper.m
//  iGlobe
//
//  Created by Marcio Valenzuela on 2/19/10.
//  Copyright 2010 Personal. All rights reserved.
//

#import "SantiappsHelper.h"
#import "CJSONDeserializer.h"
#include "NSDictionary_JSONExtensions.h" //TOUCHJSON

@implementation SantiappsHelper
NSString *const TwitterHostname = @"twitter.com";
NSString *const TwitterCachedDataHostname = @"www.stanford.edu/class/cs193p/presence-test";

+ (NSString *)twitterHostname
{
#if USE_TEST_SERVER
	return @"www.stanford.edu/class/cs193p/presence-test";
#else
	return @"twitter.com";
#endif
}
+ (BOOL)canUseCachedDataForUsername:(NSString *)username
{
    static NSArray *cachedUsernames = nil;
    if (!cachedUsernames) {
        cachedUsernames = [[NSArray alloc] initWithObjects:@"stevewozniak", @"THE_REAL_SHAQ", @"williamshatner", nil];
    }
    return [cachedUsernames containsObject:username];
}

+ (NSString *)twitterHostnameForUsername:(NSString *)username
{
    if ([self canUseCachedDataForUsername:username]) {
        return TwitterCachedDataHostname;
    } else {
        return TwitterHostname;
    }
}

+ (BOOL)updateStatus:(NSString *)status forUsername:(NSString *)username withPassword:(NSString *)password
{
    if (!username || !password) {
        return NO;
    }
	
    NSString *post = [NSString stringWithFormat:@"status=%@", [status stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:%@@%@/statuses/update.json", username, password, TwitterHostname]];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLResponse *response;
    NSError *error;
	// We should probably be parsing the data returned by this call, for now just check the error.
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    return (error == nil);
}
//Set to cache my udid
+ (BOOL)canUseCachedDataForUDID:(NSString *)udid{
    static NSArray *cachedUDIDs = nil;
    if (!cachedUDIDs) {
        cachedUDIDs = [[NSArray alloc] initWithObjects:@"269d4008ba6575b9ec51a7f3237e757c2bcd6bf6", nil];
    }
    return [cachedUDIDs containsObject:udid];
}

// Maybe i dont need this one...
+ (NSString *)twitterHostnameForUDID:(NSString *)udid{
    if ([self canUseCachedDataForUDID:udid]) {
        return TwitterCachedDataHostname;
    } else {
        return TwitterHostname;
    }

}

//THIS IS THE METHOD THAT DOES THE GETTING
+ (id)fetchJSONValueForURL:(NSURL *)url{
    NSData *jsonData = [[NSData alloc]initWithContentsOfURL:url];
    id jsonValue = [[[CJSONDeserializer deserializer] deserialize:jsonData error:nil] retain];

    //NSLog(@"This is the string presented:%@",jsonString);
	[jsonData release];
	return jsonValue;
}

// THIS METHOD FETCHES USER ARRAY
+(NSArray *)fetchUsers{
	NSString *urlString = [NSString stringWithFormat:@"http://0.0.0.0:9000"];
    NSURL *url = [NSURL URLWithString:urlString];
    //NSString *jsonString = [[NSString alloc] initWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
	
	//NSDictionary *theDictionary = [NSDictionary dictionaryWithJSONString:jsonString error:&theError];
	//return theDictionary;
    //NSString *urlString = [NSString stringWithFormat:@"http://%@/users/show
	//					   /%@.json", [self twitterHostname], username];
    //NSURL *url = [NSURL URLWithString:urlString];
    return [self fetchJSONValueForURL:url];
}

+(NSArray *)fetchPoints:(NSString*)usuario{
    //not using it because I made the form out to be POST$ ...
	NSString *urlString = [NSString stringWithFormat:@"http://www.santiapps.com/iGlobe/readpoints.php?userNa=%@", usuario];
    NSURL *url = [NSURL URLWithString:urlString];
    return [self fetchJSONValueForURL:url];
}

// i believe this is unsused
+ (NSArray*)fetchInfoForUDID:(NSString *)udid{
    NSString *urlString = [NSString stringWithFormat:@"http://www.santiapps.com/iGlobe/getusers.php"];
	NSLog(@"This is the urlString from (fetchInfoForUDID) SantiappsHelper:%@",urlString);
    NSURL *url = [NSURL URLWithString:urlString];
	NSLog(@"This is the url created 4m string:%@",url);
    return [self fetchJSONValueForURL:url];
}

//GETS TAGS BASED ON USERNAME
+ (NSArray *)fetchTimelineForUser:(NSString *)user{
	/*
	 //THIS WORKS, BUT ITS GET!
	NSLog(@"THIS IS THE value passes %@",udid);
    NSString *urlString = [NSString stringWithFormat:@"http://www.santiapps.com/iGlobe/readtags3.php?userudid=%@", udid];
	NSLog(@"This is the urlString from (fetchTimeline) SantiappsHelper:%@",urlString);
	NSURL *url = [NSURL URLWithString:urlString];
    return [self fetchJSONValueForURL:url];
	*/
	
	NSString *post = [NSString stringWithFormat:@"userudid=%@", [user stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSLog(@"%@",post);
	NSData *postData = [NSData dataWithBytes:[post UTF8String] length:[post length]];
	//[udid dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
	NSLog(@"%@",postData);
    //NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.santiapps.com/iGlobe/readtags2.php"]];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    //[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    NSURLResponse *response;
    NSError *error;
	NSData *urlData = [NSURLConnection sendSynchronousRequest:request
									returningResponse:&response
												error:&error];
	
	NSString *content = [NSString stringWithUTF8String:[urlData bytes]];
	NSLog(@"responseData: %@", content);
	id jsonValue = [[content JSONValue] retain];
	return jsonValue;
	
}

//Tw/Facebook integration
//1. Called from tags creation methods below
//2. Only makes sense to post to twitter/fb after tag is posted
//3. Authenticate user data - i hope this is just an api call
//4. Send info as 140chr if tw/200 if fb || plus geotag & promo :)

// Called from MKVC-IBAction reverseGeocoder, Lonely Tag=1
+ (BOOL)updateTags:(NSString *)status forUDID:(NSString *)udid{
    //if (!username || !password) {
    //    return NO;
    //}
	// how does this get the newTag info??????????????????????????????????????????????
    //NSString *post = [NSString stringWithFormat:@"geotag=%@", [status stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	//NSLog(@"status:%@",status);
	//NSLog(@"%@",post);
    NSData *postData = [status dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.santiapps.com/iGlobe/writephp.php"]];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLResponse *response;
    NSError *error;
	// We should probably be parsing the data returned by this call, for now just check the error.
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSLog(@"success!");
	
    return (error == nil);
}

// Called from MKViewController, creates shared tags points=2
/**
+ (BOOL)postNewTag:(Tag*)passingObject{
    //4.  Convert newTag into a string
	//Tag *tagReceived = [[Tag alloc] init];
	//tagReceived = passingObject;
	NSLog(@"passingObject:%@,%@,%@,%@,%@",passingObject.sender, passingObject.receiver, passingObject.rglatitude, passingObject.rglongitude, passingObject.rgcountry);
	//NSLog(@"tagReceived:%@,%@,%@,%@",tagReceived.originUdid, tagReceived.destintyUdid, tagReceived.rglatitude, tagReceived.rglongitude);
	//NSLog(@"STOP HERE");
	//  REBUILD status string from passingObject
	NSString *s1 = [[NSString alloc] initWithFormat:@"sender=%@&latitude=%@&longitude=%@&country=%@&receiver=%@&points=2",passingObject.sender,passingObject.rglatitude,passingObject.rglongitude,passingObject.rgcountry,passingObject.receiver];	
	//5.  Post tag to cloud
    NSData *postData = [s1 dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.santiapps.com/iGlobe/writephp.php"]];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLResponse *response;
    NSError *error;
	// We should probably be parsing the data returned by this call, for now just check the error.
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSLog(@"success!");
	[s1 release];
    return (error == nil);
}
**/

@end
