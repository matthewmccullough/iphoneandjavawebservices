//
//  WebService.m
//  SeismicXML
//
//  Created by Matthew McCullough on 11/9/08.
//  Copyright 2008 Ambient Ideas, LLC. All rights reserved.
//
// http://discussions.apple.com/thread.jspa?messageID=8200590

#import "AIWSObject.h"


@implementation AIWSObject

	
- (void)initiateRESTAddName:(NSString*) contestantName
{
	NSString *baseURLString = @"http://Opus.local:9090/drawing/";
	NSString *urlString = [[NSString alloc] initWithFormat:@"%@%@", baseURLString, contestantName];
	NSURL *url = [[NSURL alloc] initWithString:urlString];
	NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:url];
	[req setHTTPMethod:@"PUT"];
	
	
	BOOL success = false;
	int retryCount = 0;
	NSString *result = nil;
	
	while (success == false && retryCount <=3) {
		NSHTTPURLResponse* response = nil;  
		NSError* error = nil;  
		NSData *responseData = [NSURLConnection sendSynchronousRequest:req   
													 returningResponse:&response  
																 error:&error];  
		result = [[NSString alloc] initWithData:responseData 
									   encoding:NSUTF8StringEncoding];
		NSLog(@"Response Code: %d", [response statusCode]);
		NSLog(@"Content-Type: %@", [[response allHeaderFields] 
									objectForKey:@"Content-Type"]);
		if ([response statusCode] >= 200 && [response statusCode] < 300) {
			NSLog(@"Result: %@", result);
			success = true;
		}
		if ([response statusCode] == 204) {
			//Error - Null Payload
			[result release];
			success = false;
		}
		
		retryCount++;
	}
		
	[urlString release];
	[url release];
	[req release];
	//Didn't ever do anything with the result so just release it here
	[result release];
}

- (NSString*)initiateRESTPickWinner
{
	NSString *baseURLString = @"http://Opus.local:9090/drawing/";
	//NSString *urlString = [[NSString alloc] initWithFormat:@"%@%@", baseURLString, queryTerm];
	NSURL *url = [[NSURL alloc] initWithString:baseURLString];
	NSLog(@"Pick Winner URL: %d", *url);
	NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:url];
	[req setHTTPMethod:@"GET"];
	NSLog(@"Pick Winner request: %d", *req);
	
	BOOL success = false;
	int retryCount = 0;
	NSString *result = nil;
	
	while (success == false && retryCount <=3) {
		NSHTTPURLResponse* response = nil;  
		NSError* error = nil;  
		NSData *responseData = [NSURLConnection sendSynchronousRequest:req   
												 returningResponse:&response  
															 error:&error];  
		result = [[NSString alloc] initWithData:responseData 
											 encoding:NSUTF8StringEncoding];
		NSLog(@"Response Code: %d", [response statusCode]);
		NSLog(@"Content-Type: %@", [[response allHeaderFields] 
								objectForKey:@"Content-Type"]);
		if ([response statusCode] >= 200 && [response statusCode] < 300) {
			NSLog(@"Result: %@", result);
			success = true;
		}
		if ([response statusCode] == 204) {
			//Error - Null Payload
			[result release];
			success = false;
		}
		
		retryCount++;
	}
	
	[url release];
	[req release];
	
	return result;
}


@end