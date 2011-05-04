//
//  NDVZipArchive.h
//  NDVKit
//
//  Created by Nathan de Vries on 14/09/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "zip.h"
#import "unzip.h"



@interface NDVZipArchive : NSObject {
    
    zipFile _zipFile;
    unzFile _unzipFile;
    
}


+ (BOOL)zipAllFilesAtPath:(NSString *)filePath
          toZipFileAtPath:(NSString *)zipFilePath;


+ (BOOL)unzipFileAtPath:(NSString *)zipFilePath
                 toPath:(NSString *)path
              overWrite:(BOOL)overWrite;


- (BOOL)createZipFileWithPath:(NSString *)zipFilePath;
- (BOOL)addFileToZipFileWithPath:(NSString *)filePath 
                   nameInZipFile:(NSString *)nameInZipFile;
- (BOOL)closeZipFile;


- (BOOL)openUnzipFileWithPath:(NSString *)zipFilePath;
- (BOOL)unzipFileToPath:(NSString *)path overWrite:(BOOL)overwrite;
- (BOOL)closeUnzipFile;


@end
