//
//  AmbianceBackend.m
//  AmbianceClient
//
//  Created by ∞ on 05/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AmbianceBackend.h"
#import "SBJSON/JSON.h"

@interface AmbianceBackend ()

@property(retain) NSURL* URL;
@property(copy) NSString* clientIdentifier;

@property(retain) NSMutableDictionary* ifSucceedsBlocks;
@property(retain) NSMutableSet* runningURLConnections;

@property(retain) NSMutableDictionary* responses, * data;

- (void) fetchURLRequest:(NSURLRequest*) req ifSucceeds:(AmbianceResponse) done;

@end


@implementation AmbianceBackend

@synthesize URL, clientIdentifier;
@synthesize runningURLConnections, ifSucceedsBlocks;
@synthesize data, responses;

- (id)initWithURL:(NSURL*) url clientIdentifier:(NSString*) clientId;
{
    self = [super init];
    if (self) {
        self.URL = url;
        self.clientIdentifier = clientId;
        self.ifSucceedsBlocks = [NSMutableDictionary new];
        self.runningURLConnections = [NSMutableSet new];
        
        self.data = [NSMutableDictionary new];
        self.responses = [NSMutableDictionary new];
    }
    
    return self;
}

- (void)dealloc
{
    [self.runningURLConnections makeObjectsPerformSelector:@selector(cancel)];
    self.runningURLConnections = nil;
    
    self.URL = nil;
    self.clientIdentifier = nil;
    self.ifSucceedsBlocks = nil;
    self.data = nil;
    self.responses = nil;
    
    [super dealloc];
}


- (void) fetchURLRequest:(NSURLRequest*) req ifSucceeds:(AmbianceResponse) done;
{
    NSURLConnection* con = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    [self.runningURLConnections addObject:con];
	
	if (done)
		[self.ifSucceedsBlocks setObject:[[done copy] autorelease] forKey:[NSValue valueWithNonretainedObject:con]];
}

- (void) postState:(NSDictionary*) state toServiceWithIdentifier:(NSString*) ident ifSucceeds:(AmbianceResponse) done;
{
    NSString* str = [state JSONRepresentation];
    NSData* JSONData = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString* url = [NSString stringWithFormat:@"services/%@", ident];
    
    NSMutableURLRequest* req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url relativeToURL:self.URL]];

    [req setHTTPMethod:@"POST"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setHTTPBody:JSONData];
    
    [self fetchURLRequest:req ifSucceeds:done];
}

- (void) fetchStateOfServiceWithIdentifier:(NSString*) ident ifSucceeds:(AmbianceResponse) done;
{
    NSString* url = [NSString stringWithFormat:@"services/%@", ident];
    
    [self fetchURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url relativeToURL:self.URL]] ifSucceeds:done];
}

- (void) takeOverServiceWithIdentifier:(NSString*) ident ifSucceeds:(AmbianceResponse) done;
{
    NSString* url = [NSString stringWithFormat:@"services/%@/takeover", ident];
    
    NSDictionary* request = [NSDictionary dictionaryWithObjectsAndKeys:
                             self.clientIdentifier, @"takingOverClient",
                             nil];
    
    NSMutableURLRequest* req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url relativeToURL:self.URL]];
    
    [req setHTTPMethod:@"POST"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setHTTPBody:[[request JSONRepresentation] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [self fetchURLRequest:req ifSucceeds:done];
}

- (void)connection:(NSURLConnection *) con didFailWithError:(NSError *)error;
{
    [self.runningURLConnections removeObject:con];
    [self.ifSucceedsBlocks removeObjectForKey:[NSValue valueWithNonretainedObject:con]];    
}

- (void)connectionDidFinishLoading:(NSURLConnection *) con;
{
    NSValue* key = [NSValue valueWithNonretainedObject:con];
    AmbianceResponse done = [self.ifSucceedsBlocks objectForKey:key];
    
    NSHTTPURLResponse* resp = [self.responses objectForKey:key];
    
    if (done && resp && [resp statusCode] <= 400)
        done(resp, [self.data objectForKey:key]);
    
    [self.ifSucceedsBlocks removeObjectForKey:key];
    [self.runningURLConnections removeObject:con];
    [self.responses removeObjectForKey:key];
    [self.data removeObjectForKey:key];
}

- (void)connection:(NSURLConnection *) con didReceiveResponse:(NSURLResponse *)response;
{
    NSValue* key = [NSValue valueWithNonretainedObject:con];
    
    [self.responses setObject:response forKey:key];
    [self.data setObject:[NSMutableData data] forKey:key];
}

- (void)connection:(NSURLConnection *) con didReceiveData:(NSData *)newData;
{
    NSValue* key = [NSValue valueWithNonretainedObject:con];
    [[self.data objectForKey:key] appendData:newData];
}

@end
