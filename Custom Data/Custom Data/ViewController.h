//
//  ViewController.h
//  Custom Data
//
//  Created by Lucent Mobile Dev 1 on 5/14/13.
//  Copyright (c) 2013 Proxomo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
{
    NSString* accessToken;
    NSString* lastID;
}

@property (strong, nonatomic) IBOutlet UITextField *keyTextField;
@property (strong, nonatomic) IBOutlet UITextField *valueTextField;
@property (strong, nonatomic) IBOutlet UITextField *objectTypeTextField;
@property (strong, nonatomic) IBOutlet UITextField *searchTextField;
@property (strong, nonatomic) IBOutlet UITextView *textView;

- (IBAction)createNew:(id)sender;
- (IBAction)updateData:(id)sender;
- (IBAction)deleteLast:(id)sender;
- (IBAction)getLastCreated:(id)sender;

@end
