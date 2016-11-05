//
//  ViewController.m
//  Playbulb Controller
//
//  Created by Pat Sluth on 2016-09-30.
//  Copyright © 2016 Pat Sluth. All rights reserved.
//

#import "ViewController.h"

#import "PBCPeripheralManager.h"

#import "PBCColorSelectionViewController.h"





@interface ViewController () <CBCentralManagerDelegate, CBPeripheralDelegate>

@end





@implementation ViewController

#pragma mark - UIViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
    
    [PBCPeripheralManager addDelegate:self];
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(UITableViewCell *)sender
{
    if ([identifier isEqualToString:@"PBCColorSelectionViewControllerSegue"]) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        CBPeripheral *peripheral = [[PBCPeripheralManager discoveredPeripherals] objectAtIndex:indexPath.row];
        
        if (![[PBCPeripheralManager playbulbPeripherals] containsObject:peripheral]) {
            return NO;
        }
        
    }
    
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UITableViewCell *)sender
{
    [super prepareForSegue:segue sender:sender];
    
    try
    //NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    PBCColorSelectionViewController *destinationViewController = (PBCColorSelectionViewController *)segue.destinationViewController;
//    destinationViewController.playbulbPeripheral = [self.discoveredPeripherals objectAtIndex:indexPath.row];
    destinationViewController.playbulbPeripherals = [PBCPeripheralManager playbulbPeripherals];
    catch
    endtry
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CBPeripheral *peripheral = [[PBCPeripheralManager discoveredPeripherals] objectAtIndex:indexPath.row];
    
    if (peripheral.state == CBPeripheralStateConnecting || peripheral.state == CBPeripheralStateConnected) {
        
        //[PBCPeripheralManager cancelPeripheralConnection:peripheral];
        
    } else if (peripheral.state == CBPeripheralStateDisconnected) {
        
        [PBCPeripheralManager connectPeripheral:peripheral options:nil];
        
    }
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







- (void)getColor:(CBCharacteristic *)characteristic peripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
	//PlaybulbColor color = [PBCColor playbulbColorFromNSData:characteristic.value];
	
//	[self.whiteSlider setValue:color.white animated:YES];
//	[self.redSlider setValue:color.red animated:YES];
//	[self.greenSlider setValue:color.green animated:YES];
//	[self.blueSlider setValue:color.blue animated:YES];
	
	
//	
//	
//	[peripheral writeValue:PlaybulbColorToData(color)
//		 forCharacteristic:characteristic
//					  type:CBCharacteristicWriteWithoutResponse];
}

@end




