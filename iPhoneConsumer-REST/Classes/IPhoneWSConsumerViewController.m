//
//  IPhoneWSConsumerViewController.m
//  IPhoneWSConsumer
//
//  Created by Matthew McCullough on 11/10/08.
//  Copyright Ambient Ideas, LLC 2008. All rights reserved.
//

#import "IPhoneWSConsumerViewController.h"
#import "AIWSObject.h"

@implementation IPhoneWSConsumerViewController

@synthesize txtContestantName,lblStatus;


- (IBAction) addContestant:(id) sender {
	NSString* statusText;
	
	if([txtContestantName.text length] == 0) {
		statusText = @"No status";
	}
	else {
		//Release the old before assigning the new
		//if (statusText != nil) {
//			[statusText release];
//		}
		
		statusText = [[NSString alloc] initWithFormat:@"Contestant added: %@!",txtContestantName.text];
	}
	lblStatus.text = statusText;
	
	//Web Service call
	AIWSObject *webservice = [[AIWSObject alloc] init];
	[webservice initiateRESTAddName:txtContestantName.text];
	
	[webservice release];
	[statusText release];
}


- (IBAction) pickWinner:(id) sender {
	NSString* statusText;
	NSString* winnerName = @"DEFAULT";

	//Call WS
	AIWSObject *webservice = [[AIWSObject alloc] init];
	winnerName = [webservice initiateRESTPickWinner];
	
	//Convert NSData to NSString
	//NSString *sourceSt = [[NSString alloc] initWithBytes:[downloadedData bytes] length:[downloadedData length] encoding:NSUTF8StringEncoding];
		
	statusText = [@"Winner is: " stringByAppendingString: winnerName];
	
	lblStatus.text = statusText;
	
	[winnerName release];
	[webservice release];
}



@end
