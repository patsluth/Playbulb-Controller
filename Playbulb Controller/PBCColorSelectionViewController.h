//
//  PBCColorSelectionViewController.h
//  Playbulb Controller
//
//  Created by Pat Sluth on 2016-10-31.
//  Copyright © 2016 Pat Sluth. All rights reserved.
//

@import UIKit;
@import CoreBluetooth;





@interface PBCColorSelectionViewController : UIViewController

@property (strong, nonatomic) NSArray<CBPeripheral *> *playbulbPeripherals;

@end




