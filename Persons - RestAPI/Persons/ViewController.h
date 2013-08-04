//
//  ViewController.h
//  Persons
//
//  Created by Lucent Mobile Dev 1 on 6/5/13.
//  Copyright (c) 2013 Proxomo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
{
    NSString* accessToken;
    NSString* lastAppDataID;
}
@property (strong, nonatomic) IBOutlet UITextView *textView;

- (IBAction)personGet:(id)sender;
- (IBAction)personUpdate:(id)sender;
- (IBAction)personAppDataAdd:(id)sender;
- (IBAction)personAppDataDelete:(id)sender;
- (IBAction)personAppDataGet:(id)sender;
- (IBAction)personAppDataGetAll:(id)sender;
- (IBAction)personAppDataUpdate:(id)sender;
@end
