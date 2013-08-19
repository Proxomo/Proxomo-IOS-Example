//
//  TaskCell.h
//  Task Manager
//
//  Created by Richard Cribbet on 8/14/13.
//  Copyright (c) 2013 Proxomo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaskCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UISwitch *CompletedSwitch;
@property (weak, nonatomic) IBOutlet UITextField *TaskTextField;

@end
