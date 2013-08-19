//
//  ViewController.h
//  Task Manager
//
//  Created by Richard Cribbet on 8/14/13.
//  Copyright (c) 2013 Proxomo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
{
    NSMutableArray* tasks;
    NSString* accessToken;
}

@property (weak, nonatomic) IBOutlet UITableView *TableView;
- (IBAction)SwitchPressed:(id)sender;
@end
