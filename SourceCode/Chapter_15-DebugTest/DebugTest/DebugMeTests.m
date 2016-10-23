//
//  DebugMeTests.m
//  DebugTest
//
//  Created by Jayant Varma on 28/11/2014.
//  Copyright (c) 2014 OZ Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "DebugMe.h"

@interface DebugMeTests : XCTestCase
@property (nonatomic, strong) DebugMe *debugMe;
@end

@implementation DebugMeTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    self.debugMe = [[DebugMe alloc] init];
}

- (void)tearDown {
    self.debugMe = nil;
    
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void) testDebugMeHasStringProperty{
    XCTAssertTrue([self.debugMe respondsToSelector:@selector(string)],@"expected DebugMe to have 'string' selector");
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

 -(void) testDebugMeIsTrue {
    BOOL result = [self.debugMe isTrue];
     XCTAssertTrue(result,@"Expected DebugMe to be true, got %hhd", result);
 }


-(void) testDebugMeIsFalse {
    BOOL result = [self.debugMe isFalse];
    XCTAssertFalse(result,@"Expected DebugMe to be false, got %hhd", result);
}

-(void)testDebugMeHelloWorld {
    NSString * result = [self.debugMe helloWorld];
    XCTAssertEqual(result, @"Hello World!",@"Expected debugMe hello world!, got %@", result);
    
    XCTAssertEqual(@"3", @"3",@"Equal??");
}

@end
