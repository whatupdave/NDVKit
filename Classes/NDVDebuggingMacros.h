/*
 * NDVDebuggingMacros.h
 *
 * Created by Nathan de Vries on 25/08/10.
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


// Always log, regardless of whether DEBUG is set

# define ALog(format, ...) NSLog((@"%s [L%d] " format), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)


// Only log when DEBUG is set, otherwise no-op

# ifdef DEBUG
#  define DLog(format, ...) ALog(format, ##__VA_ARGS__)
# else
#   define DLog(...)
# endif


// Used by ASIHTTPRequest

# ifdef DEBUG
#  define DEBUG_REQUEST_STATUS 1
#  define DEBUG_FORM_DATA_REQUEST 1
#  define DEBUG_THROTTLING 1
#  define DEBUG_PERSISTENT_CONNECTIONS 1
# endif


// Log arbitrary expressions. e.g. "ALogExpression(self.window.frame.size)"

# define ALogExpression(_EXPRESSION_) do { \
  NSString* _STRING_VALUE_ = NDVToString(_EXPRESSION_); \
  if (_STRING_VALUE_) { \
    ALog(@"%s = %@", #_EXPRESSION_, _STRING_VALUE_); \
  } else { \
    ALog(@"Unknown type code (%s) for expression %s", @encode(__typeof__(_EXPRESSION_)), #_EXPRESSION_); \
  } \
} while (0)


# ifdef DEBUG
#  define DLogExpression(_EXPRESSION_) ALogExpression(_EXPRESSION_)
# else
#   define DLogExpression(_EXPRESSION_)
# endif
