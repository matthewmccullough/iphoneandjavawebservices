//
//  WebServiceProcessor.m
//  IPhoneWSConsumer
//
//  Created by Matthew McCullough on 7/26/09.
//  Copyright 2009 Ambient Ideas, LLC. All rights reserved.
//

#import "WebServiceProcessor.h"


@implementation WebServiceProcessor

@synthesize rawWSData;
@synthesize wsTextResponse;

//@synthesize errorSelector;
@synthesize successSelector;

@synthesize viewController;

////////////////////////////////////////////////////////////////////////////////////
// HTTP Communication Callbacks
///////////////////////////////////////////////////////////////////////////////////

/**
 * APPLE DOCUMENTATION:
 * This method is called when the server has determined that it
 * has enough information to create an NSURLResponse.
 *
 * It can be called multiple times, for example in the case of a
 * redirect, so each time we reset the data.
 */
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSHTTPURLResponse *)response {
	
    [rawWSData setLength:0];
	
	NSLog (@"connectionDidReceiveResponse");
	
	//////////////////////////////////////////////////////////////////
	// Check the response code for any HTTP connectivity errors
	//////////////////////////////////////////////////////////////////
	NSLog(@"Response Code: %d", [response statusCode]);
	NSLog(@"Content-Type: %@", [[response allHeaderFields] objectForKey:@"Content-Type"]);
	
	//Good response codes are 200 through 299
	if ([response statusCode] >= 200 && [response statusCode] < 300 && [response statusCode] != 204) {
		//Call was successful
		NSLog(@"Web service call deemed successful based on status code.");
	}
	else {
		//Bad response codes are 204 (null payload) and 400 series
		
		//Build and show an alert dialog (overlay)
		UIAlertView *errorAlert = [[UIAlertView alloc]
								   initWithTitle: @"Error"
								   message: [[NSString alloc] initWithFormat:@"Error in Web Service call. Response code %d", [response statusCode]]
								   delegate:nil
								   cancelButtonTitle:@"OK"
								   otherButtonTitles:nil];
		[errorAlert show];
		[errorAlert release];
	}
}

/**
 * We received a chunk of data (but not guaranteed to be all of it).
 * Append to our data buffer.
 * Can be used to indicate progress to the user.
 */
- (void)connection:(NSURLConnection *)connection
	didReceiveData:(NSData *)data {
	NSLog (@"connectionDidReceiveData");
	
	[rawWSData appendData:data];
}

/**
 * The HTTP communication is complete. We can now process the data that was received in chunks.
 */
- (void) connectionDidFinishLoading: (NSURLConnection*) connection {
	NSLog (@"connectionDidFinishLoading");
	
	wsTextResponse = [[NSString alloc]
					  initWithData:rawWSData
					  encoding:NSUTF8StringEncoding];
	if (wsTextResponse != NULL) {
		NSLog(@"Web service response: %@", wsTextResponse);
	}
	
	//Call the success selector so that the UI can unlock the UI, parse the response XML, and update
	// any related data-backed controls.
	[viewController performSelector:successSelector];
	
	[wsTextResponse release];
	[connection release];
    [rawWSData release];
}

/**
 * The HTTP connection failed with a catastrophic error.
 */
-(void) connection:(NSURLConnection *)connection
  didFailWithError: (NSError *)error {
	NSLog (@"Connection Failed with Error");
	
	[connection release];
	[rawWSData release];
	
	//Build and show an error message
	UIAlertView *errorAlert = [[UIAlertView alloc]
							   initWithTitle: [error localizedDescription]
							   message: [error localizedFailureReason]
							   delegate:nil
							   cancelButtonTitle:@"OK"
							   otherButtonTitles:nil];
	[errorAlert show];
	[errorAlert release];
}

@end
