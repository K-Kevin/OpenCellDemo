//
//  PlistUtil.m
//  CellFoldDemo
//
//  Created by likai on 15/8/11.
//  Copyright (c) 2015年 likai. All rights reserved.
//

#import "PlistUtil.h"

@implementation PlistUtil

+ (NSString*)pListFilePath:(NSString*)plistFileName {
    NSString *filePath = [[NSBundle mainBundle]pathForResource:plistFileName ofType:@"plist"];
    if ([[NSFileManager defaultManager]fileExistsAtPath:filePath]) {
        return filePath;
    }
    return nil;
}

+ (NSDictionary*)dictionaryForPlistFile:(NSString *)plistFileName {
    NSString *filePath = [self pListFilePath:plistFileName];
    if (filePath) {
        return [NSDictionary dictionaryWithContentsOfFile:filePath];
    }
    return nil;
}

+ (NSMutableArray*)arrayForPlistFile:(NSString*)plistFileName {
    NSString *filePath = [self pListFilePath:plistFileName];
    if (filePath) {
        return [NSMutableArray arrayWithContentsOfFile:filePath];
    }
    return nil;
}

@end
