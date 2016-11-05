//
//  PBCPeripheralManager.m
//  Playbulb Controller
//
//  Created by Pat Sluth on 2016-11-03.
//  Copyright © 2016 Pat Sluth. All rights reserved.
//

#import "PBCPeripheralManager.h"

@import WatchConnectivity;

#import "CBPeripheral+SW.h"

#import "PBCColor.h"
#import "PBCColorSelectionViewController.h"

#import <objc/runtime.h>





@interface PBCPeripheralManager () <CBCentralManagerDelegate, CBPeripheralDelegate>

@property (strong, nonatomic) NSMutableArray<PBPeriperalManagerDelegate> *delegates;

@property (strong, nonatomic) CBCentralManager *centralManager;

@property (strong, nonatomic, readwrite) NSMutableArray<CBPeripheral *> *discoveredPeripherals;
@property (strong, nonatomic, readwrite) NSMutableArray<CBPeripheral *> *playbulbPeripherals;

@end





@implementation PBCPeripheralManager

#pragma mark - PBCPeripheralManager

static PBCPeripheralManager *_sharedInstance = nil;

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
        self.delegates = [NSMutableArray new];
        self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];
        
        self.discoveredPeripherals = [NSMutableArray new];
        self.playbulbPeripherals = [NSMutableArray new];
    }
    
    return self;
}

+ (void)addDelegate:(PBPeriperalManagerDelegate)delegate
{
    if (![[PBCPeripheralManager sharedInstance].delegates containsObject:delegate]) {
        [[PBCPeripheralManager sharedInstance].delegates addObject:delegate];
    }
}

+ (void)removeDelegate:(PBPeriperalManagerDelegate)delegate
{
    if ([[PBCPeripheralManager sharedInstance].delegates containsObject:delegate]) {
        [[PBCPeripheralManager sharedInstance].delegates removeObject:delegate];
    }
}

+ (void)connectPeripheral:(CBPeripheral *)peripheral options:(NSDictionary<NSString *,id> *)options
{
    NSLog(@"Connecting to peripheral:[%@]", peripheral.name);
    
    [[PBCPeripheralManager sharedInstance].centralManager connectPeripheral:peripheral options:options];
}

+ (void)cancelPeripheralConnection:(CBPeripheral *)peripheral
{
    NSLog(@"Disconnecting peripheral:[%@]", peripheral.name);
    
    [[PBCPeripheralManager sharedInstance].centralManager cancelPeripheralConnection:peripheral];
}

+ (NSArray<CBPeripheral *> *)discoveredPeripherals
{
    return [PBCPeripheralManager sharedInstance].discoveredPeripherals.copy;
}

+ (NSArray<CBPeripheral *> *)playbulbPeripherals
{
    return [PBCPeripheralManager sharedInstance].playbulbPeripherals.copy;
}

#pragma mark - CBCentralManagerDelegate

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    NSLog(@"%s %@", __FUNCTION__, @(central.state));
    
    if (central.state == CBManagerStatePoweredOn) {
        [self.centralManager scanForPeripheralsWithServices:nil options:nil];
    }
    
    for (PBPeriperalManagerDelegate delegate in self.delegates) {
        if ([delegate respondsToSelector:@selector(centralManagerDidUpdateState:)]) {
            [delegate centralManagerDidUpdateState:central];
        }
    }
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"%s", __FUNCTION__);
    
    peripheral.delegate = self;
    [peripheral discoverServices:nil];
    
    for (PBPeriperalManagerDelegate delegate in self.delegates) {
        if ([delegate respondsToSelector:@selector(centralManager:didConnectPeripheral:)]) {
            [delegate centralManager:central didConnectPeripheral:peripheral];
        }
    }
    
    
    
    
    
    
    
    
    if ([WCSession defaultSession].isReachable) {
        NSLog(@"IS PAIRED");
        
        [[WCSession defaultSession] sendMessage:@{ @"a" : peripheral.name }
                                   replyHandler:^(NSDictionary<NSString *,id> * _Nonnull replyMessage) {
                                       NSLog(@"replyHandler %@", replyMessage);
                                   }
                                   errorHandler:^(NSError * _Nonnull error) {
                                       NSLog(@"errorHandler %@", error);
                                   }];
    }
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"%s", __FUNCTION__);
    
    for (PBPeriperalManagerDelegate delegate in self.delegates) {
        if ([delegate respondsToSelector:@selector(centralManager:didDisconnectPeripheral:error:)]) {
            [delegate centralManager:central didDisconnectPeripheral:peripheral error:error];
        }
    }
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"%s", __FUNCTION__);
    
    for (PBPeriperalManagerDelegate delegate in self.delegates) {
        if ([delegate respondsToSelector:@selector(centralManager:didFailToConnectPeripheral:error:)]) {
            [delegate centralManager:central didFailToConnectPeripheral:peripheral error:error];
        }
    }
}

