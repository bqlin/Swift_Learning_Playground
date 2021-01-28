//
//  traditional_oc.m
//  InterOperateCwithSwift
//
//  Created by Bq Lin on 2021/1/27.
//  Copyright © 2021 Bq. All rights reserved.
//

#import "traditional_oc.h"

const int global_ten = 10;

TrafficLightColor const TrafficLightColorRed = @"Red";
TrafficLightColor const TrafficLightColorYellow = @"Yellow";
TrafficLightColor const TrafficLightColorGreen = @"Green";

Location moveX(Location location, double delta) {
    location.x += delta;
    return location;
}
Location createWithXY(double xy) {
    Location l = {.x = xy, .y = xy};
    return l;
}

static Location origin = { .x = 0, .y = 0 };
Location getOrigin() {
    return origin;
}
void setOrigin(Location newOrigin) {
    origin = newOrigin;
}

@implementation traditional_oc

@end
