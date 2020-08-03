//
//  NSObject+ZBkeyedArchive.m
//  ZBKit
//
//  Created by NQ UEC on 2017/10/20.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import "NSObject+ZBkeyedArchive.h"
#import <objc/runtime.h>
@implementation NSObject (ZBkeyedArchive)
/*
- (void)encodeWithCoder:(NSCoder *)aCoder{
    unsigned int count;
    Ivar *ivars =class_copyIvarList([self class], &count);
    for (int i = 0; i<count; i++) {
        Ivar ivar = ivars[i];
        const char *name = ivar_getName(ivar);
        NSString *key=[NSString stringWithUTF8String:name];
        [aCoder encodeObject:[self valueForKey:key] forKey:key];
    }
    free(ivars);
}
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wpartial-availability"
#pragma clang diagnostic ignored "-Wobjc-designated-initializers"
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    unsigned int count;
    Ivar *ivars=class_copyIvarList([self class], &count);
    for (int i = 0 ; i<count; i++) {
        Ivar ivar = ivars[i];
        const char *name = ivar_getName(ivar);
        NSString *key=[NSString stringWithUTF8String:name];
        id  value=[aDecoder decodeObjectForKey:key];
        [self setValue:value forKey:key];
    }
    free(ivars);
    return self;
}
 */
@end