- (void)centralManager:(CBCentralManager *)central
 didDiscoverPeripheral:(CBPeripheral *)peripheral
     advertisementData:(NSDictionary *)advertisementData
                  RSSI:(NSNumber *)RSSI
{
    if (![self.discoveredPeripherals containsObject:peripheral]) {
        
        NSLog(@"%s", __FUNCTION__);
        NSLog(@"%@", peripheral);
        
        [self.discoveredPeripherals addObject:peripheral];
        
        if (![self.playbulbPeripherals containsObject:peripheral]) {
            
            NSData *manufacturerData = [advertisementData objectForKey:@"kCBAdvDataManufacturerData"];
            NSString *manufacturer = [[NSString alloc] initWithData:manufacturerData encoding:NSUTF8StringEncoding];
            
            if ([manufacturer localizedCaseInsensitiveCompare:MIPOW_PLAYBULB_MANUFACTURER] == NSOrderedSame) {
                [self.playbulbPeripherals addObject:peripheral];
            }
        }
    }
    
    for (PBPeriperalManagerDelegate delegate in self.delegates) {
        if ([delegate respondsToSelector:@selector(centralManager:didDiscoverPeripheral:advertisementData:RSSI:)]) {
            [delegate centralManager:central didDiscoverPeripheral:peripheral advertisementData:advertisementData RSSI:RSSI];
        }
    }
}

#pragma mark - CBPeripheralDelegate

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    NSLog(@"%s", __FUNCTION__);
    
    for (CBService *service in peripheral.services) {
        NSLog(@"service: %@", service.UUID);
        [peripheral discoverCharacteristics:nil forService:service];
    }
    
    for (PBPeriperalManagerDelegate delegate in self.delegates) {
        if ([delegate respondsToSelector:@selector(peripheral:didDiscoverServices:)]) {
            [delegate peripheral:peripheral didDiscoverServices:error];
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    NSLog(@"%s", __FUNCTION__);
    
    for (CBCharacteristic *characteristic in service.characteristics) {
        NSLog(@"characteristic: %@", characteristic.UUID);
        
        if ([characteristic.UUID isEqual:MIPOW_PLAYBULB_COLOR_CBUUID]) {
            [peripheral readValueForCharacteristic:characteristic];
        } else if ([characteristic.UUID isEqual:MIPOW_PLAYBULB_MANUFACTURER_CBUUID]) {
            [peripheral readValueForCharacteristic:characteristic];
        }
    }
    
    for (PBPeriperalManagerDelegate delegate in self.delegates) {
        if ([delegate respondsToSelector:@selector(peripheral:didDiscoverCharacteristicsForService:error:)]) {
            [delegate peripheral:peripheral didDiscoverCharacteristicsForService:service error:error];
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSLog(@"%s", __FUNCTION__);
    
    if ([characteristic.UUID isEqual:MIPOW_PLAYBULB_COLOR_CBUUID]) {
        
        objc_removeAssociatedObjects(peripheral);
        objc_setAssociatedObject(peripheral, COLOR_CHARACTERISTIC_ASSOCIATED_OBJECT_KEY, characteristic, OBJC_ASSOCIATION_ASSIGN);
        //[self getColor:characteristic peripheral:peripheral error:error];
        
    } else if ([characteristic.UUID isEqual:MIPOW_PLAYBULB_MANUFACTURER_CBUUID]) {
        
        NSString *manufacturer = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
        
        if ([manufacturer localizedCaseInsensitiveCompare:@"Mipow Limited"] == NSOrderedSame) {
            [self.playbulbPeripherals addObject:peripheral];
        } else {
            [self.centralManager cancelPeripheralConnection:peripheral];
        }
        
    }
    
    for (PBPeriperalManagerDelegate delegate in self.delegates) {
        if ([delegate respondsToSelector:@selector(peripheral:didUpdateValueForCharacteristic:error:)]) {
            [delegate peripheral:peripheral didUpdateValueForCharacteristic:characteristic error:error];
        }
    }
}

@end




