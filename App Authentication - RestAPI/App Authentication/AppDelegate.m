//
//  AppDelegate.m
//  App Authentication
//
//  Created by Lucent Mobile Dev 1 on 5/13/13.
//  Copyright (c) 2013 Proxomo. All rights reserved.
//

#import "AppDelegate.h"

#warning Replace below with your Application ID and API Key
#define APPLICATION_ID @"INSERT_APPLICATION_ID_HERE"
#define PROXOMO_API_KEY @"INSERT_PROXOMO_API_KEY_HERE"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [self getAuthenticationToken];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)getAuthenticationToken
{
    // Request URL: Uses Endpoint with Application ID and Proxomo Api Key
    NSString* requestURL = [NSString stringWithFormat:@"https://service.proxomo.com/v09/json/security/accesstoken/get?applicationid=%@&proxomoAPIKey=%@", APPLICATION_ID, PROXOMO_API_KEY];
    
    // Create a request: Uses requestURL
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    
    // Send Request
    NSError *error = nil;
    NSData* responseData = [NSURLConnection sendSynchronousRequest: request returningResponse:nil error: &error];
    if (error)
    {
        // if error then handle here
        NSLog(@"Rest Error: %@",error);
    }
    else if (responseData)
    {
        // else if responseData then...
        NSDictionary *responseDict =[NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
        NSLog(@"Response Dictionary: %@",responseDict);
        
        // Data contains Access Token and Time till expiration in milliseconds
        _accessToken = [responseDict objectForKey:@"AccessToken"];
        _expiresInMilliSeconds = [responseDict objectForKey:@"Expires"];
    }
}

@end
