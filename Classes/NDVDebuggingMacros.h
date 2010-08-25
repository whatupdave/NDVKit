//
//  NDVDebuggingMacros.h
//  NDVKit
//
//  Created by Nathan de Vries on 25/08/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.
//


// Always log, regardless of whether DEBUG is set

# define ALog(format, ...) NSLog((@"%s [L%d] " format), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);


// Only log when DEBUG is set, otherwise no-op

# ifdef DEBUG
#  define DLog(format, ...) ALog(format, ##__VA_ARGS__);
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
