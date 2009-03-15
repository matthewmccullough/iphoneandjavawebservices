//  Created by Matthew McCullough of Ambient Ideas, LLC on 11/9/08.
//  Free for any use for any purpose.  No license restrictions.

#import "IPhoneWSConsumerViewController.h"
#import "ContestantAddXMLParser.h"

@implementation IPhoneWSConsumerViewController

@synthesize txtContestantName, lblStatus, pckContestants;
@synthesize addButton;
@synthesize pickWinnerButton;
@synthesize activityIndicator;

@synthesize pickerData;

@synthesize rawWSData;
@synthesize wsTextResponse;

@synthesize errorSelector;
@synthesize successSelector;

NSString *baseURLString = @"http://localhost:8080/restgrails/contestantsRESTList";

/**
 * The button responder when ADD is pressed.
 *
 * Hides the keyboard if it is showing, starts the activity flower animation,
 * registers the success callback, and calls the web service.
 */
- (IBAction) addContestant:(id) sender {
	NSLog (@"addContestant");
	
	[self enableAllButtons: NO];
	
	//Hide the keyboard
	[txtContestantName resignFirstResponder];
	
	[activityIndicator startAnimating];
	
	//Check the length 
	if([txtContestantName.text length] == 0) {
		lblStatus.text = @"Please supply a non-empty contestant name to add";
		[self enableAllButtons: YES];
		return;
	}
	
	//Register the success callback method
	successSelector = @selector(addContestantSuccess);
	
	NSString *urlString = [[NSString alloc] initWithFormat:@"%@%@", @"http://localhost:8080/restgrails/contestantREST/?name=", txtContestantName.text];
	[self initiateRESTCall:nil :urlString :@"POST"];
	
	[urlString release];
}

/**
 * The RESTful web service success callback handler. Processes the resultant successful add of a
 * name to the contestant pool by adding it to the pickerData list view and setting a status message
 * to indicate the successful add.
 */
- (void) addContestantSuccess {
	NSLog(@"addContestantSuccess");
	
	lblStatus.text = [[NSString alloc] initWithFormat:@"Contestant added: %@!", txtContestantName.text];
	
	ContestantAddXMLParser* parser = [ContestantAddXMLParser alloc];
	[parser initWithData:rawWSData];
	self.wsTextResponse = parser.soapTagData;
	[parser release];

	//Add to pickerData list control
	[self.pickerData addObject:wsTextResponse];
	//Reload the view to show the new contestant
	[self.pckContestants reloadComponent:0];
	
	[self enableAllButtons: YES];
	
	[lblStatus.text release];
}


/**
 * The button click handler for picking a winner.
 *
 * Kicks off the process of setting the web service VERB, calling the web service,
 * registering the callback, and processing the return data.
 */
- (IBAction) pickWinner:(id) sender {
	[self enableAllButtons: NO];
	
	NSLog (@"pickWinner");
	//Hide the keyboard
	[txtContestantName resignFirstResponder];
	
	[activityIndicator startAnimating];
	
	successSelector = @selector(pickWinnerRESTSuccess);
	[self initiateRESTCall:nil
						  :@"http://localhost:8080/restgrails/contestantRESTRandom"
						  :@"GET"];
}

/**
 * The custom callback method called when the RESTful call to pickWinner is successful.
 *
 * Processes the aggregated textualized response string, and selects the UI row
 */
- (void) pickWinnerRESTSuccess {
	NSLog(@"getWinnerSuccess");
	
	ContestantAddXMLParser* parser = [ContestantAddXMLParser alloc];
	[parser initWithData:rawWSData];
	self.wsTextResponse = parser.soapTagData;
	[parser release];
	
	NSString *winner = [[NSString alloc] initWithFormat:@"Winner is: %@", self.wsTextResponse];
	lblStatus.text = winner;
	[winner release];
	
	//Find which row in the data array this name is
	int rowForWinningContestant = 0;
	NSString *currentString = nil;
	for (rowForWinningContestant = 0; rowForWinningContestant < [pickerData count]; rowForWinningContestant++) {
		currentString = [pickerData objectAtIndex:rowForWinningContestant];
		if ([currentString isEqualTo:self.wsTextResponse]) {
			[pckContestants selectRow:rowForWinningContestant inComponent:0 animated:YES];
		}
	}
	
	[self enableAllButtons: YES];
}


