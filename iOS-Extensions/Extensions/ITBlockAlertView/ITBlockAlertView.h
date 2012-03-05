//
//  ITBlockAlertView.h
//  Extensions
//
//  Created by ItzakTasi on 12/2/19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


#pragma mark -
#pragma mark Prefix Defines
// 定義 ITBlockAlertView 所需的 Block 型態
typedef void (^ITBlockAlertViewVoidBlock)();
typedef void (^ITBlockAlertViewButtonBlock)(int buttonIndex);

@protocol ITBlockAlertViewDelegate;

#pragma mark -
#pragma mark ITBlockAlertView
// 繼承 UIAlertView 並實作 UIAlertViewDelegate
@interface ITBlockAlertView : UIAlertView <UIAlertViewDelegate>
{
    
}


#pragma mark -
#pragma mark Properties
// 實作 ITBlockAlertViewDelegate 的委派對象
@property (nonatomic, weak) id <ITBlockAlertViewDelegate> blockDelegate;

// ITBlockAlertView 取消時執行的 Block
// - 注意此處並不是指「使用者按下取消按鈕」
@property (nonatomic, strong) ITBlockAlertViewVoidBlock cancelBlock;

// ITBlockAlertView 即將顯示前執行的 Block
@property (nonatomic, strong) ITBlockAlertViewVoidBlock willPresentBlock;

// ITBlockAlertView 已經顯示時執行的 Block
@property (nonatomic, strong) ITBlockAlertViewVoidBlock didPresentBlock;

// 按下「取消按鈕」時執行的 Block
@property (nonatomic, strong) ITBlockAlertViewVoidBlock cancelButtonClickedBlock;

// 按下「任一按鈕」時執行的 Block
@property (nonatomic, strong) ITBlockAlertViewButtonBlock buttonClickedBlock;

// ITBlockAlertView 即將關閉時執行的 Block
@property (nonatomic, strong) ITBlockAlertViewButtonBlock willDismissBlock;

// ITBlockAlertView 已經關閉時執行的 Block
@property (nonatomic, strong) ITBlockAlertViewButtonBlock didDismissBlock;

// ITBlockAlertView 自動關閉時執行的 Block
// - [唯讀] 必須透過實體方法來設定
@property (nonatomic, strong, readonly) ITBlockAlertViewVoidBlock autoDismissBlock;

// ITBlockAlertView 自動關閉前的等待秒數
// - [唯讀] 必須透過實體方法來設定
@property (nonatomic, assign, readonly) NSTimeInterval autoDismissInterval;


#pragma mark - Initializations
// 初始化 ITBlockAlertView 的方法
- (id)initWithTitle:(NSString *)title                                               // 標題
            message:(NSString *)message                                             // 訊息
      blockDelegate:(id <ITBlockAlertViewDelegate>)blockDelegate                    // 委派的對象
  cancelButtonTitle:(NSString *)cancelButtonTitle                                   // 取消按鈕的標題
onCancelButtonClickedBlock:(ITBlockAlertViewVoidBlock)cancelButtonClickedBlock      // 取消按鈕被按下時要執行的 Block
  otherButtonTitles:(NSArray *)otherButtonTitles                                    // 其他按鈕的標題
onButtonClickedBlock:(ITBlockAlertViewButtonBlock)buttonClickedBlock;               // 其他按鈕被按下時要執行的 Block

- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
      blockDelegate:(id <ITBlockAlertViewDelegate>)blockDelegate
  cancelButtonTitle:(NSString *)cancelButtonTitle
onCancelButtonClickedBlock:(ITBlockAlertViewVoidBlock)cancelButtonClickedBlock;

- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
      blockDelegate:(id <ITBlockAlertViewDelegate>)blockDelegate;


#pragma mark - Auto Dismiss Methods
// 自動關閉功能是否啟用
// - autoDismissInterval 大於 0.0f 時, 回傳 YES
// - autoDismissInterval 小於等於 0.0f 時, 回傳 NO
- (BOOL)autoDismissEnabled;

// 是否可以設定自動關閉的等待時間
// - 自動關閉功能將於 ITBlockAlertView 顯示後開始倒數，因此在顯示後便不允許再修改等待秒數
// - 當 ITBlockAlertView 尚未顯示時回傳 YES, 否則回傳 NO
- (BOOL)canSetAutoDismissInterval;

// 設定自動關閉的等待秒數, 回傳設定是否成功
// - 自動關閉功能將於 ITBlockAlertView 顯示後開始倒數，因此必須在 ITBlockAlertView 尚未顯示前才允許設定
// - 設定成功時回傳 YES, 否則回傳 NO
- (BOOL)setAutoDismissInterval:(NSTimeInterval)autoDismissInterval;

// 設定自動關閉的等待秒數及自動關閉時要執行的 Block, 回傳設定是否成功
// - 自動關閉功能將於 ITBlockAlertView 顯示後開始倒數，因此必須在 ITBlockAlertView 尚未顯示前才允許設定
// - 設定成功時回傳 YES, 否則回傳 NO
- (BOOL)setAutoDismissInterval:(NSTimeInterval)autoDismissInterval
          withAutoDismissBlock:(ITBlockAlertViewVoidBlock)autoDismissBlock;
@end


#pragma mark -
#pragma mark ITBlockAlertViewDelegate
@protocol ITBlockAlertViewDelegate <NSObject>
@optional
// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)blockAlertView:(ITBlockAlertView *)blockAlertView clickedButtonAtIndex:(NSInteger)buttonIndex;

// Called when we cancel a view (eg. the user clicks the Home button). 
// This is not called when the user clicks the cancel button.
// If not defined in the delegate, we simulate a click in the cancel button
- (void)blockAlertViewCancel:(ITBlockAlertView *)blockAlertView;

// before animation and showing view
- (void)willPresentBlockAlertView:(ITBlockAlertView *)blockAlertView;  

// after animation
- (void)didPresentBlockAlertView:(ITBlockAlertView *)blockAlertView;

// before animation and hiding view
- (void)blockAlertView:(ITBlockAlertView *)blockAlertView willDismissWithButtonIndex:(NSInteger)buttonIndex; 
// after animation
- (void)blockAlertView:(ITBlockAlertView *)blockAlertView didDismissWithButtonIndex:(NSInteger)buttonIndex;  

// Called after edits in any of the default fields added by the style
- (BOOL)blockAlertViewShouldEnableFirstOtherButton:(ITBlockAlertView *)blockAlertView;

// Called When the view auto dismiss
- (void)blockAlertViewAutoDismiss:(ITBlockAlertView *)blockAlertView;

// Called When the cancel button is clicked
- (void)blockAlertViewCancelButtonClicked:(ITBlockAlertView *)blockAlertView;
@end
