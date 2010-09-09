//
//  NDVDebuggingMacros.h
//  NDVKit
//
//  Created by Nathan de Vries on 25/08/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.
//

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
