//
//  IPhoneWSConsumerViewController.h
//  IPhoneWSConsumer
//
//  Created by Matthew McCullough on 11/10/08.
//  Copyright Ambient Ideas, LLC 2008. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPhoneWSConsumerViewController : UIViewController {
	IBOutlet UITextField *txtContestantName;
	IBOutlet UILabel *lblStatus;
}
	
@property(nonatomic,retain) IBOutlet UITextField *txtContestantName;
@property(nonatomic,retain) IBOutlet UILabel *lblStatus;
- (IBAction) addContestant:(id) sender;
- (IBAction) pickWinner:(id) sender;

- (NSString*)pickWinnerWS;
@end

