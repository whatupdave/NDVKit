//
//  NSDate+NDVCalendarAdditions.h
//  NDVKit
//
//  Created by Nathan de Vries on 24/08/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDate (NDVCalendarAdditions)


+ (id)dateWithYear:(NSInteger)year;
+ (id)dateWithYear:(NSInteger)year month:(NSInteger)month;
+ (id)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;
+ (id)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour;

- (id)dateByAddingDays:(NSInteger)days months:(NSInteger)months years:(NSInteger)years;

- (NSDateComponents *)gregorianCalendarComponents;

- (NSInteger)era;
- (NSInteger)year;
- (NSInteger)month;
- (NSInteger)day;
- (NSInteger)hour;
- (NSInteger)minute;
- (NSInteger)second;
- (NSInteger)week;
- (NSInteger)weekday;
- (NSInteger)weekdayOrdinal;


@end
