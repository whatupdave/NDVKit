//
//  NSString+NDVAdditions.h
//  NDVKit
//
//  Created by Nathan de Vries on 24/08/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (NDVAdditions)


- (BOOL)isWhitespace;
- (BOOL)isEmptyOrWhitespace;

- (BOOL)isNumeric;

- (BOOL)containsString:(NSString *)aString;
- (BOOL)containsString:(NSString *)aString ignoringCase:(BOOL)flag;

- (NSString *)stringByAddingURLEncodingPercentEscapes;

- (NSString *)MD5Sum;


@end
