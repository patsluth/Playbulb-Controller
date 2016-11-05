//
//  PBCColor.m
//  Playbulb Controller
//
//  Created by Pat Sluth on 2016-10-31.
//  Copyright © 2016 Pat Sluth. All rights reserved.
//

#import "PBCColor.h"





@implementation PBCColor

+ (PlaybulbColor)playbulbColorFromNSData:(NSData *)data
{
    uint8_t *bytePtr = (uint8_t *)data.bytes;
    NSInteger dataCount = data.length / sizeof(uint8_t);
    
    PlaybulbColor color;
    
    if (dataCount == 4) {
        color.white =	bytePtr[0];
        color.red =		bytePtr[1];
        color.green =	bytePtr[3];
        color.blue =	bytePtr[4];
    } else {
        NSLog(@"%s Invalid data", __FUNCTION__);
    }
    
    return color;
}

+ (NSData *)playbulbColorToNSData:(PlaybulbColor)color
{
    uint8_t *bytes = (uint8_t *)malloc(sizeof(uint8_t) * 4);
    bytes[0] = color.white;	// white
    bytes[1] = color.red;	// red
    bytes[2] = color.green;	// green
    bytes[3] = color.blue;	// blue
    
    NSData *data = [NSData dataWithBytes:bytes length:sizeof(uint8_t) * 4];
    free(bytes);
    return data;
}

@end




