//
//  IPhoneWSConsumerAppDelegate.h
//  IPhoneWSConsumer
//
//  Created by Matthew McCullough on 11/10/08.
//  Copyright Ambient Ideas, LLC 2008. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IPhoneWSConsumerViewController;

@interface IPhoneWSConsumerAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    IPhoneWSConsumerViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet IPhoneWSConsumerViewController *viewController;

@end

