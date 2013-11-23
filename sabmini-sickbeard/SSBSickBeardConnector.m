//
//  SSBSickBeardConnector.m
//
//  Created by Stefan Klein Nulent on 17-12-12.
//  Copyright (c) 2012 Stefan Klein Nulent. All rights reserved.
//

#import "SSBSickBeardConnector.h"
#import "SSBSickBeardResult.h"

@interface SSBSickBeardConnector()

@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSURL *connectionUrl;
@property (nonatomic, strong) NSMutableData *jsonData;
@property (nonatomic, copy) SSBSickBeardConnectorFinishedBlock clb;
@property (nonatomic, copy) SSBSickBeardConnectorFailedBlock clbFailed;

@end

@implementation SSBSickBeardConnector

- (id)initWithURL:(NSURL *)url
{
    self = [super init];
    if (self) {
        self.connectionUrl = url;
    }
    
    return self;
}

- (void)getData:(SSBSickBeardConnectorFinishedBlock)callback onFailure:(SSBSickBeardConnectorFailedBlock)failure
{
    self.clb = callback;
    self.clbFailed = failure;
    NSURLRequest *request = [NSURLRequest requestWithURL:self.connectionUrl];
    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

#pragma mark -
#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (_jsonData) {
        [_jsonData appendData:data];
    }
    else {
        _jsonData = [[NSMutableData alloc] initWithData:data];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    self.clbFailed([[SSBSickBeardResult alloc] initWithAttributes:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"Error connecting to the Sick Beard server!", @"Error connecting to the Sick Beard server message", NO, nil] forKeys:[NSArray arrayWithObjects:@"message", @"result", nil]]]);
    
    self.connection = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    self.connection = nil;
    
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:_jsonData options:kNilOptions error:&error];
    
    if (!error) {
        if ([[json objectForKey:@"result"] isEqualToString:@"success"]) {
            self.clb(json);
        }
        else {
            self.clbFailed([[SSBSickBeardResult alloc] initWithAttributes:json]);
        }
    }
    else {
        self.clbFailed([[SSBSickBeardResult alloc] initWithAttributes:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:error.localizedDescription, @"error", nil] forKeys:[NSArray arrayWithObjects:@"message", @"result", nil]]]);
    }
}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
	return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
	
	[challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
	
	[challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}

@end
