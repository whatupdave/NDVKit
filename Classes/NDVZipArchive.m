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


+ (BOOL)zipAllFilesAtPath:(NSString *)filePath
          toZipFileAtPath:(NSString *)zipFilePath {
    
    NDVZipArchive* zipArchive = [[[self alloc] init] autorelease];
    BOOL isCreated = [zipArchive createZipFileWithPath:zipFilePath];
    
    if (!isCreated) return NO;
    
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSDirectoryEnumerator* directoryEnumerator = [fileManager enumeratorAtPath:filePath];
    
    NSString* relativeFilePath;
    while ((relativeFilePath = [directoryEnumerator nextObject])) {
        BOOL isAdded = [zipArchive addFileToZipFileWithPath:[filePath stringByAppendingPathComponent:relativeFilePath]
                                              nameInZipFile:relativeFilePath];
        if (!isAdded) return NO;
    }
    
    BOOL isClosed = [zipArchive closeZipFile];
    
    return isClosed;
}


- (id)init {
	if((self = [super init])) {
		_zipFile = NULL ;
        _unzipFile = NULL;
	}
	return self;
}


- (void)dealloc {
    if (_zipFile != NULL) [self closeZipFile];
    if (_unzipFile != NULL) [self closeUnzipFile];
    
    [super dealloc];
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
    
    BOOL sucessfullyClosed = (zipClose(_zipFile, NULL) == UNZ_OK ? YES : NO);
    _zipFile = NULL;
    
    return sucessfullyClosed;
}


# pragma mark -
# pragma mark Unzipping


- (BOOL)openUnzipFileWithPath:(NSString *)zipFilePath {
	_unzipFile = unzOpen((const char *)[zipFilePath UTF8String]);
    return (_unzipFile != NULL);
}


- (BOOL)unzipFileToPath:(NSString *)path overWrite:(BOOL)overwrite {
	BOOL overallSuccess = YES;
    int returnCode;
    
	unzGoToFirstFile(_unzipFile);
	unsigned char	buffer[4096] = {0};
	NSFileManager* fileManager = [NSFileManager defaultManager];
    
    do {
        returnCode = unzOpenCurrentFile(_unzipFile);
        
        if (returnCode != UNZ_OK) {
            overallSuccess = NO;
            break;
        }
        
        unz_file_info fileInfo;
        returnCode = unzGetCurrentFileInfo(_unzipFile, &fileInfo, NULL, 0, NULL, 0, NULL, 0);
        if (returnCode != UNZ_OK) {
            overallSuccess = NO;
            unzCloseCurrentFile(_unzipFile);
            break;
        }
        
        char* filename = (char *) malloc(fileInfo.size_filename + 1);
        unzGetCurrentFileInfo(_unzipFile, &fileInfo, filename, fileInfo.size_filename + 1, NULL, 0, NULL, 0);
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
            unzCloseCurrentFile(_unzipFile);
            unzGoToNextFile(_unzipFile);
            continue;
        }
        
        int bytesRead ;
        FILE* outputFile = fopen((const char *)[currentFileOutputPath UTF8String], "wb");
        while (outputFile) {
            bytesRead = unzReadCurrentFile(_unzipFile, buffer, 4096);
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
        
        unzCloseCurrentFile(_unzipFile);
        returnCode = unzGoToNextFile(_unzipFile);
        
    } while (returnCode == UNZ_OK && returnCode != UNZ_END_OF_LIST_OF_FILE );
    
    return overallSuccess;
}


- (BOOL)closeUnzipFile {
    if (_unzipFile == NULL) return NO;
    
    BOOL sucessfullyClosed = (unzClose(_unzipFile) == UNZ_OK ? YES : NO);
    _unzipFile = NULL;
    
    return sucessfullyClosed;
}


@end
