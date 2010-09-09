//
//  NSString+NDVTypeEncodingAdditions.h
//  NDVKit
//
//  Created by Nathan de Vries on 9/09/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.

#import <Foundation/Foundation.h>


//
//  Note:
//
//  This code is inspired by Dave Dribin's original DDToStringFromTypeAndValue
//  and DDToNString macro, as well as Vincent Gable's modifications. Not much
//  has changed, I've just adjusted it to taste. You can find the original code
//  here:
//
//    http://www.dribin.org/dave/blog/archives/2008/09/22/convert_to_nsstring/
//    http://vgable.com/blog/2010/08/19/the-most-useful-objective-c-code-ive-ever-written/


NSString* NDVToStringFromTypeCodeAndValue(const char * typeCode, void * value);

# define NDVToString(_EXPRESSION_) ({ \
  __typeof__(_EXPRESSION_) _VALUE_ = (_EXPRESSION_); \
  const char* _TYPE_CODE_ = @encode(__typeof__(_EXPRESSION_)); \
  NDVToStringFromTypeCodeAndValue(_TYPE_CODE_, &_VALUE_); \
})
