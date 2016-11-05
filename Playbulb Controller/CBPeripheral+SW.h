//
//  CBPeripheral+SW.h
//  Playbulb Controller
//
//  Created by Pat Sluth on 2016-10-31.
//  Copyright © 2016 Pat Sluth. All rights reserved.
//

@import CoreBluetooth;

#define MIPOW_PLAYBULB_MANUFACTURER @"MIPOW"
#define MIPOW_PLAYBULB_COLOR_CBUUID [CBUUID UUIDWithString:@"fffc"]
#define MIPOW_PLAYBULB_MANUFACTURER_CBUUID [CBUUID UUIDWithString:@"2a29"]

#define COLOR_CHARACTERISTIC_ASSOCIATED_OBJECT_KEY sel_registerName("pbColorCharacteristic")





@interface CBPeripheral(SW)

- (CBCharacteristic *)characteristicForUUID:(CBUUID *)characteristicUUID;

@end




