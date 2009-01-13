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

@synthesize txtContestantName,lblStatus,pckContestants;
@synthesize pickerData;


- (IBAction) addContestant:(id) sender {	
	NSString* statusText;
	
	if([txtContestantName.text length] == 0) {
		statusText = @"No status";
	}
	else {
		statusText = [[NSString alloc] initWithFormat:@"Contestant added: %@!",txtContestantName.text];
		[self.pickerData addObject:txtContestantName.text];
		[self.pckContestants setNeedsDisplay];
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

	statusText = [@"Winner is: " stringByAppendingString: winnerName];
	
	lblStatus.text = statusText;
	
	[winnerName release];
	[webservice release];
}


/////
		
		
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField 
{
	NSLog(@"%@ textFieldShouldReturn", [self class]);
	[theTextField resignFirstResponder];
	// do stuff with the text
	NSLog(@"text = %@", [theTextField text]);
	return YES;
}
		
		
///////////

- (void)viewDidLoad 
{
	NSMutableArray  *array  = [[NSMutableArray alloc] initWithObjects: @"Luke",
						@"Leia", @"Han", nil];
	self.pickerData  = array;
	[array release];
}

- (NSInteger)numberOfComponentsInPickerView: (UIPickerView *)pickerView
{
	return 1;
}

- (NSInteger)pickerView: (UIPickerView *)pickerView
numberOfRowsInComponent: (NSInteger)component 
{
	return [pickerData count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView
			 titleForRow: (NSInteger)row
			forComponent: (NSInteger)component
{
	return [pickerData objectAtIndex: row];
}

@end
