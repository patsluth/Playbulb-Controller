//
//  WatchSessionManager.m
//  Playbulb Controller
//
//  Created by Pat Sluth on 2016-11-03.
//  Copyright © 2016 Pat Sluth. All rights reserved.
//

#import "WatchSessionManager.h"





@interface WatchSessionManager ()

@property (strong, nonatomic) WCSession *session;

@end





@implementation WatchSessionManager

#pragma mark - WatchSessionManager

static WatchSessionManager *_sharedInstance = nil;

+ (instancetype)sharedInstance
{
    @synchronized(self) {
        if (_sharedInstance == nil) {
            _sharedInstance = [[self alloc] init];
        }
    }
    
    return _sharedInstance;
}

- (id)init
{
    if (self == [super init] && !_sharedInstance) {
        self.session = [WCSession defaultSession];
    }
    
    return self;
}

- (void)startSession
{
    self.session.delegate = self;
    [self.session activateSession];
}

#pragma mark - WCSessionDelegate

- (void)session:(WCSession *)session didReceiveMessage:(NSDictionary<NSString *,id> *)message replyHandler:(void (^)(NSDictionary<NSString *,id> * _Nonnull))replyHandler
{
    
}

@end




