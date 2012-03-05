//
//  ITBlockAlertView.m
//  Extensions
//
//  Created by ItzakTasi on 12/2/19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ITBlockAlertView.h"


#pragma mark -
#pragma mark Private Interfaces
@interface ITBlockAlertView (PrivateMethods)
// 自動關閉的計時器
- (void)autoDismissTimer:(NSTimer *)timer;
@end 


#pragma mark -
#pragma mark ITBlockAlertView
@implementation ITBlockAlertView


#pragma mark - Properties
@synthesize blockDelegate = _blockDelegate;

@synthesize cancelBlock = _cancelBlock;
@synthesize willPresentBlock = _willPresentBlock;
@synthesize didPresentBlock = _didPresentBlock;

@synthesize cancelButtonClickedBlock = _cancelButtonClickedBlock;
@synthesize buttonClickedBlock = _buttonClickedBlock;
@synthesize willDismissBlock = _willDismissBlock;
@synthesize didDismissBlock = _didDismissBlock;

@synthesize autoDismissBlock = _autoDismissBlock;
@synthesize autoDismissInterval = _autoDismissInterval;


#pragma mark - Initialization
// 初始化 ITBlockAlertView 的方法
- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
      blockDelegate:(id <ITBlockAlertViewDelegate>)blockDelegate
  cancelButtonTitle:(NSString *)cancelButtonTitle
onCancelButtonClickedBlock:(ITBlockAlertViewVoidBlock)cancelButtonClickedBlock
  otherButtonTitles:(NSArray *)otherButtonTitles
onButtonClickedBlock:(ITBlockAlertViewButtonBlock)buttonClickedBlock
{
    // 使用父類別 (UIAlertView) 的初始化方法
    self = [super initWithTitle:title
                        message:message
                       delegate:self
              cancelButtonTitle:cancelButtonTitle
              otherButtonTitles:nil];
    
    // 初始化其他按鈕的標題
    for (NSString *buttonTitle in otherButtonTitles) {
        [self addButtonWithTitle:buttonTitle];
    }
    
    // 初始化主要變數
    _blockDelegate = blockDelegate;
    _cancelButtonClickedBlock = cancelButtonClickedBlock;
    _buttonClickedBlock = buttonClickedBlock;
    
    // 初始化其他變數
    _cancelBlock = nil;
    _willPresentBlock = nil;
    _didPresentBlock = nil;
    _willDismissBlock = nil;
    _didDismissBlock = nil;
    
    // 初始化變數 : 自動關閉
    _autoDismissBlock = nil;        // 自動關閉時執行的 Block
    _autoDismissInterval = 0.0f;   // 自動關閉的秒數
    
    
    return self;
}

- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
      blockDelegate:(id <ITBlockAlertViewDelegate>)blockDelegate
{
    return [self initWithTitle:title 
                       message:message
                 blockDelegate:blockDelegate
             cancelButtonTitle:nil
          onCancelButtonClickedBlock:nil
             otherButtonTitles:nil
          onButtonClickedBlock:nil];
}

- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
      blockDelegate:(id <ITBlockAlertViewDelegate>)blockDelegate
  cancelButtonTitle:(NSString *)cancelButtonTitle
onCancelButtonClickedBlock:(ITBlockAlertViewVoidBlock)cancelButtonClickedBlock
{
    return [self initWithTitle:title 
                       message:message
                 blockDelegate:blockDelegate
             cancelButtonTitle:cancelButtonTitle
          onCancelButtonClickedBlock:cancelButtonClickedBlock
             otherButtonTitles:nil
          onButtonClickedBlock:nil];
}



#pragma mark - Auto Dismiss Methods
// 自動關閉功能是否啟用
// - autoDismissInterval 大於 0.0f 時, 回傳 YES
// - autoDismissInterval 小於等於 0.0f 時, 回傳 NO
- (BOOL)autoDismissEnabled
{
    return (_autoDismissInterval > 0.0f);
}

// 是否可以設定自動關閉的等待時間
// - 自動關閉功能將於 ITBlockAlertView 顯示後開始倒數，因此在顯示後便不允許再修改等待秒數
// - 當 ITBlockAlertView 尚未顯示時回傳 YES, 否則回傳 NO
- (BOOL)canSetAutoDismissInterval
{
    return (self.visible == NO);
}

// 設定自動關閉的等待秒數, 回傳設定是否成功
// - 自動關閉功能將於 ITBlockAlertView 顯示後開始倒數，因此必須在 ITBlockAlertView 尚未顯示前才允許設定
// - 設定成功時回傳 YES, 否則回傳 NO
- (BOOL)setAutoDismissInterval:(NSTimeInterval)autoDismissInterval
{
    return [self setAutoDismissInterval:autoDismissInterval
                   withAutoDismissBlock:nil];
}

// 設定自動關閉的等待秒數及自動關閉時要執行的 Block, 回傳設定是否成功
// - 自動關閉功能將於 ITBlockAlertView 顯示後開始倒數，因此必須在 ITBlockAlertView 尚未顯示前才允許設定
// - 設定成功時回傳 YES, 否則回傳 NO
- (BOOL)setAutoDismissInterval:(NSTimeInterval)autoDismissInterval 
          withAutoDismissBlock:(ITBlockAlertViewVoidBlock)autoDismissBlock
{
    BOOL success = [self canSetAutoDismissInterval];
    if (success) {
        _autoDismissInterval = autoDismissInterval;
        _autoDismissBlock = autoDismissBlock;
    }
    return success;
}


