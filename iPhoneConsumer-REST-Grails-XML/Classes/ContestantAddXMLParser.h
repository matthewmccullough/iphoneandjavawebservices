//
//  ContestantAddXMLParser.h
//  IPhoneWSConsumer
//
//  Created by Matthew McCullough on 3/15/09.
//  Copyright 2009 Ambient Ideas, LLC. All rights reserved.
//

@interface ContestantAddXMLParser : NSObject {
	NSMutableString *soapTagData;
	NSXMLParser *xmlParser;
}

@property(nonatomic, retain) NSMutableString *soapTagData;
@property(nonatomic, retain) NSXMLParser *xmlParser;

-(id) initWithData:(NSData*) rawWSData;

@end
