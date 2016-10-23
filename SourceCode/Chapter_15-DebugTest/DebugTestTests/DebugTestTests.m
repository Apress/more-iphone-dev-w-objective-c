//
//  DebugTestTests.m
//  DebugTestTests
//
//  Created by Jayant Varma on 28/11/2014.
//  Copyright (c) 2014 OZ Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

@interface DebugTestTests : XCTestCase

@end

@implementation DebugTestTests

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
    //XCTFail(@"Whoops, an error");
    //XCTAssert(NO, @"Pass");
    
    XCTAssertEqual(@"3", @"3",@"Equal??");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
