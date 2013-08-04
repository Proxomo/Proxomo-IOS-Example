//
//  ViewController.m
//  App Authentication
//
//  Created by Lucent Mobile Dev 1 on 5/13/13.
//  Copyright (c) 2013 Proxomo. All rights reserved.
//

#import "ViewController.h"

#import "AppDelegate.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Displays information
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSString* accessToken = appDelegate.accessToken;
    NSString* expiresInMilliSeconds = appDelegate.expiresInMilliSeconds;
    
    NSString* outputString = [NSString stringWithFormat:@"Access Token: %@\rExpires In Milliseconds: %@", accessToken, expiresInMilliSeconds];
    
    [_textView setText:outputString];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
