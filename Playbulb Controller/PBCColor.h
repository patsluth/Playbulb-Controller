//
//  PBCColor.h
//  Playbulb Controller
//
//  Created by Pat Sluth on 2016-10-31.
//  Copyright © 2016 Pat Sluth. All rights reserved.
//

@import Foundation;





@interface PBCColor : NSObject

struct PlaybulbColor
{
    uint8_t white;
    uint8_t red;
    uint8_t green;
    uint8_t blue;
};
typedef struct PlaybulbColor PlaybulbColor;

+ (PlaybulbColor)playbulbColorFromNSData:(NSData *)data;
+ (NSData *)playbulbColorToNSData:(PlaybulbColor)color;

@end




