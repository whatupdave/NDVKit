//
//  NSDateFormatter+NDVAdditions.h
//  NDVKit
//
//  Created by Nathan de Vries on 24/08/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDateFormatter (NDVAdditions)


+ (id)unlocalisedFormatter;
+ (id)unlocalisedFormatterWithFormat:(NSString *)dateFormat;


@end
