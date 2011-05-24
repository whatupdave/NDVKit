/*
 * NSDate+NDVCalendarAdditions.m
 *
 * Created by Nathan de Vries on 24/08/10.
 *
 * Copyright (c) 2008-2011, Nathan de Vries.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. Neither the name of the copyright holder nor the names of any
 *    contributors may be used to endorse or promote products derived from
 *    this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */


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
