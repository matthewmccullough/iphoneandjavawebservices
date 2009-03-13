//  Created by Matthew McCullough of Ambient Ideas, LLC on 11/9/08.
//  Free for any use for any purpose.  No license restrictions.

#import "IPhoneWSConsumerViewController.h"

@implementation IPhoneWSConsumerViewController

@synthesize txtContestantName,lblStatus,pckContestants;
@synthesize pickerData;

NSString *baseURLString = @"http://Opus.local:9090/drawing/";


- (IBAction) addContestant:(id) sender {
	NSLog (@"addContestant");
	[txtContestantName resignFirstResponder];
	
	NSLog (@"startAnimating");
	[activityIndicator startAnimating];
	
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
	NSLog (@"webService AddName");
	NSLog(statusText);
	[self initiateRESTAddName:txtContestantName.text];
	
	[statusText release];
}


- (IBAction) pickWinner:(id) sender {
	NSLog (@"pickWinner");
	NSString* statusText;
	NSString* winnerName = @"DEFAULT";

	//Call WS
	winnerName = [self initiateRESTPickWinner];

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
}

	

/**
 * Release the keyboard display (hide it)
 */
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField 
{
	NSLog (@"textFieldShouldReturn");
	[theTextField resignFirstResponder];
	return YES;
}
		

/**
 * Load the initial empty array for contestants in the pickerView
 */
- (void)viewDidLoad 
{
	NSLog (@"viewDidLoad");
	NSMutableArray  *array  = [[NSMutableArray alloc] initWithObjects: nil];
	self.pickerData  = array;
	[array release];
	[activityIndicator stopAnimating];
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

//WEB SERVICE
//////////////////////////////////////////

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
	[activityIndicator startAnimating];
	NSString *urlString = [[NSString alloc] initWithFormat:@"%@%@", baseURLString, contestantName];
	NSURL *url = [[NSURL alloc] initWithString:urlString];
	NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:url];
	[req setHTTPMethod:@"PUT"];
	
	//Asynchronous
	NSURLConnection *connection = [[NSURLConnection alloc]
								   initWithRequest:req
								   delegate:self];
	
	[urlString release];
	[url release];
	[req release];
	[connection release];
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	NSLog (@"connectionDidReceiveResponse");
	
	NSLog(@"Response Code: %d", [response statusCode]);
	NSLog(@"Content-Type: %@", [[response allHeaderFields] objectForKey:@"Content-Type"]);
	//Good response codes are 200 through 299
	if ([response statusCode] >= 200 && [response statusCode] < 300 && [response statusCode] != 204) {
		//Call was successful
		NSLog(@"Web service call deemed successful based on status code.");
	}
	else {
		//Bad response codes are 204 (null payload) and 400 series
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

- (void)connection:(NSURLConnection *)connection
	didReceiveData:(NSData *)data {
	NSLog (@"connectionDidReceiveData");
	NSString *newText = [[NSString alloc]
						 initWithData:data
						 encoding:NSUTF8StringEncoding];
	if (newText != NULL) {
		NSLog(newText);
		//[self appendTextToView:newText];
		[newText release];
	}
}

- (void) connectionDidFinishLoading: (NSURLConnection*) connection {
	NSLog (@"connectionDidFinishLoading");
	[activityIndicator stopAnimating];
}

-(void) connection:(NSURLConnection *)connection
  didFailWithError: (NSError *)error {
	UIAlertView *errorAlert = [[UIAlertView alloc]
							   initWithTitle: [error localizedDescription]
							   message: [error localizedFailureReason]
							   delegate:nil
							   cancelButtonTitle:@"OK"
							   otherButtonTitles:nil];
	[errorAlert show];
	[errorAlert release];
	[activityIndicator stopAnimating];
	NSLog (@"Connection Failed with Error");
}





/**
 * Pick a winner from the contestant list via a web service call and return their name.
 */
- (NSString*)initiateRESTPickWinner
{
	NSURL *url = [[NSURL alloc] initWithString:baseURLString];
	NSLog(@"Pick Winner URL: %d", *url);
	NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:url];
	[req setHTTPMethod:@"GET"];
	NSLog(@"Pick Winner request: %d", *req);
	
	BOOL success = false;
	
	NSString *result = nil;
	
	
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
			
	[url release];
	[req release];
	
	return result;
}

@end
