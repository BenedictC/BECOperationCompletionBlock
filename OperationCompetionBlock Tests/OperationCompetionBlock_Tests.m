//
//  OperationCompetionBlock_Tests.m
//  OperationCompetionBlock Tests
//
//  Created by Benedict Cohen on 25/02/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSOperation+EMKCompetionBlock.h"



#pragma mark - async functions
static void FIRE_RUNLOOP_UNTIL(BOOL(^condition)(void), NSTimeInterval relativeTimeout) {
    NSTimeInterval absoluteTimeout = [NSDate timeIntervalSinceReferenceDate] + relativeTimeout;

    while (!condition()) {
        BOOL didTimeout = absoluteTimeout < [NSDate timeIntervalSinceReferenceDate];
        if (didTimeout) return;
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
    }
}



static void FIRE_RUNLOOP_FOR(NSTimeInterval relativeTimeout) {
    NSTimeInterval absoluteTimeout = [NSDate timeIntervalSinceReferenceDate] + relativeTimeout;
    FIRE_RUNLOOP_UNTIL(^BOOL{
        return absoluteTimeout < [NSDate timeIntervalSinceReferenceDate];
    }, relativeTimeout);
}



@interface OperationCompetionBlock_Tests : XCTestCase
@end



@implementation OperationCompetionBlock_Tests

- (void)testCompletionBlock
{
    __block BOOL didRun = NO;
    __block BOOL didComplete = NO;
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        XCTAssertFalse([NSThread isMainThread], @"Not background queue. Following tests pointless.");
        didRun = YES;
    }];

    [operation EMK_setCompletionBlockUsingDispatchQueue:NULL block:^(id operation) {
        XCTAssertTrue([NSThread isMainThread], @"Completion block not executing on correct queue.");
        didComplete = YES;
    }];

    NSOperationQueue *queue = [NSOperationQueue new];
    [queue addOperation:operation];

    //Fire the run loop so that the operation can execute.
    FIRE_RUNLOOP_FOR(1);

    XCTAssertTrue(didRun, @"Operation failed to execute.");
    XCTAssertTrue(didComplete, @"Operation failed to complete.");
}

@end
