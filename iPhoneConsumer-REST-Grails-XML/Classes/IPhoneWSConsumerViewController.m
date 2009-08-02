// The view controller for the main UI of the contestant application.
// Handles buttons clicks for loading the initial set of contestants
// via the web service, adding contestants based on button clicks,
// picking a winner based on a button click and firing the XML
// parsers for all the inputs and outputs.
//
//  Created by Matthew McCullough of Ambient Ideas, LLC on 11/9/08.
//  Free for any use for any purpose.  No license restrictions.

#import "IPhoneWSConsumerViewController.h"
#import "InitialContestantsXMLParser.h"
#import "ContestantAddXMLParser.h"

@implementation IPhoneWSConsumerViewController

@synthesize txtContestantName, lblStatus, pckContestants;
@synthesize addButton;
@synthesize pickWinnerButton;
@synthesize activityIndicator;

@synthesize pickerData;

@synthesize webServiceProcessor;

static NSString * const CONTESTANT_LIST_WEBSERVICE_URL = @"http://localhost:8080/restgrails/contestantRESTList/";
static NSString * const ADD_CONTESTANT_WEBSERVICE_URL = @"http://localhost:8080/restgrails/contestantREST/?name=";
static NSString * const RANDOM_CONTESTANT_WEBSERVICE_URL = @"http://localhost:8080/restgrails/contestantRESTRandom";

/**
 * When the application is launched...
 *
 * 1) Load the initial empty array for contestants in the pickerView
 * 2) Stop the activity animation (flower)
 * 3) Initialize the web service handler
 * 4) Call the web service and get all the contestants for the pickerview.
 */
- (void)viewDidLoad 
{
	NSLog (@"viewDidLoad was called");
	NSMutableArray *array  = [[NSMutableArray alloc] initWithObjects: nil];
	self.pickerData = array;
	[array release];
	[activityIndicator stopAnimating];
	
	webServiceProcessor = [[WebServiceProcessor alloc] init];
	webServiceProcessor.viewController = self;
	
	//Load the existing names from the web service
	[self getInitialContestants];
}

/**
 * Utility method to get all the contestants from the web service
 * to initialize the picker view with.
 *
 * Set a selector of getInitialContestantsSuccess (callback) when the
 * web service succeeds and completes.
 */
- (void) getInitialContestants {
	
	//Register the success callback method for the XML parser to call
	// upon each parsing of a "name" tag in the response XML data stream.
	webServiceProcessor.successSelector = @selector(getInitialContestantsSuccess);
	
	//Consider just using the global string, not another allocated one
	NSString *urlString = [[NSString alloc] initWithString:CONTESTANT_LIST_WEBSERVICE_URL];
	[self initiateRESTCall:nil :urlString :@"GET"];
	
	[urlString release];
}

/**
 * A callback, passed to the asynchronous HTTP call, triggered when the HTTP call is done
 * (and successful) and we need to parse the XML returned from the HTTP call.
 * The XML contains the initial list of existing contestants.
 *
 * Provide the XML parser with a callback to the UI for add each parsed contestant
 * to the pickerview control.
 */
- (void) getInitialContestantsSuccess {
	[activityIndicator stopAnimating];
	
	InitialContestantsXMLParser* parser = [InitialContestantsXMLParser alloc];
	parser.nameFoundSelector = @selector(addContestantToListControl:);
	parser.parentController = self;
	//NSLog(@"about to handoff selector %@ to id %@", parser.nameFoundSelector, parser.parentController);
	[parser initWithData:webServiceProcessor.rawWSData];
	
	webServiceProcessor.wsTextResponse = parser.soapTagData;
	[parser release];
}

/**
 * A callback function, registered with the XML parser, and called each time
 * a contestant is encountered by the SAX parser.  Add the contestant to
 * the pickerView.
 */
- (void) addContestantToListControl:(NSString*) newContestant {
	//Add to pickerData data structure, which is backing the pickerView control
	[self.pickerData addObject:newContestant];
	//Reload the pickerView to show the new contestant
	[self.pckContestants reloadComponent:0];
}

