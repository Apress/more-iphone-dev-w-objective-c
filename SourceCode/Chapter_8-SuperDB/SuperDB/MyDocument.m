//
//  MyDocument.m
//  SuperDB
//
//  Created by Jayant Varma on 15/03/2015.
//  Copyright (c) 2015 OZ Apps. All rights reserved.
//

#import "MyDocument.h"

@implementation MyDocument

-(BOOL)loadFromContents:(id)contents ofType:(NSString *)typeName error:(NSError *__autoreleasing *)outError {
    if ([contents length] > 0) {
        self.text = [[NSString alloc] initWithData:(NSData *)contents encoding:NSUTF8StringEncoding];
    } else {
        self.text = @"";
    }
    
    //Update the view here
    
    return YES;
}

-(id) contentsForType:(NSString *)typeName error:(NSError *__autoreleasing *)outError {
    if(!self.text) {
        self.text = @"";
    }
    
    NSData *data = [self.text dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
    return data;
}

-(void) processFiles:(NSNotification *) aNotification {
    NSMutableArray *files = [[NSMutableArray alloc]init];
    
    //disable query during processing
    [self.query disableUpdates];
    
    NSArray *queryResults = [self.query results];
    
    for(NSMetadataItem *result in queryResults) {
        NSURL *fileURL = [result valueForAttribute:NSMetadataItemURLKey];
        NSNumber *aBool = nil;
        
        //exclude hidden files
        [fileURL getResourceValue:&aBool forKey:NSURLIsHiddenKey error:nil];
        if(aBool && ![aBool boolValue])
            [files addObject:fileURL];
    }
    
    //do something with the files in the array
    
    
    //re-enable the query
    [self.query enableUpdates];
}


@end
