//
//  NSArray+Sort.h
//  iKeep Cloud
//
//  Created by hs on 2018/8/23.
//  Copyright © 2018年 hs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Helper)

- (NSArray *)distinctArr;

- (NSArray *)sortBy:(BOOL(^)(id left, id right))handler;

- (NSArray *)map:(id(^)(id element))handler;

- (NSArray *)filter:(BOOL(^)(id element))handler;

- (NSArray *)prefix:(NSInteger)count;

- (NSArray *)suffix:(NSInteger)count;



@end
