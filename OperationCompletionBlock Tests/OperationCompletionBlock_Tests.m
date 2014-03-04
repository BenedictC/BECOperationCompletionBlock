//
//  OperationCompletionBlock_Tests.m
//  OperationCompletionBlock Tests
//
//  Created by Benedict Cohen on 25/02/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSOperation+EMKCompletionBlock.h"



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



@interface OperationCompletionBlock_Tests : XCTestCase
@end



@implementation OperationCompletionBlock_Tests

- (void)testCompletionBlockIsFired
{
    __block BOOL didRun = NO;
    __block BOOL didComplete = NO;
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        didRun = YES;
    }];

    [operation EMK_setCompletionBlockUsingDispatchQueue:NULL block:^(id operation) {
        didComplete = YES;
    }];

    NSOperationQueue *queue = [NSOperationQueue new];
    [queue addOperation:operation];

    //Fire the run loop so that the operation can execute.
    FIRE_RUNLOOP_UNTIL(^BOOL{
        return didRun && didComplete;
    }, 1);

    XCTAssertTrue(didRun, @"Operation failed to execute.");
    XCTAssertTrue(didComplete, @"Operation failed to complete.");
}



-(void)testRetainCycleIsAvoided {
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{}];
    __block BOOL didComplete = NO;
    [operation EMK_setCompletionBlockUsingDispatchQueue:NULL block:^(NSOperation *operation) {
        didComplete = YES;
    }];

    NSOperationQueue *queue = [NSOperationQueue new];
    [queue addOperation:operation];

    FIRE_RUNLOOP_UNTIL(^BOOL{
        return didComplete;
    }, 1);

    XCTAssertTrue(didComplete, @"Failed to complete operation (therefore subsequent tests are uniformative).");
    XCTAssertTrue(queue.operationCount == 0, @"Operation still enqueued (therefore subsequent tests are uniformative).");

    __weak NSOperation *weakOperation = operation;
    dispatch_async(dispatch_get_main_queue(), ^(void){
        XCTAssertNil(weakOperation, @"Failed to break retain cycle.");
    });
    operation = nil; //Local variables are retained until the method exit. Setting to nil releases them.
    FIRE_RUNLOOP_FOR(.5);
}

@end
