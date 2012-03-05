//
//  ITBlockActionSheet.m
//  Extensions
//
//  Created by ItzakTasi on 12/2/19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ITBlockActionSheet.h"


#pragma mark -
#pragma mark Private Interfaces
@interface ITBlockActionSheet (PrivateMethods)
// 自動關閉的計時器
- (void)autoDismissTimer:(NSTimer *)timer;
@end


#pragma mark -
#pragma mark ITBlockActionSheet
@implementation ITBlockActionSheet


#pragma mark - Properties
@synthesize blockDelegate = _blockDelegate;

@synthesize cancelBlock = _cancelBlock;
@synthesize willPresentBlock = _willPresentBlock;
@synthesize didPresentBlock = _didPresentBlock;
@synthesize cancelButtonClickedBlock = _cancelButtonClickedBlock;
@synthesize destructiveButtonClickedBlock = _destructiveButtonClickedBlock;

@synthesize buttonClickedBlock = _buttonClickedBlock;
@synthesize willDismissBlock = _willDismissBlock;
@synthesize didDissmissBlock = _didDissmissBlock;

@synthesize autoDismissBlock = _autoDismissBlock;
@synthesize autoDismissInterval = _autoDismissInterval;


#pragma mark - Initializations
// ITBlockActionSheet 初始化方法
- (id)initWithTitle:(NSString *)title 
      blockDelegate:(id<ITBlockActionSheetDelegate>)blockDelegate 
  cancelButtonTitle:(NSString *)cancelButtonTitle 
onCancelButtonClickedBlock:(ITBlockActionSheetVoidBlock)cancelButtonClickedBlock 
destructiveButtonTitle:(NSString *)destructiveButtonTitle 
onDestructiveButtonClickedBlock:(ITBlockActionSheetButtonBlock)destructiveButtonClickedBlock 
  otherButtonTitles:(NSArray *)otherButtonTitles 
onButtonClickedBlock:(ITBlockActionSheetButtonBlock)buttonClickedBlock 
{
    // 使用父類別 UIActionSheet 的初始化方法
    self = [super initWithTitle:title
                       delegate:self
              cancelButtonTitle:cancelButtonTitle
         destructiveButtonTitle:destructiveButtonTitle
              otherButtonTitles:nil];
    
    // 初始化其他按鈕的標題
    for (NSString *buttonTitle in otherButtonTitles) {
        [self addButtonWithTitle:buttonTitle];
    }
    
    // 初始化主要變數
    _blockDelegate = blockDelegate;
    _cancelButtonClickedBlock = cancelButtonClickedBlock;
    _destructiveButtonClickedBlock = destructiveButtonClickedBlock;
    _buttonClickedBlock = buttonClickedBlock;
    
    // 初始化其他變數
    _cancelBlock = nil;
    _willPresentBlock = nil;
    _didPresentBlock = nil;
    _willDismissBlock = nil;
    _didDissmissBlock = nil;
    
    // 初始化自動關閉的變數
    _autoDismissBlock = nil;
    _autoDismissInterval = 0.0f;
    return self;
}

- (id)initWithTitle:(NSString *)title 
      blockDelegate:(id<ITBlockActionSheetDelegate>)blockDelegate 
  cancelButtonTitle:(NSString *)cancelButtonTitle 
onCancelButtonClickedBlock:(ITBlockActionSheetVoidBlock)cancelButtonClickedBlock 
destructiveButtonTitle:(NSString *)destructiveButtonTitle 
onDestructiveButtonClickedBlock:(ITBlockActionSheetButtonBlock)destructiveButtonClickedBlock 
{
    return [self initWithTitle:title 
                 blockDelegate:blockDelegate 
             cancelButtonTitle:cancelButtonTitle 
    onCancelButtonClickedBlock:cancelButtonClickedBlock
        destructiveButtonTitle:destructiveButtonTitle
onDestructiveButtonClickedBlock:destructiveButtonClickedBlock
             otherButtonTitles:nil
          onButtonClickedBlock:nil]; 
}

- (id)initWithTitle:(NSString *)title 
      blockDelegate:(id<ITBlockActionSheetDelegate>)blockDelegate 
  cancelButtonTitle:(NSString *)cancelButtonTitle 
onCancelButtonClickedBlock:(ITBlockActionSheetVoidBlock)cancelButtonClickedBlock 
  otherButtonTitles:(NSArray *)otherButtonTitles 
