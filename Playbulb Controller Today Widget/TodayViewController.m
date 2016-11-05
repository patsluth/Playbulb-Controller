//
//  TodayViewController.m
//  Playbulb Controller Today Widget
//
//  Created by Pat Sluth on 2016-11-02.
//  Copyright © 2016 Pat Sluth. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>

#import "PBCPeripheralManager.h"







@interface TodayViewController () <NCWidgetProviding, CBCentralManagerDelegate, CBPeripheralDelegate>

@end





@implementation TodayViewController

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [PBCPeripheralManager addDelegate:self];
}

#pragma mark - NCWidgetProviding

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler
{
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData
    
    completionHandler(NCUpdateResultNewData);
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [PBCPeripheralManager discoveredPeripherals].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"PBCCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    
    CBPeripheral *peripheral = [[PBCPeripheralManager discoveredPeripherals] objectAtIndex:indexPath.row];
    
    if ([[PBCPeripheralManager playbulbPeripherals] containsObject:peripheral]) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@\t(PLAYBULB)", peripheral.name];
    } else {
        cell.textLabel.text = peripheral.name;
    }
    
    if (peripheral.state == CBPeripheralStateConnecting) {
        cell.detailTextLabel.text = @"Connecting...";
    } else if (peripheral.state == CBPeripheralStateConnected) {
        cell.detailTextLabel.text = @"Connected";
    } else if (peripheral.state == CBPeripheralStateDisconnecting) {
        cell.detailTextLabel.text = @"Disconnecting";
    } else if (peripheral.state == CBPeripheralStateDisconnected) {
        cell.detailTextLabel.text = @"Disconnected";
    }
    
    return cell;
}

#pragma mark - CBCentralManagerDelegate

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    [self.tableView reloadData];
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    [self.tableView reloadData];
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    [self.tableView reloadData];
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    [self.tableView reloadData];
}

- (void)centralManager:(CBCentralManager *)central
 didDiscoverPeripheral:(CBPeripheral *)peripheral
     advertisementData:(NSDictionary *)advertisementData
                  RSSI:(NSNumber *)RSSI
{
    [self.tableView reloadData];
}

#pragma mark - CBPeripheralDelegate

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    [self.tableView reloadData];
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    [self.tableView reloadData];
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    [self.tableView reloadData];
}

@end




