
//
//  NSObject+ZBKVO.m
//  ZBKit
//
//  Created by NQ UEC on 2018/9/18.
//  Copyright © 2018年 Suzhibin. All rights reserved.
//

#import "NSObject+ZBKVO.h"
#import <objc/runtime.h>
@implementation NSObject (ZBKVO)

- (void)zb_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(nullable void *)context{
    //1.自定义一个 对象的子类
    NSString *oldClassName=NSStringFromClass(self.class);
    NSString *newClassName=[@"ZBKVO" stringByAppendingString:oldClassName];
    //创建一个类
    Class MyClass= objc_allocateClassPair(self.class, newClassName.UTF8String, 0);
    //注册该类
    objc_registerClassPair(MyClass);
    
    //动态修改
    object_setClass(self, MyClass);
    //添加setName方法 重写父类setName
    //oc方法SEL IMP
    //1类 2方法编号  3方法实现（函数指针） 4方法类型
    class_addMethod(MyClass, @selector(setName:), (IMP)click, "v@:@");
    
}
void click(id self,SEL _cmd,NSString *newName){
    NSLog(@"%@",newName);
}
@end