onButtonClickedBlock:(ITBlockActionSheetButtonBlock)buttonClickedBlock 
{
    return [self initWithTitle:title 
                 blockDelegate:blockDelegate 
             cancelButtonTitle:cancelButtonTitle 
    onCancelButtonClickedBlock:cancelButtonClickedBlock
        destructiveButtonTitle:nil
onDestructiveButtonClickedBlock:nil
             otherButtonTitles:otherButtonTitles
          onButtonClickedBlock:buttonClickedBlock]; 
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
// - 自動關閉功能將於 ITBlockActionSheet 顯示後開始倒數，因此在顯示後便不允許再修改等待秒數
// - 當 ITBlockActionSheet 尚未顯示時回傳 YES, 否則回傳 NO
- (BOOL)canSetAutoDismissInterval
{
    return (self.visible == NO);
}

// 設定自動關閉的等待秒數, 回傳設定是否成功
// - 自動關閉功能將於 ITBlockAlertView 顯示後開始倒數，因此必須在 ITBlockAlertView 尚未顯示前才允許設定
// - 設定成功時回傳 YES, 否則回傳 NO
- (BOOL)setAutoDismissInterval:(NSTimeInterval)autoDismissInterval
{
    return [self setAutoDismissInterval:autoDismissInterval withAutoDismissBlock:nil];
}

// 設定自動關閉的等待秒數及自動關閉時要執行的 Block
// - 自動關閉功能將於 ITBlockAlertView 顯示後開始倒數，因此必須在 ITBlockAlertView 尚未顯示前才允許設定
// - 設定成功時回傳 YES, 否則回傳 NO
- (BOOL)setAutoDismissInterval:(NSTimeInterval)autoDismissInterval withAutoDismissBlock:(ITBlockActionSheetVoidBlock)autoDismissBlock
{
    BOOL success = [self canSetAutoDismissInterval];
    if (success) {
        _autoDismissBlock = autoDismissBlock;
        _autoDismissInterval = autoDismissInterval;
    }
    return success;
}


#pragma mark - UIActionSheetDelegate Methods
// 即將顯示時執行的 Block
- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
    // 即將顯示時執行 Block 並回應給委派對象
    if (_willPresentBlock != nil) {
        _willPresentBlock();
    }
    
    if ([_blockDelegate respondsToSelector:@selector(willPresentBlockActionSheet:)]) {
        [_blockDelegate willPresentBlockActionSheet:self];
    }
}

// 已經顯示時執行的 Block
- (void)didPresentActionSheet:(UIActionSheet *)actionSheet
{
    // 已經顯示時執行 Block 並回應給委派對象
    if (_didPresentBlock != nil) {
        _didPresentBlock();
    }
    
    if ([_blockDelegate respondsToSelector:@selector(didPresentBlockActionSheet:)]) {
        [_blockDelegate didPresentBlockActionSheet:self];
    }
}

// 即將關閉時執行的 Block
- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    // 即將關閉時執行 Block 並回應給委派對象
    if (_willDismissBlock != nil) {
        _willDismissBlock(buttonIndex);
    }
    
    if ([_blockDelegate respondsToSelector:@selector(blockActionSheet:willDismissWithButtonIndex:)]) {
        [_blockDelegate blockActionSheet:self willDismissWithButtonIndex:buttonIndex];
    }
}

// 已經關閉時執行的 Block
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    // 已經關閉時執行 Block 並回應給委派對象
    if (_didDissmissBlock != nil) {
        _didDissmissBlock(buttonIndex);
    }
    
    if ([_blockDelegate respondsToSelector:@selector(blockActionSheet:didDismissWithButtonIndex:)]) {
        [_blockDelegate blockActionSheet:self didDismissWithButtonIndex:buttonIndex];
    }
}

// 任一按鈕被按下時執行的 Block
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // 按下「取消按鈕」時執行 Block 並回應給委派對象
    if (buttonIndex == self.cancelButtonIndex) {
        if (_cancelButtonClickedBlock != nil) {
            _cancelButtonClickedBlock();
        }
        
        if ([_blockDelegate respondsToSelector:@selector(blockActionSheetCancelButtonClicked:)]) {
            [_blockDelegate blockActionSheetCancelButtonClicked:self];
        }
        
    // 按下「Destructive 按鈕」時執行 Block 並回應給委派對象
    } else if (buttonIndex == self.destructiveButtonIndex) {
        if (_destructiveButtonClickedBlock != nil) {
            _destructiveButtonClickedBlock();
        }
        
        if ([_blockDelegate respondsToSelector:@selector(blockActionSheetDestructiveButtonClicked:)]) {
            [_blockDelegate blockActionSheetDestructiveButtonClicked:self];
        }
    }
    
    // 按下任一按鈕時執行 Block 並回應給委派對象
    if (_buttonClickedBlock != nil) {
        _buttonClickedBlock(buttonIndex);
    }
    
    if ([_blockDelegate respondsToSelector:@selector(blockActionSheet:clickedButtonAtIndex:)]) {
        [_blockDelegate blockActionSheet:self clickedButtonAtIndex:buttonIndex];
    }
}

// 取消時執行的 Block
// - 注意此處並非指「使用者按下取消按鈕」
- (void)actionSheetCancel:(UIActionSheet *)actionSheet
{
    // 取消時執行 Block 並回應給委派對象
    if (_cancelBlock != nil) {
        _cancelBlock();
    }
    
    if ([_blockDelegate respondsToSelector:@selector(blockActionSheetCancel:)]) {
        [_blockDelegate blockActionSheetCancel:self];
    }
}


#pragma mark - Override Methods
// 覆寫父類別的 ShowInView 方法
- (void)showInView:(UIView *)view
{
    // 先呼叫父類別的 showInView 方法完成基本的動作
    [super showInView:view];
    
    // 若有設定自動閉關則啟用計時器
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
#pragma mark ITBlockActionSheet (PrivateMethods)
@implementation ITBlockActionSheet (PrivateMethods)


#pragma mark - Auto Dismiss Methods
- (void)autoDismissTimer:(NSTimer *)timer
{
    if (self.visible == YES) {
        if (_autoDismissBlock != nil) {
            _autoDismissBlock();
        }
        
        [self dismissWithClickedButtonIndex:-1 animated:YES];
        
        if ([_blockDelegate respondsToSelector:@selector(blockActionSheetDidAutoDismiss:)]) {
            [_blockDelegate blockActionSheetDidAutoDismiss:self];
        }
    }
    
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
}
@end