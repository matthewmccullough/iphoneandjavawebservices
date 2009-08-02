// Implementation for the contestant XML parser.
// Called when a new contestant is added from the phone to the web service.
// The web service responds with the contestant name back, in case any
// normalization and cleanup occurrs on the web service end of the contestant processing.
//
//  Created by Matthew McCullough on 3/15/09.
//  Copyright 2009 Ambient Ideas, LLC. All rights reserved.
//

#import "ContestantAddXMLParser.h"


@implementation ContestantAddXMLParser

@synthesize soapTagData;
@synthesize xmlParser;

static BOOL recordThisTag = FALSE;


/**
 * 1) Accept a raw block of web service data
 * 2) Fire up the xml parser
 * 3) Set the delegate for xml parsing methods to this class.
 * 4) start parsing!
 */
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

/**
 * Let go of all the allocated objects.
 */
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

/**
 * Detected the beginning of an element
 */
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *)qName
   attributes: (NSDictionary *)attributeDict
{
	// If this is a name XML tag, store it
	if( [elementName isEqualToString:@"name"])
	{
		if(!soapTagData)
		{
			//Allocate a new string, ready to receive the contents (in the foundCharacters method)
			soapTagData = [[NSMutableString alloc] init];
		}
		recordThisTag = TRUE;
	}
}

/**
 * We've received the contents of the XML tag (the name).
 */
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	if( recordThisTag )
	{
		//Store the contents of the tag (the added contestant's name) into the soapTagData
		[soapTagData appendString: string];
	}
}

/**
 * When
 */
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	if( [elementName isEqualToString:@"name"])
	{
		recordThisTag = FALSE;
	}
}

@end
