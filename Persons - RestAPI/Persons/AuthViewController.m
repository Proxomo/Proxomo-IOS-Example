//
//  AuthViewController.m
//  Persons
//
//  Created by Richard Cribbet on 7/31/13.
//  Copyright (c) 2013 Proxomo. All rights reserved.
//

#import "AuthViewController.h"

#import "AppDelegate.h"

@interface AuthViewController ()

@end

@implementation AuthViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    accessToken = appDelegate.accessToken;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)create:(id)sender {
    [self create];
}

- (IBAction)deletePerson:(id)sender {
    [self deletePerson];
}

- (IBAction)appGet:(id)sender {
    [self appGet];
}

- (IBAction)updateRole:(id)sender {
    [self updateRole];
}

- (IBAction)auth:(id)sender {
    [self auth];
}

- (IBAction)passwordChange:(id)sender {
    [self passwordChange];
}

- (IBAction)passwordChangeRequest:(id)sender {
    [self passwordChangeRequest];
}

-(void)create
{
    // Request URL: Uses Endpoint with username and password to auth
    NSString* requestUrl = [NSString stringWithFormat:@"https://service.proxomo.com/v09/json/security/person/create?username=%@&password=%@&role=%@",@"Username", @"Password", @"User"];
    
    // Create a GET request
    NSMutableURLRequest *requestB = [[NSMutableURLRequest alloc] init];
    [requestB setHTTPMethod:@"POST"];
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

-(void)deletePerson
{
    // Request URL: Uses Endpoint with username and password to auth
    NSString* requestUrl = [NSString stringWithFormat:@"https://service.proxomo.com/v09/json/security/person/%@",@"personID"];
    
    // Create a GET request
    NSMutableURLRequest *requestB = [[NSMutableURLRequest alloc] init];
    [requestB setHTTPMethod:@"DELETE"];
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
        NSString* response = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        response = [response stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        // Get Response Code
        NSLog(@"Response: %@",response);
        [_textView setText:[NSString stringWithFormat:@"Response: %@",response]];
    }
}

-(void)appGet
{
    // Request URL: Uses Endpoint with username and password to auth
    NSString* requestUrl = [NSString stringWithFormat:@"https://service.proxomo.com/v09/json/security/persons"];
    
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
        NSArray *responseArray =[NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
        // Get dictionary of object requested
        NSLog(@"Response Array: %@",responseArray);
        [_textView setText:[NSString stringWithFormat:@"Response Array: %@",responseArray]];
    }
}

-(void)updateRole
{
    // Request URL: Uses Endpoint with username and password to auth
    NSString* requestUrl = [NSString stringWithFormat:@"https://service.proxomo.com/v09/json/security/person/update/role?personid=%@&role=%@",@"personID", @"User"];
    
    // Create a GET request
    NSMutableURLRequest *requestB = [[NSMutableURLRequest alloc] init];
    [requestB setHTTPMethod:@"PUT"];
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
        NSString* response = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        response = [response stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        // Get Response Code
        NSLog(@"Response: %@",response);
        [_textView setText:[NSString stringWithFormat:@"Response: %@",response]];
    }
}

-(void)auth
{
    // Request URL: Uses Endpoint with username and password to auth
    NSString* requestUrl = [NSString stringWithFormat:@"https://service.proxomo.com/v09/json/security/person/authenticate?applicationid=%@&username=%@&password=%@",@"ApplicationID",@"Username", @"Password"];
    
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
        NSString* responseID = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        responseID = [responseID stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        // Get ID of object created
        NSLog(@"Response ID: %@",responseID);
        lastAppDataID = responseID;
        [_textView setText:[NSString stringWithFormat:@"User token: %@",responseID]];
    }
}

-(void)passwordChange
{
    // Request URL: Uses Endpoint with a username, password and resetToken
    NSString* requestUrl = [NSString stringWithFormat:@"https://service.proxomo.com/v09/json/security/person/passwordchange?username=%@&password=%@&resettoken=%@",@"Username",@"Password",@"Token"];
    
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

-(void)passwordChangeRequest
{
    // Request URL: Uses Endpoint with username to get
    NSString* requestUrl = [NSString stringWithFormat:@"https://service.proxomo.com/v09/json/security/person/passwordchange/request/%@",@"Username"];
    
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
        NSString* responseID = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        responseID = [responseID stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        // Get ID of object created
        NSLog(@"Response ID: %@",responseID);
        lastAppDataID = responseID;
        [_textView setText:[NSString stringWithFormat:@"Request Token: %@",responseID]];
    }
}
@end
