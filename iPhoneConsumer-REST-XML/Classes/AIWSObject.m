//  Created by Matthew McCullough of Ambient Ideas, LLC on 11/9/08.
//  Free for any use for any purpose.  No license restrictions.

#import "AIWSObject.h"

@implementation AIWSObject

/**
 * Add a name to the contestant list via a web service call.
 * Appears to leak memory on the sendSynchronousRequest call.
 * Apple acknowledges. Hasn't fixed it since October 2008 at a minimum on the 2.2 firmware/SDK
 * http://lists.apple.com/archives/Macnetworkprog/2008/Nov/msg00013.html
 * and
 * http://discussions.apple.com/thread.jspa?messageID=8200590
 *
 */
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
	
	// Retry the web service call up to three times
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

/**
 * Pick a winner from the contestant list via a web service call and return their name.
 */
- (NSString*)initiateRESTPickWinner
{
	NSString *baseURLString = @"http://Opus.local:9090/drawing/";
	NSURL *url = [[NSURL alloc] initWithString:baseURLString];
	NSLog(@"Pick Winner URL: %d", *url);
	NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:url];
	[req setHTTPMethod:@"GET"];
	NSLog(@"Pick Winner request: %d", *req);
	
	BOOL success = false;
	int retryCount = 0;
	NSString *result = nil;
	
	// Retry the web service call up to three times
	while (success == false && retryCount <3) {
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
		//Log the usual HTTP 200 through 299 responses
		if ([response statusCode] >= 200 && [response statusCode] < 300) {
			NSLog(@"Result: %@", result);
			success = true;
		}
		//HTTP 204 is a NULL Payload which we occasionally and inexplicably get. Highly reproducible.
		if ([response statusCode] == 204) {
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