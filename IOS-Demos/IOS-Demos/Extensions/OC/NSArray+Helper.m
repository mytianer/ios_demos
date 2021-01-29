//
//  NSArray+Sort.m
//  iKeep Cloud
//
//  Created by hs on 2018/8/23.
//  Copyright © 2018年 hs. All rights reserved.
//

#import "NSArray+Helper.h"

@implementation NSArray (Helper)

- (NSArray *)distinctArr {
    NSOrderedSet *set = [NSOrderedSet orderedSetWithArray:self];
    return set.array;
}

- (NSArray *)sortBy:(BOOL(^)(id left, id right))handler {
    if (!handler || !self) return self;
    
    NSArray * reverseArr = self.reverseObjectEnumerator.allObjects;
    NSMutableArray *arr = [NSMutableArray arrayWithArray:reverseArr];
    for (int i = 0; i <arr.count; ++i) {
        BOOL flag = false;
        for (int j = (int)arr.count-1; j >i; --j) {
            if (handler(arr[j-1], arr[j])) {
                flag = true;
                [arr exchangeObjectAtIndex:j withObjectAtIndex:j-1];
            }
        }
        if (!flag) {
            break;
        }
    }
    return arr.reverseObjectEnumerator.allObjects;
}

- (NSArray *)map:(id(^)(id element))handler {
    if (!handler || !self) return self;
    
    NSMutableArray *arr = NSMutableArray.array;
    for (id obj in self) {
        id new = handler(obj);
        [arr addObject:new];
    }
    return arr.copy;
}

- (NSArray *)filter:(BOOL(^)(id element))handler {
    if (!handler || !self) return self;
        
    NSMutableArray *arr = NSMutableArray.array;
    for (id obj in self) {
        if (handler(obj)) {
            [arr addObject:obj];
        }
    }
    return arr.copy;
}

- (NSArray *)prefix:(NSInteger)count {
    if (count <= 0) {
        return [NSArray array];
    }else if (self.count >= count) {
        return [self subarrayWithRange:NSMakeRange(0, count)];
    }else {
        return self;
    }
}

- (NSArray *)suffix:(NSInteger)count {
    if (count <= 0) {
        return [NSArray array];
    }else if (self.count >= count) {
        return [self subarrayWithRange:NSMakeRange(self.count - count, count)];
    }else {
        return self;
    }
}

@end
