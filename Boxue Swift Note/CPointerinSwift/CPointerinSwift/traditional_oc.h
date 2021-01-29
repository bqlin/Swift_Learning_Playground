//
//  traditional_oc.h
//  CPointerinSwift
//
//  Created by Bq Lin on 2021/1/28.
//  Copyright © 2021 Bq. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_INLINE void
printAddress(const int* p) {
    printf("%016lX\n", (unsigned long)p);
}

NS_INLINE int
doubler(int* p) {
    *p = (*p) * 2;
    return *p;
}

typedef void (* CALLBACK)(void*);
NS_INLINE void
aFuncWithCallback(void* context, CALLBACK callback) {
    sleep(3);
    callback(context);
}

@interface traditional_oc : NSObject

@end

