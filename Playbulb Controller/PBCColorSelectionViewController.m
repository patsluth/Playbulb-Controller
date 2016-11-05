//
//  PBCColorSelectionViewController.m
//  Playbulb Controller
//
//  Created by Pat Sluth on 2016-10-31.
//  Copyright © 2016 Pat Sluth. All rights reserved.
//

#import "PBCColorSelectionViewController.h"

#import "CBPeripheral+SW.h"

#import "PBCColor.h"

#import "DTColorPickerImageView.h"

#import <objc/runtime.h>





@interface PBCColorSelectionViewController () <DTColorPickerImageViewDelegate>

@property (strong, nonatomic) IBOutlet UISlider *whiteSlider;
@property (strong, nonatomic) IBOutlet UISlider *redSlider;
@property (strong, nonatomic) IBOutlet UISlider *greenSlider;
@property (strong, nonatomic) IBOutlet UISlider *blueSlider;

@end





@implementation PBCColorSelectionViewController

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
//    CBCharacteristic *colorCharacteristic = [self.playbulbPeripheral characteristicForUUID:MIPOW_PLAYBULB_COLOR_CBUUID];
    PlaybulbColor color = { self.whiteSlider.value, self.redSlider.value, self.greenSlider.value, self.blueSlider.value };
    [self updateSlidersForColor:color animated:YES];
}

- (IBAction)unwind:(UIStoryboardSegue *)segue
{
    [self performSegueWithIdentifier:@"Unwind" sender:self];
}

#pragma mark - PBCColorSelectionViewController

- (void)updateSlidersForColor:(PlaybulbColor)color animated:(BOOL)animated
{
    [self.whiteSlider setValue:color.white animated:animated];
    [self.redSlider setValue:color.red animated:animated];
    [self.greenSlider setValue:color.green animated:animated];
    [self.blueSlider setValue:color.blue animated:animated];
}

- (void)getColor:(CBCharacteristic *)characteristic peripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    //PlaybulbColor color = [PBCColor playbulbColorFromNSData:characteristic.value];
    
    
    //
    //
    //	[peripheral writeValue:PlaybulbColorToData(color)
    //		 forCharacteristic:characteristic
    //					  type:CBCharacteristicWriteWithoutResponse];
}

- (IBAction)sliderValueChanged:(UISlider *)sender
{
    PlaybulbColor playbulbColor = {
        self.whiteSlider.value,
        self.redSlider.value,
        self.blueSlider.value,
        self.greenSlider.value
    };
    
    [self updatePlaybulbColor:playbulbColor];
}

#pragma mark - DTColorPickerImageViewDelegate

- (void)imageView:(DTColorPickerImageView *)imageView didPickColorWithColor:(UIColor *)color
{
    CGFloat red, green, blue;
    [color getRed:&red green:&green blue:&blue alpha:NULL];
    
    // TODO: CGRectMake...
    PlaybulbColor playbulbColor = {
        0,
        red * 255,
        green * 255,
        blue * 255
    };
    
    [self updatePlaybulbColor:playbulbColor];
}

- (void)updatePlaybulbColor:(PlaybulbColor)playbulbColor
{
    for (CBPeripheral *playbulb in self.playbulbPeripherals) {
        if (playbulb.state == CBPeripheralStateConnected &&
            objc_getAssociatedObject(playbulb, COLOR_CHARACTERISTIC_ASSOCIATED_OBJECT_KEY)) {
            
            [playbulb writeValue:[PBCColor playbulbColorToNSData:playbulbColor]
               forCharacteristic:objc_getAssociatedObject(playbulb, COLOR_CHARACTERISTIC_ASSOCIATED_OBJECT_KEY)
                            type:CBCharacteristicWriteWithoutResponse];
        }
    }
}

@end




