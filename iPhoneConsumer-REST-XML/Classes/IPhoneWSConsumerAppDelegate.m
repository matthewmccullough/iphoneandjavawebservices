//  Created by Matthew McCullough of Ambient Ideas, LLC on 11/9/08.
//  Free for any use for any purpose.  No license restrictions.

#import "IPhoneWSConsumerAppDelegate.h"
#import "IPhoneWSConsumerViewController.h"

@implementation IPhoneWSConsumerAppDelegate

@synthesize window;
@synthesize viewController;

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
}

- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
