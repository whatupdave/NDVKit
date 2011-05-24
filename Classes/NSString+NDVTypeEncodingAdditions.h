/*
 * NSString+NDVTypeEncodingAdditions.h
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
 
 * Note:
 *
 * This code is inspired by Dave Dribin's original DDToStringFromTypeAndValue
 * and DDToNString macro, as well as Vincent Gable's modifications. Not much
 * has changed, I've just adjusted it to taste. You can find the original code
 * here:
 *
 *   http://www.dribin.org/dave/blog/archives/2008/09/22/convert_to_nsstring/
 *   http://vgable.com/blog/2010/08/19/the-most-useful-objective-c-code-ive-ever-written/
 */


#import <Foundation/Foundation.h>

NSString* NDVToStringFromTypeCodeAndValue(const char * typeCode, void * value);

# define NDVToString(_EXPRESSION_) ({ \
  __typeof__(_EXPRESSION_) _VALUE_ = (_EXPRESSION_); \
  const char* _TYPE_CODE_ = @encode(__typeof__(_EXPRESSION_)); \
  NDVToStringFromTypeCodeAndValue(_TYPE_CODE_, &_VALUE_); \
})
