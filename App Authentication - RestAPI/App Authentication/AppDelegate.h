//
//  AppDelegate.h
//  App Authentication
//
//  Created by Lucent Mobile Dev 1 on 5/13/13.
//  Copyright (c) 2013 Proxomo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *accessToken;
@property (strong, nonatomic) NSString *expiresInMilliSeconds;

@end
