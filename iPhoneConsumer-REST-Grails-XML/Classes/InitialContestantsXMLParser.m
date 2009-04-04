//
//  InitialContestantsXMLParser.m
//  IPhoneWSConsumer
//
//  Created by Matthew McCullough on 3/15/09.
//  Copyright 2009 Ambient Ideas, LLC. All rights reserved.
//

#import "InitialContestantsXMLParser.h"


@implementation InitialContestantsXMLParser

@synthesize soapTagData;
@synthesize xmlParser;

@synthesize nameFoundSelector;
@synthesize parentController;

BOOL recordThisTag2 = FALSE;


-(id) initWithData:(NSData*) rawWSData
{
	if ( self = [super init] )
    {
        xmlParser = [[NSXMLParser alloc] initWithData: rawWSData];
		[xmlParser setDelegate: self];
		[xmlParser setShouldResolveExternalEntities: YES];
		[xmlParser parse];
    }
    return self;
}
-(void) dealloc
{
	[xmlParser release];
	[soapTagData release];
	soapTagData = nil;
	[super dealloc];
}

//////////////////////////////////////////////////////////////////
// XML PARSER
//////////////////////////////////////////////////////////////////
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *)qName
   attributes: (NSDictionary *)attributeDict
{
	if( [elementName isEqualToString:@"name"])
	{
		
		soapTagData = [[NSMutableString alloc] init];
		
		recordThisTag2 = TRUE;
	}
}
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	if( recordThisTag2 )
	{
		[soapTagData appendString: string];
	}
}
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	if( [elementName isEqualToString:@"name"])
	{
		//NSLog(@"about to send selector %@ to id %@", nameFoundSelector, parentController);
		[parentController performSelector:nameFoundSelector withObject:soapTagData];
		recordThisTag2 = FALSE;
	}
}

@end
