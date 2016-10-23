//
//  MyDocument.h
//  SuperDB
//
//  Created by Jayant Varma on 15/03/2015.
//  Copyright (c) 2015 OZ Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyDocument : UIDocument

@property (strong, nonatomic) NSString *text;

@property (strong, nonatomic) NSMetadataQuery *query;

@end
