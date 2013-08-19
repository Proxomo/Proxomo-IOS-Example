//
//  ViewController.m
//  Task Manager
//
//  Created by Richard Cribbet on 8/14/13.
//  Copyright (c) 2013 Proxomo. All rights reserved.
//

#import "ViewController.h"

#import "AppDelegate.h"

#import "TaskCell.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    accessToken = appDelegate.accessToken;
    
    tasks = [[NSMutableArray alloc] init];
    
    // Get any results from the database
    [self searchCustomData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (textField.text.length != 0) {
        if ([textField tag] == -1) {
            NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
            [dict setValue:textField.text forKey:@"body"];
            [dict setValue:@"false" forKey:@"completed"];
            
            // add custom data to database
            [self addCustomData:dict];
            
            [tasks addObject:dict];
            
            [_TableView reloadData];
            
            textField.text = @"";
        }
        else
        {
            NSMutableDictionary* dict = [tasks objectAtIndex:[textField tag]];
            [dict setValue:textField.text forKey:@"body"];
            
            // update custom data when task is changed
            [self updateCustomData:dict];
        }
        
    }
    return NO;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return tasks.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= tasks.count) {
        NSString *CellIdentifier = @"NewTaskCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        return cell;
    }
    NSString *CellIdentifier = @"Cell";
    TaskCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    NSMutableDictionary* dict = [tasks objectAtIndex:indexPath.row];
    [cell.TaskTextField setText:[dict objectForKey:@"body"]];
    if ([[dict objectForKey:@"completed"] isEqualToString:@"false"]) {
        [cell.CompletedSwitch setOn:NO];
    }
    else
    {
        [cell.CompletedSwitch setOn:YES];
    }
    [cell.CompletedSwitch setTag:indexPath.row];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return YES if you want the specified item to be editable.
    if (indexPath.row >= tasks.count) {
        return NO;
    }
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        NSMutableDictionary* dict = [tasks objectAtIndex:indexPath.row];
        [self deleteCustomData:[dict objectForKey:@"ID"]];
        [tasks removeObjectAtIndex:indexPath.row];
        [_TableView reloadData];
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (IBAction)SwitchPressed:(id)sender {
    // When a switch is pressed
    NSMutableDictionary* dict = [tasks objectAtIndex:[sender tag]];
    
    // update the competed value
    if ([sender isOn]) {
        [dict setValue:@"true" forKey:@"completed"];
    }
    else
    {
        [dict setValue:@"false" forKey:@"completed"];
    }
    // update the database
    [self updateCustomData:dict];
}

#pragma mark- Methods

-(void)addCustomData: (NSMutableDictionary*) dict
{
    // Request URL: Uses Endpoint with parameters to send
    NSString* requestUrl = @"https://service.proxomo.com/v09/json/customdata";
    NSMutableDictionary *postData = [[NSMutableDictionary alloc] init];
    
    [postData setValue:@"tasks" forKey:@"TableName"];
    [postData setValue:@"" forKey:@"ID"];
    [postData setValue:[dict objectForKey:@"body"] forKey:@"body"];
    [postData setValue:@"0" forKey:@"completed"];
    [postData setValue:@"tasks" forKey:@"partitionkey"];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:postData options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *params = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    // Create a POST request
    NSString *postLength = [NSString stringWithFormat:@"%d", [[params dataUsingEncoding:NSUTF8StringEncoding] length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"POST"];
    [request setURL:[NSURL URLWithString:requestUrl]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    [request setValue:accessToken forHTTPHeaderField:@"Authorization"];
    
    NSData* responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    
    if (error)
    {
        // if error then handle here
        NSLog(@"Rest Error: %@",error);
    }
    else if (responseData)
    {
        // else if responseData then...
        NSString* responseID = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        responseID = [responseID stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        // Get ID of object created
        NSLog(@"Response ID: %@",responseID);
        // set the id from the response to the object
        [dict setValue:responseID forKey:@"ID"];
    }
}

-(void)updateCustomData: (NSMutableDictionary*) dict
{
    // Request URL: Uses Endpoint with parameters to send
    NSString* requestUrl = @"https://service.proxomo.com/v09/json/customdata";
    NSMutableDictionary *postData = [[NSMutableDictionary alloc] init];
    
    [postData setValue:@"tasks" forKey:@"TableName"];
    [postData setValue:[dict objectForKey:@"ID"] forKey:@"ID"];
    [postData setValue:[dict objectForKey:@"body"] forKey:@"body"];
    [postData setValue:[dict objectForKey:@"completed"] forKey:@"completed"];
    [postData setValue:@"tasks" forKey:@"partitionkey"];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:postData options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *params = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    // Create a PUT request
    NSString *postLength = [NSString stringWithFormat:@"%d", [[params dataUsingEncoding:NSUTF8StringEncoding] length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"PUT"];
    [request setURL:[NSURL URLWithString:requestUrl]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    [request setValue:accessToken forHTTPHeaderField:@"Authorization"];
    
    NSData* responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    
    if (error)
    {
        // if error then handle here
        NSLog(@"Rest Error: %@",error);
    }
    else if (responseData)
    {
        // else if responseData then...
        NSString* response = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        response = [response stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        // Get Response Code
        NSLog(@"Response: %@",response);
    }
}

-(void)deleteCustomData: (NSString*) dataID
{
    // Request URL: Uses Endpoint with Data ID to delete
    NSString* requestUrl = [NSString stringWithFormat:@"https://service.proxomo.com/v09/json/customdata/table/tasks/%@?partitionkey=tasks",dataID];
    
    // Create a DELETE request
    NSMutableURLRequest *requestB = [[NSMutableURLRequest alloc] init];
    [requestB setHTTPMethod:@"DELETE"];
    [requestB setURL:[NSURL URLWithString:requestUrl]];
    [requestB setValue:accessToken forHTTPHeaderField:@"Authorization"];
    
    // Send Request
    NSError* error;
    NSData* responseData = [NSURLConnection sendSynchronousRequest:requestB returningResponse:nil error:&error];
    
    if (error)
    {
        // if error then handle here
        NSLog(@"Rest Error: %@",error);
    }
    else if (responseData)
    {
        // else if responseData then...
        NSString* response = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        response = [response stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        // Get Response Code
        NSLog(@"Response: %@",response);
    }
}

-(void)searchCustomData
{
    // Request URL: Uses Endpoint with Object Type search criteria
    NSString* requestUrl = [NSString stringWithFormat:@"https://service.proxomo.com/v09/json/customdata/search/table/tasks?partitionkey=tasks"];
    requestUrl = [requestUrl stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    // Create a GET request
    NSMutableURLRequest *requestB = [[NSMutableURLRequest alloc] init];
    [requestB setHTTPMethod:@"GET"];
    [requestB setURL:[NSURL URLWithString:requestUrl]];
    [requestB setValue:accessToken forHTTPHeaderField:@"Authorization"];
    
    // Send Request
    NSError* error;
    NSHTTPURLResponse* resp;
    NSData* responseData = [NSURLConnection sendSynchronousRequest:requestB returningResponse:&resp error:&error];
    
    if (error)
    {
        // if error then handle here
        NSLog(@"Rest Error: %@",error);
    }
    else if (responseData)
    {
        // else if responseData then populate tasks
        NSArray* array =[NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
        tasks = [[NSMutableArray alloc] initWithArray:array];
        // Get a Response Dictionary of all matched items
        NSLog(@"Response Dictionary: %@",tasks);
    }
}

@end
