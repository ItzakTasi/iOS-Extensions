//
//  NSFileManager+DirectoryPaths.m
//  Extensions
//
//  Created by Itzak Tasi on 12/3/3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NSFileManager+DirectoryPaths.h"


#pragma mark -
#pragma mark NSFileManager (DirectoryPaths)
@implementation NSFileManager (DirectoryPaths)


#pragma mark - System Directory Paths
// 傳回應用程式沙箱中的資料夾及APP路徑
// - 取得路徑過程若發生錯誤, 則傳回 nil. 
- (NSArray *)directoryPaths
{   
    NSError *directoryError = nil;
    NSString *homeDirectoryPath = [self homeDirectoryPath];
    NSArray *files = [self contentsOfDirectoryAtPath:homeDirectoryPath error:&directoryError];
    
    // 發生錯誤時傳回 nil
    if (directoryError) {
        return nil;
    }
    
    // 取得應用程式沙箱根目錄中資料夾及路徑
    NSMutableArray *filePaths = [NSMutableArray arrayWithCapacity:files.count];
    for (NSString *file in files) {
        NSString *filePath = [homeDirectoryPath stringByAppendingPathComponent:file];
        [filePaths addObject:filePath];
    }
    
    NSArray *paths = [NSArray arrayWithArray:filePaths];
    return paths;
}

// 取得應用程式沙箱資料夾根目錄路徑
- (NSString *)homeDirectoryPath
{
    NSString *directoryPath = NSHomeDirectory();
    return directoryPath;
}

// 取得應用程式沙箱的 Documents 資料夾路徑 (檔案儲存區)
- (NSString *)documentsDirectoryPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *directoryPath = [paths objectAtIndex:0];
    return directoryPath;
}

// 取得應用程式沙箱的 Library 資料夾路徑
- (NSString *)libraryDirectoryPath
{
    NSString *directoryPath = [[self homeDirectoryPath] stringByAppendingPathComponent:@"Library"];
    return directoryPath;
}

// 取得應用程式沙箱的 tmp 資料夾路徑 (資料暫存區)
- (NSString *)tmpDirectoryPath
{
    NSString *directoryPath = [[self homeDirectoryPath] stringByAppendingPathComponent:@"tmp"];
    return directoryPath;
}


#pragma mark - System File Paths
// 取得應用程式沙箱中的 app 檔案路徑
- (NSString *)appFilePath
{
    NSString *filePath;
    NSArray *myDirectoryPaths = [self directoryPaths];
    for (NSString *path in myDirectoryPaths) {
        if ([[path pathExtension] isEqualToString:@"app"]) {
            filePath = path;
            break;
        }
    }
    return filePath;
}


#pragma mark - Custom Directory Paths
// 自訂的 Documents/Video 資料夾 : 用來儲存 Video 類型的檔案
- (NSString *)documentsVideoDirectoryPath
{
    NSString *directoryPath = [[self documentsDirectoryPath] stringByAppendingPathComponent:@"Video"];
    return directoryPath;
}

// 自訂 Documents/Video 資料夾 : 用來儲存 Image 類型的檔案
- (NSString *)documentsImageDirectoryPath
{
    NSString *directoryPath = [[self documentsDirectoryPath] stringByAppendingPathComponent:@"Image"];
    return directoryPath;
}

// 自訂 tmp/Video 資料夾 : 用來暫時存放 Video 類型的檔案
- (NSString *)tmpVideoDirectoryPath
{
    NSString *directoryPath = [[self tmpDirectoryPath] stringByAppendingPathComponent:@"Video"];
    return directoryPath;
}

// 自訂 tmp/Video 資料夾 : 用來暫存 Image 類型的檔案
- (NSString *)tmpImageDirectoryPath
{
    NSString *directoryPath = [[self tmpDirectoryPath] stringByAppendingPathComponent:@"Image"];
    return directoryPath;
}

@end
