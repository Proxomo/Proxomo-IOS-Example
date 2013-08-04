//
//  AppDelegate.h
//  Persons
//
//  Created by Lucent Mobile Dev 1 on 6/5/13.
//  Copyright (c) 2013 Proxomo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) NSString* eventID;

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *accessToken;
@property (strong, nonatomic) NSString *expiresInMilliSeconds;

@end
