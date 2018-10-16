//
//  ProjectTests.m
//  ProjectTests
//
//  Created by 令达 on 2018/4/9.
//  Copyright © 2018年 令达. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LDLoginModel.h"
#import "LDDBTool+Login.h"

@interface ProjectTests : XCTestCase

@end

@implementation ProjectTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)testLDDBTool {
    [LDDBTool clearnLoginModel];
    LDLoginModel * model = [LDLoginModel new];
    model.name = @"我不做大哥好多年";
    model.image = [UIImage imageNamed:@"second_selected.png"];
    model.models = @[[LDLoginModel new],[LDLoginModel new]];
    [LDDBTool saveLoginModel:model];
    LDLoginModel * localModel = [LDDBTool getLoginModels].lastObject;
    NSAssert(localModel.image != nil, @"UIImage的存取失败");
    NSAssert(localModel.models.firstObject != nil, @"模型数组的存取失败");
    [LDDBTool update:LDLoginModel.class name:@"我就是大哥" conditionName:@"我不做大哥好多年"];
    localModel = [LDDBTool getLoginModels].lastObject;
    NSAssert([localModel.name isEqualToString:@"我就是大哥"], @"模型修改name失败");
    
}

@end
