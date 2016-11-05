//
//  InterfaceController.m
//  Playbulb Controller Watch Extension
//
//  Created by Pat Sluth on 2016-11-03.
//  Copyright © 2016 Pat Sluth. All rights reserved.
//

#import "InterfaceController.h"





@interface InterfaceController()

@end





@implementation InterfaceController

- (void)awakeWithContext:(id)context
{
    [super awakeWithContext:context];

    // Configure interface objects here.
}

- (void)willActivate
{
    [super willActivate];
    
    if ([WCSession defaultSession].isReachable) {
        [[WCSession defaultSession] sendMessage:@{ @"A" : @"B" }
                                   replyHandler:^(NSDictionary<NSString *,id> * _Nonnull replyMessage) {
                                       NSLog(@"replyHandler %@", replyMessage);
                                   } errorHandler:^(NSError * _Nonnull error) {
                                       NSLog(@"errorHandler %@", error);
                                   }];
    }
}

- (void)didDeactivate
{
    [super didDeactivate];
}

@end




