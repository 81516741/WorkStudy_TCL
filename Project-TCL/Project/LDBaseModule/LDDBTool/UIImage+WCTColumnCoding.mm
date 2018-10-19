//
//  UIImage+WCTColumnCoding.m
//  Project
//
//  Created by 令达 on 2018/4/10.
//  Copyright © 2018年 令达. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WCDB/WCDB.h>

@interface UIImage (WCTColumnCoding) <WCTColumnCoding>
@end

@implementation UIImage (WCTColumnCoding)

+ (instancetype)unarchiveWithWCTValue:(NSData *)value
{
    return [UIImage imageWithData:value];
}

- (NSData *)archivedWCTValue
{
    return UIImagePNGRepresentation(self);
}

+ (WCTColumnType)columnTypeForWCDB
{
    return WCTColumnTypeBinary;
}

@end
