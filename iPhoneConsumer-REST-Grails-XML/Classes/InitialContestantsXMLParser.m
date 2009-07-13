// The XML parser for the initial bulk load of contestants into
// the UI at application launch time.
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
 * Clean up and dealloc all the parser variables.
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
 * Detect the start of "name" elements, allocate space to store them in.
 */
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *)qName
   attributes: (NSDictionary *)attributeDict
{
	if( [elementName isEqualToString:@"name"])
	{
		//Reserve space for the "name" tag foundCharacters that we will receive next
		soapTagData = [[NSMutableString alloc] init];
		
		//Signal to foundCharacters that we are interested in recording the 
		//data that it will receive.
		recordThisTag2 = TRUE;
	}
}

/**
 * We are in the middle of didStartElement and didEndElement and are receiving data.
 * Is it data we care about?  recordThisTag2 tells us if it is interesting to us or not.
 * Keep in mind that we receive data in chunks, and it isn't guaranteed to be all the data
 * the contents of this tag in just one call.  It could be multiple calls.  Thus, append
 * the data each time it is called until we see a didEndElement for the "name" tag.
 */
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	if( recordThisTag2 )
	{
		//Append the data 
		[soapTagData appendString: string];
	}
}

/**
 * Upon the end of the name element, pass the contestant name back to the view to add to the 
 * picker view wheel.
 */
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	if( [elementName isEqualToString:@"name"])
	{
		//Commented out because it errors out.  How would one log an id?
		//NSLog(@"about to send selector %@ to id %@", @selector(nameFoundSelector), [[NSString alloc] init parentController);
		
		//Dynamically dispatch to the nameFoundSelector (specified at construction time)
		// and pass in the soapTagData
		[parentController performSelector:nameFoundSelector withObject:soapTagData];
		
		//Since we are done with the name tag, we'll say we aren't interested in recording
		//any more data from foundCharacters until we see another name tag in the didStartElement.
		recordThisTag2 = FALSE;
	}
}

@end
