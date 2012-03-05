//
//  ITBlockActionSheet.h
//  Extensions
//
//  Created by ItzakTasi on 12/2/19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


#pragma mark -
#pragma mark Prefix Defines
// 定義 ITBlockActionSheet 使用的 Block 型態
typedef void (^ITBlockActionSheetVoidBlock)();
typedef void (^ITBlockActionSheetButtonBlock)(int buttonIndex);

@protocol ITBlockActionSheetDelegate;


#pragma mark -
#pragma mark ITBlockActionSheet
// 繼承 UIActionSheet 並實作 UIActionSheetDelegate
@interface ITBlockActionSheet : UIActionSheet <UIActionSheetDelegate>
{
    
}


#pragma mark - Properties
// 實用 ITBlockActionSheetDelegate 的委派對象
@property (nonatomic, weak) id <ITBlockActionSheetDelegate> blockDelegate;

// ITBlockActionSheet 取消時執行的 Block
// - 注意此處並不是指「使用者按下取消按鈕」
@property (nonatomic, strong) ITBlockActionSheetVoidBlock cancelBlock;

// ITBlockActionSheet 即將顯示時執行的 Block
@property (nonatomic, strong) ITBlockActionSheetVoidBlock willPresentBlock;

// ITBlockActionSheet 已經顯示時執行的 Block
@property (nonatomic, strong) ITBlockActionSheetVoidBlock didPresentBlock;

// 按下「取消按鈕」時執行的 Block
@property (nonatomic, strong) ITBlockActionSheetVoidBlock cancelButtonClickedBlock;

// 按下「Destructive按鈕」時執行的 Block
@property (nonatomic, strong) ITBlockActionSheetVoidBlock destructiveButtonClickedBlock;

// 按下「任一按鈕」時執行的 Block
@property (nonatomic, strong) ITBlockActionSheetButtonBlock buttonClickedBlock;

// ITBlockActionSheet 即將關閉時執行的 Block
@property (nonatomic, strong) ITBlockActionSheetButtonBlock willDismissBlock;

// ITBlockActionSheet 已經關閉時執行的 Block
@property (nonatomic, strong) ITBlockActionSheetButtonBlock didDissmissBlock;

// ITBlockActionSheet 自動關閉時執行的 Block
// - [唯讀] 必須透過實體方法來設定
@property (nonatomic, strong, readonly) ITBlockActionSheetVoidBlock autoDismissBlock;

// ITBlockActionSheet 自動關閉前的等待秒數
// - [唯讀] 必須透過實體方法來設定
@property (nonatomic, assign, readonly) NSTimeInterval autoDismissInterval;


#pragma mark - Initializations
// ITBlockActionSheet 初始化方法
- (id)initWithTitle:(NSString *)title                                   // 標題
      blockDelegate:(id <ITBlockActionSheetDelegate>)blockDelegate      // 實作 ITBlockActionSheetDelegate 的委派對象
  cancelButtonTitle:(NSString *)cancelButtonTitle                       // 取消按鈕的標題
onCancelButtonClickedBlock:(ITBlockActionSheetVoidBlock)cancelButtonClickedBlock    // 取消按鈕按下時執行的 Block
destructiveButtonTitle:(NSString *)destructiveButtonTitle               // Destructive 按鈕的標題
onDestructiveButtonClickedBlock:(ITBlockActionSheetButtonBlock)destructiveButtonClickedBlock 
                                                                        // Destructive 按鈕按下時執行的 Block
  otherButtonTitles:(NSArray *)otherButtonTitles                        // 其他按鈕的標題
onButtonClickedBlock:(ITBlockActionSheetButtonBlock)buttonClickedBlock; // 按下任一按鈕時執行的 Block

- (id)initWithTitle:(NSString *)title 
      blockDelegate:(id <ITBlockActionSheetDelegate>)blockDelegate 
  cancelButtonTitle:(NSString *)cancelButtonTitle
onCancelButtonClickedBlock:(ITBlockActionSheetVoidBlock)cancelButtonClickedBlock
destructiveButtonTitle:(NSString *)destructiveButtonTitle
onDestructiveButtonClickedBlock:(ITBlockActionSheetButtonBlock)destructiveButtonClickedBlock;

- (id)initWithTitle:(NSString *)title 
      blockDelegate:(id <ITBlockActionSheetDelegate>)blockDelegate 
  cancelButtonTitle:(NSString *)cancelButtonTitle
onCancelButtonClickedBlock:(ITBlockActionSheetVoidBlock)cancelButtonClickedBlock
  otherButtonTitles:(NSArray *)otherButtonTitles
onButtonClickedBlock:(ITBlockActionSheetButtonBlock)buttonClickedBlock;



#pragma mark - Auto Dismiss Methods
// 自動關閉功能是否啟用
// - autoDismissInterval 大於 0.0f 時, 回傳 YES
// - autoDismissInterval 小於等於 0.0f 時, 回傳 NO
- (BOOL)autoDismissEnabled;

// 是否可以設定自動關閉的等待時間
// - 自動關閉功能將於 ITBlockActionSheet 顯示後開始倒數，因此在顯示後便不允許再修改等待秒數
// - 當 ITBlockActionSheet 尚未顯示時回傳 YES, 否則回傳 NO
- (BOOL)canSetAutoDismissInterval;

// 設定自動關閉的等待秒數, 回傳設定是否成功
// - 自動關閉功能將於 ITBlockAlertView 顯示後開始倒數，因此必須在 ITBlockAlertView 尚未顯示前才允許設定
// - 設定成功時回傳 YES, 否則回傳 NO
- (BOOL)setAutoDismissInterval:(NSTimeInterval)autoDismissInterval;

// 設定自動關閉的等待秒數及自動關閉時要執行的 Block
// - 自動關閉功能將於 ITBlockAlertView 顯示後開始倒數，因此必須在 ITBlockAlertView 尚未顯示前才允許設定
// - 設定成功時回傳 YES, 否則回傳 NO
- (BOOL)setAutoDismissInterval:(NSTimeInterval)autoDismissInterval 
          withAutoDismissBlock:(ITBlockActionSheetVoidBlock)autoDismissBlock;

@end



#pragma mark -
#pragma mark ITBlockActionSheetDelegate
@protocol ITBlockActionSheetDelegate <NSObject>
@optional
// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)blockActionSheet:(ITBlockActionSheet *)blockActionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;

// Called when we cancel a view (eg. the user clicks the Home button). 
// This is not called when the user clicks the cancel button.
// If not defined in the delegate, we simulate a click in the cancel button
- (void)blockActionSheetCancel:(ITBlockActionSheet *)blockActionSheet;

// before animation and showing view
- (void)willPresentBlockActionSheet:(ITBlockActionSheet *)blockActionSheet; 
// after animation
- (void)didPresentBlockActionSheet:(ITBlockActionSheet *)blockActionSheet;  

// Before animation and hiding view
- (void)blockActionSheet:(ITBlockActionSheet *)blockActionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex; 

// after animation
- (void)blockActionSheet:(ITBlockActionSheet *)blockActionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex;

// after auto dismiss
- (void)blockActionSheetDidAutoDismiss:(ITBlockActionSheet *)blockActionSheet;


- (void)blockActionSheetCancelButtonClicked:(ITBlockActionSheet *)blockActionSheet;

- (void)blockActionSheetDestructiveButtonClicked:(ITBlockActionSheet *)blockActionSheet;

@end