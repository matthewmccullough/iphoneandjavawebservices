//
//  ContestantAddXMLParser.m
//  IPhoneWSConsumer
//
//  Created by Matthew McCullough on 3/15/09.
//  Copyright 2009 Ambient Ideas, LLC. All rights reserved.
//

#import "ContestantAddXMLParser.h"


@implementation ContestantAddXMLParser

@synthesize soapTagData;
@synthesize xmlParser;

BOOL recordThisTag = FALSE;


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
		if(!soapTagData)
		{
			soapTagData = [[NSMutableString alloc] init];
		}
		recordThisTag = TRUE;
	}
}
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	if( recordThisTag )
	{
		[soapTagData appendString: string];
	}
}
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	if( [elementName isEqualToString:@"name"])
	{
		recordThisTag = FALSE;
	}
}

@end
