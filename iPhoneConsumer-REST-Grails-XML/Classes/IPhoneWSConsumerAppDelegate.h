//  Created by Matthew McCullough of Ambient Ideas, LLC on 11/9/08.
//  Free for any use for any purpose.  No license restrictions.

#import <UIKit/UIKit.h>

@class IPhoneWSConsumerViewController;

@interface IPhoneWSConsumerAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    IPhoneWSConsumerViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet IPhoneWSConsumerViewController *viewController;

@end

