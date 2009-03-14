//  Created by Matthew McCullough of Ambient Ideas, LLC on 11/9/08.
//  Free for any use for any purpose.  No license restrictions.

@interface AIWSObject : NSObject {
}

- (void)initiateRESTAddName:(NSString*) contestantName;
- (NSString*)initiateRESTPickWinner;

@end