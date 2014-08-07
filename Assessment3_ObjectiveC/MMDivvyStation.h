//
//  MMDivvyStation.h
//  Assessment3_ObjectiveC
//
//  Created by Kevin McQuown on 8/5/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface MMDivvyStation : NSObject

- (id)initWithDictionary:(NSDictionary *)dictionary;

@property NSDictionary *divvyLocation;
// Your properties and methods here


@end
