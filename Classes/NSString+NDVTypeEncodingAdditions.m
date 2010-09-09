//
//  NSString+NDVTypeEncodingAdditions.m
//  NDVKit
//
//  Created by Nathan de Vries on 9/09/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.
//

#import "NSString+NDVTypeEncodingAdditions.h"


static BOOL TypeCodeIsCharArray(const char* typeCode) {
	NSUInteger lastCharOffset = strlen(typeCode) - 1;
	NSUInteger secondToLastCharOffset = lastCharOffset - 1 ;

	BOOL isCharArray = (typeCode[0] == '[' &&
                      typeCode[secondToLastCharOffset] == 'c' &&
                      typeCode[lastCharOffset] == ']');

	for (NSUInteger i = 1; i < secondToLastCharOffset; i++)
		isCharArray = isCharArray && isdigit(typeCode[i]);

	return isCharArray;
}


static NSString* NDVToStringFromBoolOrCharValue(BOOL boolOrCharValue) {
  if (boolOrCharValue == YES) {
		return @"YES";

  } else if (boolOrCharValue == NO) {
    return @"NO";

  } else {
    return [NSString stringWithFormat:@"'%c'", boolOrCharValue];
  }
}


static NSString* NDVToStringFromFourCharCodeOrUnsignedInt32(FourCharCode fourcc) {
	return [NSString stringWithFormat:@"%u ('%c%c%c%c')",
          fourcc,
          (fourcc >> 24) & 0xFF,
          (fourcc >> 16) & 0xFF,
          (fourcc >> 8) & 0xFF,
          fourcc & 0xFF];
}


static NSString *NDVToStringFromNSDecimalInCurrentLocale(NSDecimal decimal) {
	return NSDecimalString(&decimal, [NSLocale currentLocale]);
}


NSString* NDVToStringFromTypeCodeAndValue(const char * typeCode, void * value) {
  # define IF_TYPE_CODE_MATCHES_CONVERT_WITH_FUNCTION(_TYPE_TO_MATCH_, _CONVERSION_FUNCTION_) \
      if (strcmp(typeCode, @encode(_TYPE_TO_MATCH_)) == 0) \
        return (_CONVERSION_FUNCTION_)(*(_TYPE_TO_MATCH_*)value)

  # if TARGET_OS_IPHONE
      IF_TYPE_CODE_MATCHES_CONVERT_WITH_FUNCTION(CGPoint, NSStringFromCGPoint);
      IF_TYPE_CODE_MATCHES_CONVERT_WITH_FUNCTION(CGSize, NSStringFromCGSize);
      IF_TYPE_CODE_MATCHES_CONVERT_WITH_FUNCTION(CGRect, NSStringFromCGRect);
  #else
      IF_TYPE_CODE_MATCHES_CONVERT_WITH_FUNCTION(NSPoint, NSStringFromPoint);
      IF_TYPE_CODE_MATCHES_CONVERT_WITH_FUNCTION(NSSize, NSStringFromSize);
      IF_TYPE_CODE_MATCHES_CONVERT_WITH_FUNCTION(NSRect, NSStringFromRect);
  #endif

	IF_TYPE_CODE_MATCHES_CONVERT_WITH_FUNCTION(NSRange, NSStringFromRange);
	IF_TYPE_CODE_MATCHES_CONVERT_WITH_FUNCTION(Class, NSStringFromClass);
	IF_TYPE_CODE_MATCHES_CONVERT_WITH_FUNCTION(SEL, NSStringFromSelector);
	IF_TYPE_CODE_MATCHES_CONVERT_WITH_FUNCTION(BOOL, NDVToStringFromBoolOrCharValue);

	IF_TYPE_CODE_MATCHES_CONVERT_WITH_FUNCTION(NSDecimal, NDVToStringFromNSDecimalInCurrentLocale);
  IF_TYPE_CODE_MATCHES_CONVERT_WITH_FUNCTION(FourCharCode, NDVToStringFromFourCharCodeOrUnsignedInt32);


  # define IF_TYPE_CODE_MATCHES_CONVERT_WITH_FORMAT(_TYPE_TO_MATCH_, _FORMAT_STRING_) \
      if (strcmp(typeCode, @encode(_TYPE_TO_MATCH_)) == 0) \
        return [NSString stringWithFormat:(_FORMAT_STRING_), (*(_TYPE_TO_MATCH_ *)value)]

  // NOTE: CFStringRef is toll-free bridged to NSString*
	IF_TYPE_CODE_MATCHES_CONVERT_WITH_FORMAT(CFStringRef, @"%@");

  //NOTE: CFArrayRef is toll-free bridged to NSArray*
	IF_TYPE_CODE_MATCHES_CONVERT_WITH_FORMAT(CFArrayRef, @"%@");

	IF_TYPE_CODE_MATCHES_CONVERT_WITH_FORMAT(long long, @"%lld");
	IF_TYPE_CODE_MATCHES_CONVERT_WITH_FORMAT(unsigned long long, @"%llu");
	IF_TYPE_CODE_MATCHES_CONVERT_WITH_FORMAT(float, @"%f");
	IF_TYPE_CODE_MATCHES_CONVERT_WITH_FORMAT(double, @"%f");
	IF_TYPE_CODE_MATCHES_CONVERT_WITH_FORMAT(id, @"%@");
	IF_TYPE_CODE_MATCHES_CONVERT_WITH_FORMAT(short, @"%hi");
	IF_TYPE_CODE_MATCHES_CONVERT_WITH_FORMAT(unsigned short, @"%hu");
	IF_TYPE_CODE_MATCHES_CONVERT_WITH_FORMAT(int, @"%i");
	IF_TYPE_CODE_MATCHES_CONVERT_WITH_FORMAT(unsigned, @"%u");
	IF_TYPE_CODE_MATCHES_CONVERT_WITH_FORMAT(long, @"%i");

  // WARNING: On older versions of OS X, @encode(long double) == @encode(double)
	IF_TYPE_CODE_MATCHES_CONVERT_WITH_FORMAT(long double, @"%Lf");

	// C-strings
	IF_TYPE_CODE_MATCHES_CONVERT_WITH_FORMAT(char*, @"%s");
	IF_TYPE_CODE_MATCHES_CONVERT_WITH_FORMAT(const char*, @"%s");

	if (TypeCodeIsCharArray(typeCode))
		return [NSString stringWithFormat:@"%s", (char *)value];

	IF_TYPE_CODE_MATCHES_CONVERT_WITH_FORMAT(void*, @"(void *)%p");

  // @encode(CLLocationCoordinate2D)
	if (strcmp(typeCode, "{?=dd}") == 0)
		return [NSString stringWithFormat:@"{ latitude=%g, longitude=%g}", ((double *)value)[0], ((double *)value)[1]];

	return nil;
}
