//
//  ViewController.m
//  Custom Data
//
//  Created by Lucent Mobile Dev 1 on 5/14/13.
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
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    accessToken = appDelegate.accessToken;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- UI Textfield Delegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if ([textField tag] == 1 && textField.text.length != 0) {
        [self searchApplicationData:textField.text];
    }
    return NO;
}

#pragma mark- IBActions

- (IBAction)createNew:(id)sender {
    [self addApplicationData];
}

- (IBAction)updateData:(id)sender {
    if (lastID.length == 0) {
        [[[UIAlertView alloc] initWithTitle:@"Update Last Error" message:@"There is no last object created. Please create on and try again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    }
    else
    {
        [self updateApplicationData];
    }
}

- (IBAction)deleteLast:(id)sender {
    if (lastID.length == 0) {
        [[[UIAlertView alloc] initWithTitle:@"Delete Last Error" message:@"There is no last object created. Please create on and try again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    }
    else
    {
        [self deleteApplicationData:lastID];
    }
}

- (IBAction)getLastCreated:(id)sender {
    if (lastID.length == 0) {
        [[[UIAlertView alloc] initWithTitle:@"Get Last Error" message:@"There is no last object created. Please create on and try again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    }
    else
    {
        [self getApplicationData:lastID];
    }
}

#pragma mark- Methods

-(void)addApplicationData
{
    if (_keyTextField.text.length == 0 || _valueTextField.text.length == 0 || _objectTypeTextField.text.length == 0) {
        [[[UIAlertView alloc] initWithTitle:@"Add Error" message:@"Please make sure all fields are fillled in" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    }
    // Request URL: Uses Endpoint with parameters to send
    NSString* requestUrl = @"https://service.proxomo.com/v09/json/customdata";
    NSMutableDictionary *postData = [[NSMutableDictionary alloc] init];
    
    [postData setValue:_keyTextField.text forKey:@"TableName"];
    [postData setValue:@"" forKey:@"ID"];
    [postData setValue:_objectTypeTextField.text forKey:_valueTextField.text];
    [postData setValue:@"test" forKey:@"partitionkey"];
    
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
        lastID = responseID;
        [_textView setText:[NSString stringWithFormat:@"Created ID: %@",responseID]];
    }
}

-(void)getApplicationData: (NSString*) dataID
{
    // Request URL: Uses Endpoint with Data ID to get
    NSString* requestUrl = [NSString stringWithFormat:@"https://service.proxomo.com/v09/json/customdata/table/%@/%@?partitionkey=test",_keyTextField.text,dataID];
    
    // Create a GET request
    NSMutableURLRequest *requestB = [[NSMutableURLRequest alloc] init];
    [requestB setHTTPMethod:@"GET"];
    [requestB setURL:[NSURL URLWithString:requestUrl]];
    [requestB setValue:accessToken forHTTPHeaderField:@"Authorization"];
    
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
        NSDictionary *responseDictionary =[NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
        // Get dictionary of object requested
        NSLog(@"Response Dictionary: %@",responseDictionary);
        [_textView setText:[NSString stringWithFormat:@"Response Dictionary: %@",responseDictionary]];
    }
}

-(void)updateApplicationData
{
    if (_keyTextField.text.length == 0 || _valueTextField.text.length == 0 || _objectTypeTextField.text.length == 0) {
        [[[UIAlertView alloc] initWithTitle:@"Update Error" message:@"Please make sure all fields are fillled in" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    }
    // Request URL: Uses Endpoint with parameters to send
    NSString* requestUrl = @"https://service.proxomo.com/v09/json/customdata";
    NSMutableDictionary *postData = [[NSMutableDictionary alloc] init];
    
    [postData setValue:_keyTextField.text forKey:@"TableName"];
    [postData setValue:lastID forKey:@"ID"];
    [postData setValue:_objectTypeTextField.text forKey:_valueTextField.text];
    [postData setValue:@"test" forKey:@"partitionkey"];
    
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
        [_textView setText:[NSString stringWithFormat:@"Response: %@",response]];
    }
}

-(void)deleteApplicationData: (NSString*) dataID
{
    // Request URL: Uses Endpoint with Data ID to delete
    NSString* requestUrl = [NSString stringWithFormat:@"https://service.proxomo.com/v09/json/customdata/table/%@/%@?partitionkey=test",_keyTextField.text,dataID];
    
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
        [_textView setText:[NSString stringWithFormat:@"Response: %@",response]];
    }
}

-(void)searchApplicationData: (NSString*) objectType
{
    // Request URL: Uses Endpoint with Object Type search criteria
    NSString* requestUrl = [NSString stringWithFormat:@"https://service.proxomo.com/v09/json/customdata/search/table/%@?partitionkey=test&q=%@ eq '%@'",_keyTextField.text,_valueTextField.text,objectType];
    requestUrl = [requestUrl stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    // Create a GET request
    NSMutableURLRequest *requestB = [[NSMutableURLRequest alloc] init];
    [requestB setHTTPMethod:@"GET"];
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
        NSDictionary *responseDictionary =[NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
        // Get a Response Dictionary of all matched items
        NSLog(@"Response Dictionary: %@",responseDictionary);
        [_textView setText:[NSString stringWithFormat:@"Response Dictionary: %@",responseDictionary]];
    }
}

@end
