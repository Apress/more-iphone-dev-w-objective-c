//
//  DebugMe.h
//  DebugTest
//
//  Created by Jayant Varma on 28/11/2014.
//  Copyright (c) 2014 OZ Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DebugMe : NSObject
@property(nonatomic, strong) NSString *string;

-(BOOL) isTrue;
-(BOOL) isFalse;
-(NSString *)helloWorld;
@end
