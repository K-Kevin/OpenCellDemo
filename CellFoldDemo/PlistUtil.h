//
//  PlistUtil.h
//  CellFoldDemo
//
//  Created by likai on 15/8/11.
//  Copyright (c) 2015年 likai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlistUtil : NSObject

+ (NSString*)pListFilePath:(NSString*)plistFileName;

+ (NSDictionary*)dictionaryForPlistFile:(NSString *)plistFileName;

+ (NSMutableArray*)arrayForPlistFile:(NSString*)plistFileName;

@end
