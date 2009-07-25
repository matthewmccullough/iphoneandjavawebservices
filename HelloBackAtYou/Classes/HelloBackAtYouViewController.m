#import "HelloBackAtYouViewController.h"

@implementation HelloBackAtYouViewController

@synthesize name, hello;

- (IBAction)submitPressed:(id)sender {
	NSLog (@"Submit button pressed.");
	NSString *helloText = [[NSString alloc] initWithFormat:@"Hello there %@", name.text];
	hello.text = helloText;
	
	[name resignFirstResponder];
}

@end
