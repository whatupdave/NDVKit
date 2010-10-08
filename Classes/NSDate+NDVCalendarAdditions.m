//
//  NSDate+NDVCalendarAdditions.m
//  NDVKit
//
//  Created by Nathan de Vries on 24/08/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.
//

#import "NSDate+NDVCalendarAdditions.h"


@implementation NSDate (NDVCalendarAdditions)


+ (id)dateWithYear:(NSInteger)year {
	NSDateComponents* components = [[[NSDateComponents alloc] init] autorelease];
	[components setYear:year];
	NSCalendar* calendar = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];

	return [calendar dateFromComponents:components];
}


+ (id)dateWithYear:(NSInteger)year month:(NSInteger)month {
	NSDateComponents* components = [[[NSDateComponents alloc] init] autorelease];
	[components setYear:year];
  [components setMonth:month];
	NSCalendar* calendar = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];

	return [calendar dateFromComponents:components];
}


+ (id)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day {
	NSDateComponents* components = [[[NSDateComponents alloc] init] autorelease];
	[components setYear:year];
  [components setMonth:month];
  [components setDay:day];
	NSCalendar* calendar = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];

	return [calendar dateFromComponents:components];
}


+ (id)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour {
	NSDateComponents* components = [[[NSDateComponents alloc] init] autorelease];
	[components setYear:year];
  [components setMonth:month];
  [components setDay:day];
  [components setHour:hour];
	NSCalendar* calendar = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];

	return [calendar dateFromComponents:components];
}


- (id)dateByAddingDays:(NSInteger)days months:(NSInteger)months years:(NSInteger)years {
  NSDateComponents* components = [[[NSDateComponents alloc] init] autorelease];
  components.day = days;
  components.month = months;
  components.year = years;
  NSCalendar* calendar = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];

  return [calendar dateByAddingComponents:components
                                   toDate:self
                                  options:0];
}


- (NSDateComponents *)gregorianCalendarComponents {
  NSCalendar* calendar = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
  NSUInteger unitFlags = (NSEraCalendarUnit | NSYearCalendarUnit |
                          NSMonthCalendarUnit | NSDayCalendarUnit |
                          NSHourCalendarUnit | NSMinuteCalendarUnit |
                          NSSecondCalendarUnit | NSWeekCalendarUnit |
                          NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit);

  return [calendar components:unitFlags
                     fromDate:self];
}


- (NSInteger)era {
	return [[self gregorianCalendarComponents] era];
}


- (NSInteger)year {
	return [[self gregorianCalendarComponents] year];
}


- (NSInteger)month {
	return [[self gregorianCalendarComponents] month];
}


- (NSInteger)day {
	return [[self gregorianCalendarComponents] day];
}


- (NSInteger)hour {
	return [[self gregorianCalendarComponents] hour];
}


- (NSInteger)minute {
	return [[self gregorianCalendarComponents] minute];
}


- (NSInteger)second {
	return [[self gregorianCalendarComponents] second];
}


- (NSInteger)week {
	return [[self gregorianCalendarComponents] week];
}


- (NSInteger)weekday {
	return [[self gregorianCalendarComponents] weekday];
}


- (NSInteger)weekdayOrdinal {
	return [[self gregorianCalendarComponents] weekdayOrdinal];
}


@end
