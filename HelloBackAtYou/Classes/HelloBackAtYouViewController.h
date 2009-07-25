#import <UIKit/UIKit.h>

@interface HelloBackAtYouViewController : UIViewController {
	IBOutlet UITextField *name;
	IBOutlet UILabel *hello;
}

@property (nonatomic, retain) IBOutlet UITextField *name;
@property (nonatomic, retain) IBOutlet UILabel *hello;

- (IBAction)submitPressed:(id)sender;

@end

