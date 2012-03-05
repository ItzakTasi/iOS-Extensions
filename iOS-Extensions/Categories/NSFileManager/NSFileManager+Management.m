//
//  NSFileManager+Management.m
//  Extensions
//
//  Created by Itzak Tasi on 12/3/5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NSFileManager+Management.h"


#pragma mark -
#pragma mark NSFileManager (Management)
@implementation NSFileManager (Management)


#pragma mark - Directory Management Methods
// 檢查資料夾路徑是否存在
// - 路徑存在且為其類型為「資料夾」時回傳 YES, 否則回傳 NO
- (BOOL)directoryExistsAtPath:(NSString *)directoryPath
{
    BOOL isDirectory;
    if (([self fileExistsAtPath:directoryPath isDirectory:&isDirectory]) && 
        (isDirectory == YES)) {
        return YES;
    }
    return NO;
}

// 建立資料夾
// - 簡單化的包裝, 默認自動建立指定路徑之父系目錄
- (BOOL)createDirectoryAtPath:(NSString *)directoryPath
{
    // 資料夾不存在時建立資料夾
    if ([self directoryExistsAtPath:directoryPath] == NO) {
        NSError *directoryError;        
        BOOL success = [self createDirectoryAtPath:directoryPath 
                       withIntermediateDirectories:YES 
                                        attributes:nil 
                                             error:&directoryError];
        if (directoryError) {
            NSLog(@"Create directory at \"%@\" with ERROR : %@", directoryPath, directoryError);
        }
        
        return success;
    }
    return NO;
}

// 刪除資料夾
// - 資料夾刪除成功, 資料夾原本就不存在, 該路徑實際為檔案類型等情況之一時, 回傳 YES
// - 資料夾刪除時發生錯誤時, Return NO
- (BOOL)removeDirectoryAtPath:(NSString *)directoryPath
{
    // 檢查路徑存在時, 且屬於資料夾類型才進行刪除動作
    if ([self directoryExistsAtPath:directoryPath]) {
        // 刪除資料夾
        NSError *directoryError;
        BOOL success = [self removeItemAtPath:directoryPath error:&directoryError];
        
        if (directoryError) {
            NSLog(@"Remove directory at \"%@\" with ERROR : %@", directoryPath, directoryError);
        }
        
        return success;
    }
    
    // 資料夾原本就不存在時直接回傳 YES
    return YES;
}

// 清除資料夾內容
// - 資料夾內容清除成功時, Return YES
// - 資料夾不存在, 該路徑實際為檔案類型, 清除過程發生錯誤, 內容清除不完全等情況之一時, 回傳 NO
- (BOOL)clearContentsOfDirectoryAtPath:(NSString *)directoryPath
{
    // 取得資料夾的內容
    NSArray *files = [self contentsOfDirectoryAtPath:directoryPath];
    if (files) {
        // 預設 success 為 YES, 若資料夾本身就沒有任何內容需要刪除時, 視同清除內容成功
        // 若資料夾本身具有內容時, 則 success 的值將會在刪除過程中產生變化
        BOOL success = YES;
        
        // 若資料夾本身就沒有任何內容需要刪除時 (files.Count == 0)
        // 此迴圈會被自動略過
        for (NSString *file in files) {
            // 刪除內容項目
            NSError *fileError;
            NSString *filePath = [directoryPath stringByAppendingPathComponent:file];
            success = [self removeItemAtPath:filePath error:&fileError];
            
            // 刪除項目失敗或過程中發生錯誤時顯示訊息並立即中斷清除動作
            if ((success == NO) || (fileError)) {
                NSLog(@"Clear the contents of directory at \"%@\" was ERROR!", directoryPath);
                if (success == NO) {
                    NSLog(@"Remove Item at \"%@\" failed.", filePath);
                } else {
                    NSLog(@"Remove Item at \"%@\" with ERROR : %@", filePath, fileError);
                }
                break;
            }
        }
        
        return success;
    }
    
    // 資料夾不存在, 路徑不為資料夾類型
    NSLog(@"Clear the contents of directory at \"%@\" failed! (Reason : directory not exist.)", directoryPath);
    return NO;
}

