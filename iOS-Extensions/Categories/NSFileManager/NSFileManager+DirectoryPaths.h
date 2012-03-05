//
//  NSFileManager+DirectoryPaths.h
//  Extensions
//
//  Created by Itzak Tasi on 12/3/3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


#pragma mark -
#pragma mark NSFileManager (DirectoryPaths)
@interface NSFileManager (DirectoryPaths)


#pragma mark - System Directory Paths
// 回傳應用程式沙箱中的資料夾及APP路徑
// - 取得路徑過程若發生錯誤, 則回傳 nil. 
- (NSArray *)directoryPaths;

// 取得應用程式沙箱資料夾根目錄路徑
- (NSString *)homeDirectoryPath;

// 取得應用程式沙箱的 Documents 資料夾路徑 (檔案儲存區)
- (NSString *)documentsDirectoryPath;

// 取得應用程式沙箱的 Library 資料夾路徑
- (NSString *)tmpDirectoryPath;

// 取得應用程式沙箱的 tmp 資料夾路徑 (資料暫存區)
- (NSString *)libraryDirectoryPath;


#pragma mark - System File Paths
// 取得應用程式沙箱中的 app 檔案路徑
- (NSString *)appFilePath;


#pragma mark - Custom Directory Paths
// 自訂的 Documents/Video 資料夾 : 用來儲存 Video 類型的檔案
- (NSString *)documentsVideoDirectoryPath;

// 自訂 Documents/Video 資料夾 : 用來儲存 Image 類型的檔案
- (NSString *)documentsImageDirectoryPath;

// 自訂 tmp/Video 資料夾 : 用來暫時存放 Video 類型的檔案
- (NSString *)tmpVideoDirectoryPath;

// 自訂 tmp/Video 資料夾 : 用來暫存 Image 類型的檔案
- (NSString *)tmpImageDirectoryPath;
@end
