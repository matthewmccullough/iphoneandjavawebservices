#import <UIKit/UIKit.h>

@class HelloBackAtYouViewController;

@interface HelloBackAtYouAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    HelloBackAtYouViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet HelloBackAtYouViewController *viewController;

@end