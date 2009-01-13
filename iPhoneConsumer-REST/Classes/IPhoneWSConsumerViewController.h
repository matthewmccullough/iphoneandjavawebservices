//
//  IPhoneWSConsumerViewController.h
//  IPhoneWSConsumer
//
//  Created by Matthew McCullough on 11/10/08.
//  Copyright Ambient Ideas, LLC 2008. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPhoneWSConsumerViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource> {
	IBOutlet UITextField *txtContestantName;
	IBOutlet UILabel *lblStatus;
	IBOutlet UIPickerView *pckContestants;
	NSMutableArray *pickerData;
}
	
@property(nonatomic,retain) IBOutlet UITextField *txtContestantName;
@property(nonatomic,retain) IBOutlet UILabel *lblStatus;
@property(nonatomic,retain) UIPickerView *pckContestants;
@property(nonatomic,retain) NSMutableArray *pickerData;

- (IBAction) addContestant:(id) sender;
- (IBAction) pickWinner:(id) sender;

//- (NSString*)pickWinnerWS;
@end