/**
 * The button responder when ADD is pressed.
 *
 * Hides the keyboard if it is showing, starts the activity flower animation,
 * registers the success callback, and calls the web service.
 */
- (IBAction) addContestant:(id) sender {
	NSLog (@"Adding Contestant");
	
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
	webServiceProcessor.successSelector = @selector(addContestantSuccess);
	
	NSString *urlString = [[NSString alloc] initWithFormat:@"%@%@", ADD_CONTESTANT_WEBSERVICE_URL, txtContestantName.text];
	[self initiateRESTCall:nil :urlString :@"POST"];
	
	[urlString release];
}

/**
 * The HTTP-call/RESTful web service success callback handler. Processes the resultant successful add of a
 * name to the contestant pool by parsing the response XML, retriving the successfully added
 * contestant name, and adding that name to the pickerData data structure that backs the 
 * pickerView and setting a status message to indicate the successful add.
 */
- (void) addContestantSuccess {
	NSLog(@"addContestantSuccess");
	
	[activityIndicator stopAnimating];
	
	lblStatus.text = [[NSString alloc] initWithFormat:@"Contestant added: %@!", txtContestantName.text];
	
	ContestantAddXMLParser* parser = [ContestantAddXMLParser alloc];
	[parser initWithData:webServiceProcessor. rawWSData];
	webServiceProcessor.wsTextResponse = parser.soapTagData;
	[parser release];

	//Add to pickerData list control
	[self.pickerData addObject:webServiceProcessor.wsTextResponse];
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
	
	//Show that we are busy making the web service call
	[activityIndicator startAnimating];
	
	webServiceProcessor.successSelector = @selector(pickWinnerRESTSuccess);
	//TODO: Extract this web service URL to an instance constant
	[self initiateRESTCall:nil
						  :RANDOM_CONTESTANT_WEBSERVICE_URL
						  :@"GET"];
}

/**
 * The custom callback method called when the RESTful call to pickWinner is successful.
 *
 * Processes the aggregated textualized response string, and selects the UI row
 */
- (void) pickWinnerRESTSuccess {
	NSLog(@"getWinnerSuccess");
	
	[activityIndicator stopAnimating];
	
	ContestantAddXMLParser* parser = [ContestantAddXMLParser alloc];
	[parser initWithData:webServiceProcessor.rawWSData];
	webServiceProcessor.wsTextResponse = parser.soapTagData;
	[parser release];
	
	NSString *winner = [[NSString alloc] initWithFormat:@"Winner is: %@", webServiceProcessor.wsTextResponse];
	lblStatus.text = winner;
	[winner release];
	
	//Find which row in the data array this name is
	int rowForWinningContestant = 0;
	NSString *currentString = nil;
	for (rowForWinningContestant = 0; rowForWinningContestant < [pickerData count]; rowForWinningContestant++) {
		currentString = [pickerData objectAtIndex:rowForWinningContestant];
		if ([currentString isEqualToString:webServiceProcessor.wsTextResponse]) {
			[pckContestants selectRow:rowForWinningContestant inComponent:0 animated:YES];
		}
	}
	
	[self enableAllButtons: YES];
}


/**
 * Utility method to enable or disable all the UI buttons. Useful to block further input on 
 * the UI until a web service call has come back as successful or unsuccessful.
 */
- (void)enableAllButtons:(BOOL) enable
{
	[addButton setEnabled:enable];
	[pickWinnerButton setEnabled:enable];
}

/**
 * Interface method to release the keyboard display (hide it) when it is
 * no longer needed (focus shifts away from the input field)
 */
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField 
{
	NSLog (@"textFieldShouldReturn was called");
	[theTextField resignFirstResponder];
	return YES;
}
		

////////////////////////////////////////////////////////////////////////////
// Picker View (Table of Contestants)
////////////////////////////////////////////////////////////////////////////

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
									delegate:webServiceProcessor];
	
	//Allocate a NSMutableData to contain all the data chunks we'll receive from the WS
	webServiceProcessor.rawWSData = [[NSMutableData data] retain];

	[url release];
}

@end
