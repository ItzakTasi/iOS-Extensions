//
//  NSFileManager+Management.h
//  Extensions
//
//  Created by Itzak Tasi on 12/3/5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


#pragma mark -
#pragma mark NSFileManager (Management)
@interface NSFileManager (Management)


#pragma mark - Directory Management Methods
// 檢查資料夾路徑是否存在
// - 路徑存在且為其類型為「資料夾」時回傳 YES, 否則回傳 NO
- (BOOL)directoryExistsAtPath:(NSString *)directoryPath;

// 建立資料夾
// - 簡單化的包裝, 默認自動建立指定路徑之父系目錄
- (BOOL)createDirectoryAtPath:(NSString *)directoryPath;

// 刪除資料夾
// - 資料夾刪除成功, 資料夾原本就不存在, 該路徑實際為檔案類型等情況之一時, 回傳 YES
// - 資料夾刪除時發生錯誤時, Return NO
- (BOOL)removeDirectoryAtPath:(NSString *)directoryPath;

// 清除資料夾內容 (包含子檔案, 子目錄)
// - 資料夾內容清除成功時, Return YES
// - 資料夾不存在, 該路徑實際為檔案類型, 清除過程發生錯誤, 內容清除不完全等情況之一時, 回傳 NO
- (BOOL)clearContentsOfDirectoryAtPath:(NSString *)directoryPath;

// 取得資料夾內容的路徑 (包含子檔案, 子目錄)
// - 資料夾存在時, 使用陣列收集資料夾內容的檔案路徑後回傳
// - 資料夾不存在, 該路徑實際為檔案類型, 回傳 nil
- (NSArray *)contentsOfDirectoryAtPath:(NSString *)directoryPath;


#pragma mark - File Manager Methods
// 刪除檔案
// - 成功刪除檔案時, Return YES
// - 檔案不存在或該路徑為目錄類型時, Return NO
- (BOOL)removeFileAtPath:(NSString *)filePath;


#pragma mark - Available Path Management Methods.
// 取得可供使用的檔案名稱
// - 該資料夾路徑中不存在相同的檔案名稱時, 傳回原檔案名稱
// - 該資料夾路徑中已存在相同的檔案名稱時, 替原檔案名稱添加流水號後傳回
- (NSString *)availableFileName:(NSString *)fileName inDirectory:(NSString *)directoryPath;

// 取得可供使用的檔案路徑
// - 該路徑不存在任何檔案或資料夾時, 回傳原路徑
// - 該路徑已存在任何檔案或資料夾時, 替原路徑添加流水號後傳回
- (NSString *)availableFilePath:(NSString *)filePath;


@end
