//
//  BinCodeSearch.h
//  EaseReco
//
//  Created by wangchen on 4/3/15.
//  Copyright (c) 2015 wangchen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BinCodeSearch : NSObject

+(NSString*)getBankNameByBin:(char*)numbers count:(int)nCount;

@end
