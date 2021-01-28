//
//  traditional_oc.h
//  InterOperateCwithSwift
//
//  Created by Bq Lin on 2021/1/27.
//  Copyright © 2021 Bq. All rights reserved.
//

#import <Foundation/Foundation.h>

const int global_ten;

// 基本函数
NS_INLINE int
add(int m, int n) {
    return m + n;
}

// 不固定参数个数函数

// sum函数在Swift中是无法调用的，只能调用vsum函数
NS_INLINE int
vsum(int count, va_list numbers) {
    int sum = 0;
    for (int i = 0; i < count; i++) {
        sum += va_arg(numbers, int);
    }
    return sum;
}
NS_INLINE int
sum(int count, ...) {
    va_list ap;
    int sum = 0;
    va_start(ap, count);
    vsum(count, ap);
    va_end(ap);
    return sum;
}

// 结构体
typedef struct {
    double x;
    double y;
} Location;
// 给结构体添加方法
Location moveX(Location location, double delta) CF_SWIFT_NAME(Location.moveX(self:delta:));
Location createWithXY(double xy) CF_SWIFT_NAME(Location.init(xy:));

// 甚至可以加入属性
Location getOrigin(void) CF_SWIFT_NAME(getter:Location.origin());
void setOrigin(Location newOirgin) CF_SWIFT_NAME(setter:Location.origin(newOrigin:));

// 联合体
typedef union {
    char character;
    int code;
} ASCII;

// 包含匿名结构体、联合体的结构体
typedef struct {
    union {
        char mode;
        int series;
    };
    struct {
        double pricing;
        bool isAvailable;
    } info;
} Car;

// 原始的枚举
typedef enum {
    RED, YELLOW, GREEN
} TrafficLightColor0;

// 这样声明的枚举会直接生成Swift枚举
typedef NS_ENUM(int, TrafficLightColor1) {
    RED1,
    YELLOW1,
    GREEN1
};

// 模拟一个Swift的枚举
typedef NSString * TrafficLightColor NS_STRING_ENUM;
TrafficLightColor const TrafficLightColorRed;
TrafficLightColor const TrafficLightColorYellow;
TrafficLightColor const TrafficLightColorGreen;

// 更便于扩展的枚举
typedef int Shape NS_EXTENSIBLE_STRING_ENUM;
Shape const ShapeCircle = 1;
Shape const ShapeTriangle = 2;
Shape const ShapeSquare = 3;

@interface traditional_oc : NSObject

@end
