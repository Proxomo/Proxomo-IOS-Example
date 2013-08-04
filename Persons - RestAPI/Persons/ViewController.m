//
//  ViewController.m
//  Persons
//
//  Created by Lucent Mobile Dev 1 on 6/5/13.
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

- (IBAction)personGet:(id)sender {
    [self PersonGet];
}

- (IBAction)personUpdate:(id)sender {
    [self PersonUpdate];
}

- (IBAction)personAppDataAdd:(id)sender {
    [self addApplicationData];
}

- (IBAction)personAppDataDelete:(id)sender {
    [self deleteApplicationData];
}

- (IBAction)personAppDataGet:(id)sender {
    [self getApplicationData];
}

- (IBAction)personAppDataGetAll:(id)sender {
    [self getAllApplicationData];
}

- (IBAction)personAppDataUpdate:(id)sender {
    [self updateApplicationData];
}

-(void)PersonGet
{
    // Request URL: Uses Endpoint with Data ID to get
    NSString* requestUrl = [NSString stringWithFormat:@"https://service.proxomo.com/v09/json/person/%@",@"JwXMhxjNGGbX6AZC"];
    
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

-(void)PersonUpdate
{
    // Request URL: Uses Endpoint with parameters to send
    NSString* requestUrl = @"https://service.proxomo.com/v09/json/person";
    NSMutableDictionary *postData = [[NSMutableDictionary alloc] init];
    static int i= 0;
    i++;
    
    // Add Fields must be included to update even ones not used
    [postData setValue:@"JwXMhxjNGGbX6AZC" forKey:@"ID"];
    [postData setValue:@"" forKey:@"EmailAddress"];
    [postData setValue:@"0" forKey:@"EmailAlerts"];
    [postData setValue:@"lfjd2CDkKcqUFHKi" forKey:@"EmailVerificationCode"];
    [postData setValue:@"0" forKey:@"EmailVerificationStatus"];
    [postData setValue:@"0" forKey:@"EmailVerified"];
    [postData setValue:@"" forKey:@"FacebookID"];
    [postData setValue:[NSString stringWithFormat:@"%d",i] forKey:@"FirstName"];
    [postData setValue:@"" forKey:@"FullName"];
    [postData setValue:@"" forKey:@"ImageURL"];
    [postData setValue:@"/Date(1368741781000+0000)/" forKey:@"LastLogin"];
    [postData setValue:@"" forKey:@"LastName"];
    [postData setValue:@"0" forKey:@"MobileAlerts"];
    [postData setValue:@"" forKey:@"MobileNumber"];
    [postData setValue:@"ThiI17j7gCWWFPQO" forKey:@"MobileVerificationCode"];
    [postData setValue:@"0" forKey:@"MobileVerificationStatus"];
    [postData setValue:@"0" forKey:@"MobileVerified"];
    [postData setValue:@"" forKey:@"TwitterID"];
    [postData setValue:@"0" forKey:@"UTCOffset"];
    [postData setValue:@"tester8" forKey:@"UserName"];
    
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
    
    NSHTTPURLResponse* response;
    NSData* responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if (error)
    {
        // if error then handle here
        NSLog(@"Rest Error: %@",error);
    }
    else if (responseData && [response statusCode] == 200)
    {
        // else if responseData then...
        // Get Response Code
        NSLog(@"Response: %@",response);
        [_textView setText:[NSString stringWithFormat:@"Response: %ld",(long)[response statusCode]]];
    }
}

-(void)addApplicationData
{
    // Request URL: Uses Endpoint with parameters to send
    NSString* requestUrl = [NSString stringWithFormat:@"https://service.proxomo.com/v09/json/person/%@/appdata",@"JwXMhxjNGGbX6AZC"];
    NSString* params = [NSString stringWithFormat: @"{\"Key\":\"%@\",\"Value\":\"%@\",\"ObjectType\":\"%@\"}",@"person-key", @"person-value", @"PROXOMO"];
    
    // Create a POST request
    NSString *postLength = [NSString stringWithFormat:@"%d", [[params dataUsingEncoding:NSUTF8StringEncoding] length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"POST"];
    [request setURL:[NSURL URLWithString:requestUrl]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    [request setValue:accessToken forHTTPHeaderField:@"Authorization"];
    
    NSError* error;
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
        lastAppDataID = responseID;
        [_textView setText:[NSString stringWithFormat:@"Created ID: %@",responseID]];
    }
}

-(void)getApplicationData
{
    // Request URL: Uses Endpoint with Data ID to get
    NSString* requestUrl = [NSString stringWithFormat:@"https://service.proxomo.com/v09/json/person/%@/appdata/%@",@"JwXMhxjNGGbX6AZC",lastAppDataID];
    
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

-(void)getAllApplicationData
{
    // Request URL: Uses Endpoint
    NSString* requestUrl = [NSString stringWithFormat:@"https://service.proxomo.com/v09/json/person/%@/appdata",@"JwXMhxjNGGbX6AZC"];
    
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
        // Get dictionary of all object in that app's data
        NSLog(@"Response Dictionary: %@",responseDictionary);
        [_textView setText:[NSString stringWithFormat:@"Response Dictionary: %@",responseDictionary]];
    }
}

-(void)updateApplicationData
{
    // Request URL: Uses Endpoint with paramters to update
    NSString* requestUrl = [NSString stringWithFormat:@"https://service.proxomo.com/v09/json/person/%@/appdata",@"JwXMhxjNGGbX6AZC"];
    NSString* params = [NSString stringWithFormat: @"{\"ID\": \"%@\",\"Key\":\"%@\",\"Value\":\"%@\",\"ObjectType\":\"%@\"}",lastAppDataID,@"person-key", @"updated-value", @"PROXOMO"];
    
    // Create a PUT request
    NSString *postLength = [NSString stringWithFormat:@"%d", [[params dataUsingEncoding:NSUTF8StringEncoding] length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"PUT"];
    [request setURL:[NSURL URLWithString:requestUrl]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    [request setValue:accessToken forHTTPHeaderField:@"Authorization"];
    
    NSError* error;
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

-(void)deleteApplicationData
{
    // Request URL: Uses Endpoint with Data ID to delete
    NSString* requestUrl = [NSString stringWithFormat:@"https://service.proxomo.com/v09/json/person/%@/appdata/%@",@"JwXMhxjNGGbX6AZC",lastAppDataID];
    
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

@end
