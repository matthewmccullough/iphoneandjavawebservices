#import <Foundation/Foundation.h>

@interface WebServiceProcessor : NSObject {
	NSMutableData *rawWSData;
	NSString *wsTextResponse;
		
	//SEL errorSelector;
	SEL successSelector;
	
	id viewController;
}

	@property(nonatomic, retain) NSMutableData *rawWSData;
	@property(nonatomic, retain) NSString *wsTextResponse;

	//@property(nonatomic, assign) SEL errorSelector;
	@property(nonatomic, assign) SEL successSelector;

	@property (assign) id viewController;
@end