//////////////////////////////////////////////////////////////////
// UI Methods
//////////////////////////////////////////////////////////////////

/**
 * Enable or disable the buttons. Useful to block further input on 
 * the UI until a web service call has come back as successful or unsuccessful.
 */
- (void)enableAllButtons:(BOOL) enable
{
	[addButton setEnabled:enable];
	[pickWinnerButton setEnabled:enable];
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
		

////////////////////////////////////////////////////////////////////////////
// Picker View (Table of Contestants)
////////////////////////////////////////////////////////////////////////////

/**
 * Load the initial empty array for contestants in the pickerView
 */
- (void)viewDidLoad 
{
	NSLog (@"viewDidLoad");
	NSMutableArray *array  = [[NSMutableArray alloc] initWithObjects: nil];
	self.pickerData = array;
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



//////////////////////////////////////////////////////////////////////////////////
// WEB SERVICE
// Documentation at:
// http://developer.apple.com/documentation/Cocoa/Conceptual/URLLoadingSystem/Tasks/UsingNSURLConnection.html
//////////////////////////////////////////////////////////////////////////////////

/**
 * Add a name to the contestant list via a web service call.
 *
 * Appears to leak memory on the sendSynchronousRequest variant of the call.  The async version does not leak as much.
 *
 * Apple acknowledged my defect. Hasn't fixed it since October 2008 at a minimum on the 2.2 firmware/SDK
 * http://lists.apple.com/archives/Macnetworkprog/2008/Nov/msg00013.html
 * and
 * http://discussions.apple.com/thread.jspa?messageID=8200590
 */
- (void)initiateRESTCall:(NSData*) bodyData
						:(NSString*) urlString
						:(NSString*) httpMethod
{
	[activityIndicator startAnimating];
	
	NSURL *url = [[NSURL alloc] initWithString:urlString];
	
	//****** DANGER *******
	//NOTE: initWithURL can only be called on an alloced request; requestWithURL allocs and sets up.
	//NOTE: initWithURL leaks memory, even if you release the request. requestWithURL does not leak at all.
	NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
	[req setHTTPMethod:httpMethod];
	if (bodyData != nil) {
		[req setHTTPBody:bodyData];
	}
	
	//Asynchronous.
	//Connection returned from this call will be released upon error or success async methods.
	[[NSURLConnection alloc] initWithRequest:req
									delegate:self];
	
	//Allocate a NSMutableData to contain all the data chunks we'll receive from the WS
	rawWSData = [[NSMutableData data] retain];

	[url release];
}


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
 * The communication is complete. We can now process the data that was received in chunks.
 */
- (void) connectionDidFinishLoading: (NSURLConnection*) connection {
	NSLog (@"connectionDidFinishLoading");
	[activityIndicator stopAnimating];

	wsTextResponse = [[NSString alloc]
						 initWithData:rawWSData
						 encoding:NSUTF8StringEncoding];
	if (wsTextResponse != NULL) {
		NSLog(@"Web service response: %@", wsTextResponse);
	}
	
	[self performSelector:successSelector];
	
	[wsTextResponse release];
	[connection release];
    [rawWSData release];
}

/**
 * The connection failed with a catastrophic error.
 */
-(void) connection:(NSURLConnection *)connection
  didFailWithError: (NSError *)error {
	[activityIndicator stopAnimating];
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



//////////////////////////////////////////////////////////////////////////
//XML parsing
//////////////////////////////////////////////////////////////////////////

@end
