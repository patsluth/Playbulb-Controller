//
//  PBCPeripheralManager.h
//  Playbulb Controller
//
//  Created by Pat Sluth on 2016-11-03.
//  Copyright © 2016 Pat Sluth. All rights reserved.
//

@import Foundation;
@import CoreBluetooth;

#import "PBCColor.h"

#import "CBPeripheral+SW.h"





@interface PBCPeripheralManager : NSObject

typedef NSObject<CBCentralManagerDelegate, CBPeripheralDelegate> *PBPeriperalManagerDelegate;

+ (void)addDelegate:(PBPeriperalManagerDelegate)delegate;
+ (void)removeDelegate:(PBPeriperalManagerDelegate)delegate;

+ (void)connectPeripheral:(CBPeripheral *)peripheral options:(NSDictionary<NSString *,id> *)options;
+ (void)cancelPeripheralConnection:(CBPeripheral *)peripheral;

+ (NSArray<CBPeripheral *> *)discoveredPeripherals;
+ (NSArray<CBPeripheral *> *)playbulbPeripherals;

@end




