//
//  NDVZipArchive.m
//  NDVKit
//
//  Created by Nathan de Vries on 14/09/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.
//

#import "NDVZipArchive.h"
#import "NSDate+NDVCalendarAdditions.h"


@implementation NDVZipArchive


- (id)init {
	if((self = [super init])) {
		_zipFile = NULL ;
        _unzipFile = NULL;
	}
	return self;
}


# pragma mark -
# pragma mark Zipping (a.k.a. winning)


- (BOOL)createZipFileWithPath:(NSString *)zipFilePath {
    _zipFile = zipOpen( (const char*)[zipFilePath UTF8String], 0 );
    return (_zipFile != NULL);
}


- (BOOL)addFileToZipFileWithPath:(NSString *)filePath
                   nameInZipFile:(NSString *)nameInZipFile {
    
	if (_zipFile == NULL) return NO;
	
	zip_fileinfo zipInfo;
    memset(&zipInfo, 0, sizeof(zip_fileinfo));
    
	zipInfo.dosDate = [[NSDate date] timeIntervalSinceDate:[NSDate dateWithYear:1980]];
	
	NSError* error = NULL;
	NSDictionary* fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath
                                                                                    error:&error];
    
    if (fileAttributes) {
        NSDate* fileModificationDate = (NSDate *)[fileAttributes objectForKey:NSFileModificationDate];
        zipInfo.dosDate = [fileModificationDate timeIntervalSinceDate:[NSDate dateWithYear:1980]];
        
    } else {
        return NO;
    }
	
    int returnCode;
    
    returnCode = zipOpenNewFileInZip( _zipFile,
                                     (const char*) [nameInZipFile UTF8String],
                                     &zipInfo,
                                     NULL, 0,
                                     NULL, 0,
                                     NULL,
                                     Z_DEFLATED,
                                     Z_DEFAULT_COMPRESSION);
    
	if (returnCode != Z_OK) return NO;
    
    
    NSData* fileData = [NSData dataWithContentsOfFile:filePath];
	returnCode = zipWriteInFileInZip(_zipFile, (const void*)[fileData bytes], [fileData length]);
    
	if (returnCode != Z_OK) return NO;
    
    
	returnCode = zipCloseFileInZip(_zipFile);
	if (returnCode != Z_OK) return NO;
    
    
	return YES;
}


- (BOOL)closeZipFile {
	if (_zipFile == NULL) return NO;
    
    int returnCode = zipClose(_zipFile, NULL);
    _zipFile = NULL;
    
    return (returnCode == Z_OK);
}


# pragma mark -
# pragma mark Unzipping


- (BOOL)openUnzipFileWithPath:(NSString *)zipFilePath {
	self.unzipFile = unzOpen((const char *)[zipFilePath UTF8String]);
  return (self.unzipFile != NULL);
}


- (BOOL)unzipFileToPath:(NSString *)path overWrite:(BOOL)overwrite {
	BOOL overallSuccess = YES;
  int returnCode;

	unzGoToFirstFile(self.unzipFile);
	unsigned char	buffer[4096] = {0};
	NSFileManager* fileManager = [NSFileManager defaultManager];

  do {
    returnCode = unzOpenCurrentFile(self.unzipFile);

    if (returnCode != UNZ_OK) {
      overallSuccess = NO;
      break;
    }

    unz_file_info	fileInfo;
    returnCode = unzGetCurrentFileInfo(self.unzipFile, &fileInfo, NULL, 0, NULL, 0, NULL, 0);
    if (returnCode != UNZ_OK) {
      overallSuccess = NO;
      unzCloseCurrentFile(self.unzipFile);
      break;
    }

    char* filename = (char *) malloc(fileInfo.size_filename + 1);
    unzGetCurrentFileInfo(self.unzipFile, &fileInfo, filename, fileInfo.size_filename + 1, NULL, 0, NULL, 0);
    filename[fileInfo.size_filename] = '\0';

    // check if it contains directory
    NSString* currentFilePath = [NSString  stringWithCString:filename encoding:NSUTF8StringEncoding];
    BOOL isDirectory = NO;
    if (filename[fileInfo.size_filename-1] == '/' || filename[fileInfo.size_filename-1] == '\\') {
      isDirectory = YES;
    }
    free(filename);

    if ([currentFilePath rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"/\\"]].location!=NSNotFound ) {
      // contains a path
      currentFilePath = [currentFilePath stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
    }

    NSString* currentFileOutputPath = [path stringByAppendingPathComponent:currentFilePath];

    if (isDirectory) {
      [fileManager createDirectoryAtPath:currentFileOutputPath
             withIntermediateDirectories:YES
                              attributes:nil
                                   error:nil];

    } else {
      [fileManager createDirectoryAtPath:[currentFileOutputPath stringByDeletingLastPathComponent]
             withIntermediateDirectories:YES
                              attributes:nil
                                   error:nil];
    }

    if ([fileManager fileExistsAtPath:currentFileOutputPath] && !isDirectory && !overwrite) {
      unzCloseCurrentFile(self.unzipFile);
      unzGoToNextFile(self.unzipFile);
      continue;
    }

    int bytesRead ;
    FILE* outputFile = fopen((const char *)[currentFileOutputPath UTF8String], "wb");
    while (outputFile) {
      bytesRead = unzReadCurrentFile(self.unzipFile, buffer, 4096);
      if (bytesRead > 0)
        fwrite(buffer, bytesRead, 1, outputFile);
      else
        break;
    }

    if (outputFile) {
      fclose(outputFile);

      if (fileInfo.dosDate != 0) {
        NSDate* originalDate = [[NSDate alloc] initWithTimeInterval:(NSTimeInterval)fileInfo.dosDate
                                                          sinceDate:[NSDate dateWithYear:1980 month:1 day:1]];

        NSDictionary* fileAttributes = [NSDictionary dictionaryWithObject:originalDate
                                                                   forKey:NSFileModificationDate];

        [[NSFileManager defaultManager] setAttributes:fileAttributes
                                         ofItemAtPath:currentFileOutputPath
                                                error:NULL];

        [originalDate release];
        originalDate = nil;
      }
    }

    unzCloseCurrentFile(self.unzipFile);
    returnCode = unzGoToNextFile(self.unzipFile);

  } while (returnCode == UNZ_OK && returnCode != UNZ_END_OF_LIST_OF_FILE );

  return overallSuccess;
}


- (BOOL)closeUnzipFile {
  if (self.unzipFile == NULL) return NO;

  BOOL sucessfullyClosed = (unzClose(self.unzipFile) == UNZ_OK ? YES : NO);
  self.unzipFile = NULL;

  return sucessfullyClosed;
}


@synthesize zipFile=_zipFile;
@synthesize unzipFile=_unzipFile;


@end
