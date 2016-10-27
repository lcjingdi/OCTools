//
//  NSObject+EKWRuntime.m
//  OCTools
//
//  Created by jingdi on 2016/10/27.
//  Copyright © 2016年 lcjingdi. All rights reserved.
//

#import "NSObject+EKWRuntime.h"
#import <objc/runtime.h>

@implementation NSObject (EKWRuntime)

+ (void)swizzleClassMethod:(Class)class originSelector:(SEL)originSelector otherSelector:(SEL)otherSelector
{
    Method otherMehtod = class_getClassMethod(class, otherSelector);
    Method originMehtod = class_getClassMethod(class, originSelector);
    // 交换2个方法的实现
    method_exchangeImplementations(otherMehtod, originMehtod);
}

+ (void)swizzleInstanceMethod:(Class)class originSelector:(SEL)originSelector otherSelector:(SEL)otherSelector
{
    Method otherMehtod = class_getInstanceMethod(class, otherSelector);
    Method originMehtod = class_getInstanceMethod(class, originSelector);
    // 交换2个方法的实现
    method_exchangeImplementations(otherMehtod, originMehtod);
}

@end

@implementation NSArray (EKWRuntime)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleInstanceMethod:NSClassFromString(@"__NSArrayI") originSelector:@selector(objectAtIndex:) otherSelector:@selector(ekw_objectAtIndex:)];
    });
}

- (id)ekw_objectAtIndex:(NSInteger)index
{
    if (index < self.count) {
        return [self ekw_objectAtIndex:index];
    } else {
        NSAssert(NO, @"数组越界了。。。。。。。");
        return nil;
    }
}

@end

@implementation NSMutableArray (EKWRuntime)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleInstanceMethod:NSClassFromString(@"__NSArrayM") originSelector:@selector(insertObject:atIndex:) otherSelector:@selector(ekw_insertObject:atIndex:)];
        [self swizzleInstanceMethod:NSClassFromString(@"__NSArrayM") originSelector:@selector(objectAtIndex:) otherSelector:@selector(ekw_objectAtIndex:)];
        [self swizzleInstanceMethod:NSClassFromString(@"__NSArrayM") originSelector:@selector(removeObjectAtIndex:) otherSelector:@selector(ekw_removeObjectAtIndex:)];
    });
}

- (void)ekw_insertObject:(id)anObject atIndex:(NSUInteger)index
{
    if (anObject != nil && index<=self.count) {
        [self ekw_insertObject:anObject atIndex:index];
    }
}

- (id)ekw_objectAtIndex:(NSInteger)index
{
    if (index < self.count) {
        return [self ekw_objectAtIndex:index];
    } else {
        NSAssert(NO, @"数组越界了。。。。。。。");
        return nil;
    }
}

- (void)ekw_removeObjectAtIndex:(NSInteger)index {
    if (index < self.count) {
        [self ekw_removeObjectAtIndex:index];
    } else {
        NSAssert(NO, @"数组越界了");
    }
}

@end

@implementation NSDictionary (EKWRuntime)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleInstanceMethod:NSClassFromString(@"__NSPlaceholderDictionary") originSelector:@selector(initWithObjects:forKeys:count:) otherSelector:@selector(ekw_initWithObjects:forKeys:count:)];
    });
}

- (instancetype)ekw_initWithObjects:(const id  _Nonnull __unsafe_unretained *)objects forKeys:(const id<NSCopying>  _Nonnull __unsafe_unretained *)keys count:(NSUInteger)cnt
{
    for (int i=0; i<cnt; i++) {
        if (objects[i] == nil) {
            return nil;
        }
    }
    return [self ekw_initWithObjects:objects forKeys:keys count:cnt];
}

@end

@implementation NSMutableDictionary (EKWRuntime)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleInstanceMethod:NSClassFromString(@"__NSDictionaryM") originSelector:@selector(setObject:forKey:) otherSelector:@selector(ekw_setObject:forKey:)];
    });
}

- (void)ekw_setObject:(id)anObject forKey:(id<NSCopying>)aKey
{
    if (anObject!=nil) {
        [self ekw_setObject:anObject forKey:aKey];
    } else {
        NSAssert(NO, @"设置了字典的value为nil");
    }
}

@end
