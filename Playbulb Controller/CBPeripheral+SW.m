//
//  CBPeripheral+SW.m
//  Playbulb Controller
//
//  Created by Pat Sluth on 2016-10-31.
//  Copyright © 2016 Pat Sluth. All rights reserved.
//

#import "CBPeripheral+SW.h"





@implementation CBPeripheral(SW)

- (CBCharacteristic *)characteristicForUUID:(CBUUID *)characteristicUUID
{
    for (CBService *service in self.services) {
        for (CBCharacteristic *characteristic in service.characteristics) {
            if ([characteristic.UUID isEqual:characteristicUUID]) {
                return characteristic;
            }
        }
    }
    
    return nil;
}

@end




