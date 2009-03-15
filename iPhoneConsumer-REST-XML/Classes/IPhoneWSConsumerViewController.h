//  Created by Matthew McCullough of Ambient Ideas, LLC on 11/9/08.
//  Free for any use for any purpose.  No license restrictions.

#import <UIKit/UIKit.h>

@interface IPhoneWSConsumerViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource> {
	IBOutlet UITextField *txtContestantName;
	IBOutlet UILabel *lblStatus;
	IBOutlet UIPickerView *pckContestants;
	IBOutlet UIButton *addButton;
	IBOutlet UIButton *pickWinnerButton;
	IBOutlet UIActivityIndicatorView *activityIndicator;

	NSMutableArray *pickerData;
	NSXMLParser *xmlParser;
	NSMutableData *rawWSData;
	NSString *wsTextResponse;
	
	SEL errorSelector;
	SEL successSelector;
}
	
@property(nonatomic, retain) IBOutlet UITextField *txtContestantName;
@property(nonatomic, retain) IBOutlet UILabel *lblStatus;
@property(nonatomic, retain) UIPickerView *pckContestants;
@property(nonatomic, retain) IBOutlet UIButton *addButton;
@property(nonatomic, retain) IBOutlet UIButton *pickWinnerButton;

@property(nonatomic, retain) NSMutableArray *pickerData;
@property(nonatomic, retain) NSXMLParser *xmlParser;
@property(nonatomic, retain) NSMutableData *rawWSData;
@property(retain) NSString *wsTextResponse;

@property(nonatomic, assign) SEL errorSelector;
@property(nonatomic, assign) SEL successSelector;

- (IBAction) addContestant:(id) sender;
- (IBAction) pickWinner:(id) sender;
- (void)enableAllButtons:(BOOL) enable;
- (void)initiateRESTCall:(NSData*) bodyData
						:(NSString*) urlString
						:(NSString*) httpMethod;

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField;

//- (NSString*)pickWinnerWS;
@property (retain) UIActivityIndicatorView *activityIndicator;
@end

