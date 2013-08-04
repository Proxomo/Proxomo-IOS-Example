//
//  AuthViewController.h
//  Persons
//
//  Created by Richard Cribbet on 7/31/13.
//  Copyright (c) 2013 Proxomo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AuthViewController : UIViewController
{
    NSString* accessToken;
    NSString* lastAppDataID;
}
@property (strong, nonatomic) IBOutlet UITextView *textView;

- (IBAction)create:(id)sender;
- (IBAction)deletePerson:(id)sender;
- (IBAction)appGet:(id)sender;
- (IBAction)updateRole:(id)sender;
- (IBAction)auth:(id)sender;
- (IBAction)passwordChange:(id)sender;
- (IBAction)passwordChangeRequest:(id)sender;
@end