#pragma mark - UIAlertViewDelegate Methods
// 即將顯示時觸發的事件
- (void)willPresentAlertView:(UIAlertView *)alertView
{
    // 即將顯示時執行 Block 並回應給委派對象
    if (_willPresentBlock != nil) {
        _willPresentBlock();
    }
    
    if ([_blockDelegate respondsToSelector:@selector(willPresentBlockAlertView:)]) {
        [_blockDelegate willPresentBlockAlertView:self];
    }
}

// 已經顯示時觸發的事件
- (void)didPresentAlertView:(UIAlertView *)alertView
{
    // 已經顯示時執行 Block 並回應給委派對象
    if (_didPresentBlock != nil) {
        _didPresentBlock();
    }
    
    if ([_blockDelegate respondsToSelector:@selector(didPresentBlockAlertView:)]) {
        [_blockDelegate didPresentBlockAlertView:self];
    }
}

// Called when we cancel a view (eg. the user clicks the Home button). 
// This is not called when the user clicks the cancel button.
// If not defined in the delegate, we simulate a click in the cancel button
- (void)alertViewCancel:(UIAlertView *)alertView
{
    // ITBlockAlertView 取消時執行 Block 並回應給委派對象
    // 若沒設定 Block 則模擬取消按鈕被按下
    if (_cancelBlock != nil) {
        _cancelBlock();
    } else {
        NSUInteger cancelButtonIndex = self.cancelButtonIndex;
        [self dismissWithClickedButtonIndex:cancelButtonIndex animated:YES];
    }
    
    if ([_blockDelegate respondsToSelector:@selector(blockAlertViewCancel:)]) {
        [_blockDelegate blockAlertViewCancel:self];
    }
}

// 任一按鈕被按下時觸發的事件
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // 取消按鈕被按下時執行 Block 並回應給委派對象
    if (self.cancelButtonIndex == buttonIndex) {
        // 執行 Block
        if (_cancelButtonClickedBlock != nil) {
            _cancelButtonClickedBlock();
        }
        
        if ([_blockDelegate respondsToSelector:@selector(blockAlertViewCancelButtonClicked:)]) {
            [_blockDelegate blockAlertViewCancelButtonClicked:self];
        }
    }
    
    // 任一按鈕被按下時執行 Block 並回應給委派對象
    if (_buttonClickedBlock != nil) {
        _buttonClickedBlock(buttonIndex);
    }
    
    if ([_blockDelegate respondsToSelector:@selector(blockAlertView:clickedButtonAtIndex:)]) {
        [_blockDelegate blockAlertView:self clickedButtonAtIndex:buttonIndex];
    }
}

// 即將關閉時觸發的事件
- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    // 即將關閉時執行 Block 並回應給委派對象
    if (_willDismissBlock != nil) {
        _willDismissBlock(buttonIndex);
    }
    
    if ([_blockDelegate respondsToSelector:@selector(blockAlertView:willDismissWithButtonIndex::)]) {
        [_blockDelegate blockAlertView:self willDismissWithButtonIndex:buttonIndex];
    }
}

// 已經關閉時觸發的事件
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    // 已經關閉時執行 Block 並回應給委派對象
    if (_didDismissBlock != nil) {
        _didDismissBlock(buttonIndex);
    }
    
    if ([_blockDelegate respondsToSelector:@selector(blockAlertView:didDismissWithButtonIndex:)]) {
        [_blockDelegate blockAlertView:self didDismissWithButtonIndex:buttonIndex];
    }
}


#pragma mark - Override Methods
// 覆寫父類別的 show 方法
- (void)show
{
    // 先呼叫父類別的 show 方法
    [super show];
    
    // 如果有設定自動關閉的等待秒數時啟動計時器
    if ([self autoDismissEnabled]) {
        [NSTimer scheduledTimerWithTimeInterval:_autoDismissInterval
                                         target:self
                                       selector:@selector(autoDismissTimer:) 
                                       userInfo:nil
                                        repeats:NO];
    }
}
@end


#pragma mark -
#pragma mark ITBlockAlertView (PrivateMethods)
@implementation ITBlockAlertView (PrivateMethods)
// 自動關閉的計時器
- (void)autoDismissTimer:(NSTimer *)timer
{
    if (self.visible) {
        // 關閉 ITBlockAlertView
        [self dismissWithClickedButtonIndex:-1 animated:YES];
        
        // 執行自動關閉時的 Block
        if (_autoDismissBlock != nil) {
            _autoDismissBlock();
        }
        
        // 回應給委派對象
        if ([_blockDelegate respondsToSelector:@selector(blockAlertViewAutoDismiss:)]) {
            [_blockDelegate blockAlertViewAutoDismiss:self];
        }
    }
    
    // 停止計時器
    if (timer) {
        [timer invalidate];
    }
}
@end