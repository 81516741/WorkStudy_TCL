//
//  Mediator.m
//  MainArch_Example
//
//  Created by 令达 on 2018/3/26.
//  Copyright © 2018年 81516741@qq.com. All rights reserved.
//

#import "Mediator.h"
#import <objc/runtime.h>
#import "RxSwiftStudy-Swift.h"

@interface Mediator ()
    
@property (nonatomic, strong) NSMutableDictionary *cachedTarget;
    
@end

@implementation Mediator
#pragma mark - public methods
+ (instancetype)sharedInstance
    {
        static Mediator *mediator;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            mediator = [[Mediator alloc] init];
        });
        return mediator;
    }
    
    /*
     scheme://[target]/[action]?[params]
     
     url sample:
     aaa://targetA/actionB?id=1234
     */
    
- (id)performActionWithUrl:(NSURL *)url completion:(void (^)(NSDictionary *))completion
    {
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        NSString *urlString = [url query];
        for (NSString *param in [urlString componentsSeparatedByString:@"&"]) {
            NSArray *elts = [param componentsSeparatedByString:@"="];
            if([elts count] < 2) continue;
            [params setObject:[elts lastObject] forKey:[elts firstObject]];
        }
        
        // 这里这么写主要是出于安全考虑，防止黑客通过远程方式调用本地模块。这里的做法足以应对绝大多数场景，如果要求更加严苛，也可以做更加复杂的安全逻辑。
        NSString *actionName = [url.path stringByReplacingOccurrencesOfString:@"/" withString:@""];
        if ([actionName hasPrefix:@"native"]) {
            return @(NO);
        }
        
        // 这个demo针对URL的路由处理非常简单，就只是取对应的target名字和method名字，但这已经足以应对绝大部份需求。如果需要拓展，可以在这个方法调用之前加入完整的路由逻辑
        id result = [self performTarget:url.host action:actionName params:params shouldCacheTarget:NO];
        if (completion) {
            if (result) {
                completion(@{@"result":result});
            } else {
                completion(nil);
            }
        }
        return result;
    }
    
- (id)performTarget:(NSString *)targetName action:(NSString *)actionName params:(NSDictionary *)params shouldCacheTarget:(BOOL)shouldCacheTarget
    {
        //1、获取目标对象
        Class targetClass;
        NSString *targetClassString = [NSString stringWithFormat:@"Target_%@", targetName];
        NSObject *target = self.cachedTarget[targetClassString];
        if (target == nil) {
            targetClass = NSClassFromString(targetClassString);
            target = [[targetClass alloc] init];
            if (target == nil) {
                //Swift
                NSString * executableFile = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleExecutableKey];
                targetClassString = [NSString stringWithFormat:@"%@.%@",executableFile,targetClassString];
                targetClass = NSClassFromString(targetClassString);
                target = [[targetClass alloc] init];
            }
        }
        //2、获取目标对象的方法并执行
        SEL action = NSSelectorFromString([NSString stringWithFormat:@"Action_%@:", actionName]);
        SEL actionSwift = NSSelectorFromString( [NSString stringWithFormat:@"Action_%@WithParams:", actionName]);
        if (target == nil) {
            //无法创建指定对象
            return nil;
        }
        
        if (shouldCacheTarget) {
            self.cachedTarget[targetClassString] = target;
        }
        
        if ([target respondsToSelector:action]) {
            return [self safePerformAction:action target:target params:params];
        } else {
            if ([target respondsToSelector:actionSwift]) {
                //Swift
                return [self safePerformAction:actionSwift target:target params:params];
            } else {
                //没有找到目标方法
                action = NSSelectorFromString(@"noMethod:");
                actionSwift = NSSelectorFromString(@"noMethodWithParams:");
                if ([target respondsToSelector:action]) {
                    return [self safePerformAction:action target:target params:params];
                }else if ([target respondsToSelector:actionSwift]) {
                    return [self safePerformAction:actionSwift target:target params:params];
                } else {
                    // noMethod:  都没有
                    [self.cachedTarget removeObjectForKey:targetClassString];
                    return nil;
                }
            }
        }
    }
    
- (void)releaseCachedTargetWithTargetName:(NSString *)targetName
    {
        //移除oc的
        NSString *targetClassString = [NSString stringWithFormat:@"Target_%@", targetName];
        [self.cachedTarget removeObjectForKey:targetClassString];
        //移除swift的
        NSString * executableFile = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleExecutableKey];
        targetClassString = [NSString stringWithFormat:@"%@.%@",executableFile,targetClassString];
        [self.cachedTarget removeObjectForKey:targetClassString];
    }
    
#pragma mark - private methods
- (id)safePerformAction:(SEL)action target:(NSObject *)target params:(NSDictionary *)params
    {
        NSMethodSignature* methodSig = [target methodSignatureForSelector:action];
        if(methodSig == nil) {
            return nil;
        }
        const char* retType = [methodSig methodReturnType];
        
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&params atIndex:2];
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        //void 也可以用 @encode(void) 获取 "v"
        if (strcmp(retType, "v") == 0) {
            return nil;
        }
        //bool  char short  int  long    long long
        if (strcmp(retType, "B") == 0 ||strcmp(retType, "c") == 0 ||strcmp(retType, "s") == 0 ||strcmp(retType, "i") == 0 ||strcmp(retType, "l") == 0 ||strcmp(retType, "q") == 0 ) {
            long long result = 0;
            [invocation getReturnValue:&result];
            return @(result);
        }
        
        //float  double
        if (strcmp(retType, "f") == 0 ||strcmp(retType, "d") == 0 ) {
            double result = 0.0;
            [invocation getReturnValue:&result];
            return @(result);
        }
        
        //NSObject
        if (strcmp(retType, "@") == 0) {
            __autoreleasing NSObject * result=nil;
            [invocation getReturnValue:&result];
            return result;
        }
        return nil;
    }
    
#pragma mark - getters and setters
- (NSMutableDictionary *)cachedTarget
    {
        if (_cachedTarget == nil) {
            _cachedTarget = [[NSMutableDictionary alloc] init];
        }
        return _cachedTarget;
    }


@end
