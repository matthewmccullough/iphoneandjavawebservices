//
//  InitialContestantsXMLParser.h
//  IPhoneWSConsumer
//
//  Created by Matthew McCullough on 3/15/09.
//  Copyright 2009 Ambient Ideas, LLC. All rights reserved.
//

#include "IPhoneWSConsumerViewController.h"

@interface InitialContestantsXMLParser : NSObject {
	NSMutableString *soapTagData;
	NSXMLParser *xmlParser;
	SEL nameFoundSelector;
	id parentController;
}

@property(nonatomic, retain) NSMutableString *soapTagData;
@property(nonatomic, retain) NSXMLParser *xmlParser;
@property(nonatomic, assign) SEL nameFoundSelector;

//Changed the parent controller from a IPhoneWSConsumerViewController to an id to reduce warnings
//@property (nonatomic, assign) IPhoneWSConsumerViewController *parentController;
@property(nonatomic, assign) id parentController;

-(id) initWithData:(NSData*) rawWSData;

@end
