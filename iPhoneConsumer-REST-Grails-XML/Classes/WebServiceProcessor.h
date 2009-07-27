//
//  WebServiceProcessor.h
//  IPhoneWSConsumer
//
//  Created by Matthew McCullough on 7/26/09.
//  Copyright 2009 Ambient Ideas, LLC. All rights reserved.
//

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