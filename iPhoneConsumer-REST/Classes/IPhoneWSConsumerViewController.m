//  Created by Matthew McCullough of Ambient Ideas, LLC on 11/9/08.
//  Free for any use for any purpose.  No license restrictions.

#import "IPhoneWSConsumerViewController.h"
#import "AIWSObject.h"

@implementation IPhoneWSConsumerViewController

@synthesize txtContestantName,lblStatus,pckContestants;
@synthesize pickerData;


- (IBAction) addContestant:(id) sender {	
	[self textFieldShouldReturn:txtContestantName];
	
	NSString* statusText;
	
	if([txtContestantName.text length] == 0) {
		statusText = @"No status";
	}
	else {
		statusText = [[NSString alloc] initWithFormat:@"Contestant added: %@!",txtContestantName.text];
		[self.pickerData addObject:txtContestantName.text];
		[self.pckContestants reloadComponent:0];
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
	
	//Find which row in the data array this name is
	int rowForWinningContestant = 0;
	NSString *currentString = nil;
	for (rowForWinningContestant = 0; rowForWinningContestant < [pickerData count]; rowForWinningContestant++) {
		currentString = [pickerData objectAtIndex:rowForWinningContestant];
		if ([currentString isEqualTo:winnerName]) {
			[pckContestants selectRow:rowForWinningContestant inComponent:0 animated:YES];
		}
	}
	
	[winnerName release];
	[webservice release];
}

	

/**
 * Release the keyboard display (hide it)
 */
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField 
{
	[theTextField resignFirstResponder];
	return YES;
}
		

/**
 * Load the initial empty array for contestants in the pickerView
 */
- (void)viewDidLoad 
{
	//NSMutableArray  *array  = [[NSMutableArray alloc] initWithObjects: @"Luke", @"Leia", @"Han", nil];
	NSMutableArray  *array  = [[NSMutableArray alloc] initWithObjects: nil];
	self.pickerData  = array;
	[array release];
}

/**
 * How many columns. Just 1 at this time.
 */
- (NSInteger)numberOfComponentsInPickerView: (UIPickerView *)pickerView
{
	return 1;
}

/**
 * How many rows in the pickerview? As many as are in the data backing store.
 */
- (NSInteger)pickerView: (UIPickerView *)pickerView
			numberOfRowsInComponent: (NSInteger)component 
{
	return [pickerData count];
}

/**
 * Get the title for a row in the pickerview
 */
- (NSString *)pickerView:(UIPickerView *)pickerView
			 titleForRow: (NSInteger)row
			forComponent: (NSInteger)component
{
	return [pickerData objectAtIndex: row];
}

@end
