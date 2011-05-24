/*
 * NSString+NDVTypeEncodingAdditions.m
 *
 * Created by Nathan de Vries on 9/09/10.
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
