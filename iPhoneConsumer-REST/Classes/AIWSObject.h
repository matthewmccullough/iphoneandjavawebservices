@interface AIWSObject : NSObject {
}

- (NSMutableData*)initiateSOAPConnection:(NSString*) name;

- (void)initiateRESTAddName:(NSString*) contestantName;

- (NSString*)initiateRESTPickWinner;

@end