// 取得資料夾內容的路徑 (包含子檔案, 子目錄)
// - 資料夾存在時, 使用陣列收集資料夾內容的檔案路徑後回傳
// - 資料夾不存在, 該路徑實際為檔案類型等情況之一時, 回傳 nil
- (NSArray *)contentsOfDirectoryAtPath:(NSString *)directoryPath
{
    if ([self directoryExistsAtPath:directoryPath])
    {
        // 取得資料夾內容的路徑 (包含子檔案, 子目錄)
        NSError *directoryError = nil;
        NSArray *files = [self contentsOfDirectoryAtPath:directoryPath error:&directoryError];
        
        // 取得資料夾內容時若發生任何錯誤時輸出錯誤訊息
        if (directoryError) {
            NSLog(@"Getting contents of directory at \"%@\" with ERROR : %@", directoryPath, directoryError);
        }
        
        return files;
    }
    return nil;
}


#pragma mark - File Management Methods
// 刪除檔案
// - 成功刪除檔案時, Return YES
// - 檔案不存在或該路徑為目錄類型時, Return NO
- (BOOL)removeFileAtPath:(NSString *)filePath
{
    // 檔案存在, 且為檔案類型時才進行刪除動作
    BOOL isDirectory;
    if (([self fileExistsAtPath:filePath isDirectory:&isDirectory]) && 
        (isDirectory == NO)) {
        
        NSError *fileError;
        BOOL success = [self removeItemAtPath:filePath error:&fileError];
        
        if (fileError) {
            NSLog(@"Remove File At \"%@\" with ERROR : %@", filePath, fileError);
        }
        
        return success;
    }
    return NO;
}


#pragma mark - Available Path Management Methods.
// 取得可供使用的路稱名稱 (指定路徑無檔案存在)
// - 該資料夾路徑中不存在相同檔案名稱時, 傳回原檔案名稱
// - 該資料夾路徑中已存在相同檔案名稱時, 將原檔案名稱加上流水號後回傳
- (NSString *)availableFileName:(NSString *)fileName inDirectory:(NSString *)directoryPath
{
    // 取得副檔名、完整路徑
    NSString *filePathExtension = [fileName pathExtension];
    NSString *filePath = [directoryPath stringByAppendingPathComponent:fileName];
    
    // 若該檔案路徑已存在檔案時, 為檔案路徑添加流水號
    BOOL isDirectory;
    NSUInteger fileSerialNumber = 0;
    while ([self fileExistsAtPath:filePath isDirectory:&isDirectory]) {
        // 為路徑名稱添加流水號
        fileSerialNumber++;
        NSString *newFileName = [NSString stringWithFormat:@"%@ (%d)", [fileName stringByDeletingPathExtension],
                                 fileSerialNumber];
        if (filePathExtension.length > 0) {
            newFileName = [newFileName stringByAppendingPathExtension:filePathExtension];
        }
        
        filePath = [directoryPath stringByAppendingPathComponent:newFileName];
    };
    
    // 傳回可使用的檔案名稱
    NSString *availableFileName = [filePath lastPathComponent];
    return availableFileName;
}

// 取得可供使用的路徑 (意即)
// - 該路徑不存在任何檔案或資料夾時, 回傳原路徑
// - 該路徑已存在任何檔案或資料夾時, 替原路徑添加流水號後傳回
- (NSString *)availableFilePath:(NSString *)filePath
{
    // 先分解成上層資料夾路徑及檔案名稱
    NSString *directoryPath = [filePath stringByDeletingLastPathComponent];
    NSString *fileName = [filePath lastPathComponent];
    
    // 透過 availableFileName:inDirectory: 方法取得可供使用的檔案名稱
    NSString *newFileName = [self availableFileName:fileName inDirectory:directoryPath];
    
    // 轉換成完整路徑後回傳
    NSString *newFilePath = [directoryPath stringByAppendingPathComponent:newFileName];
    return newFilePath;
}


@end
