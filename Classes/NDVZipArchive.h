//
//  NDVZipArchive.h
//  NDVKit
//
//  Created by Nathan de Vries on 14/09/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "unzip.h"


@interface NDVZipArchive : NSObject {

  unzFile	_unzipFile;

}


- (BOOL)openUnzipFileWithPath:(NSString *)zipFilePath;
- (BOOL)unzipFileToPath:(NSString *)path overWrite:(BOOL)overwrite;
- (BOOL)closeUnzipFile;


@property (assign) unzFile unzipFile;


@end
