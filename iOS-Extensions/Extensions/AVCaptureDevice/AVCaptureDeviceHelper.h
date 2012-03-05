//
//  AVCaptureDeviceHelper.h
//  Extensions
//
//  Created by Itzak Tasi on 12/2/24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>


#pragma mark -
#pragma mark AVCaptureDeviceHelper
@interface AVCaptureDeviceHelper : NSObject
{
    
}


#pragma mark - Properties
// Add your custom properties here


#pragma mark - Camera Devices
// 取得預設的相機裝置
- (AVCaptureDevice *)defaultCamera;

// 取得後置相機裝置
- (AVCaptureDevice *)backCamera;

// 後置相機裝置是否可用
- (BOOL)backCameraAvailable;

// 取得前置相機裝置
- (AVCaptureDevice *)frontCamera;

// 前置相機裝置是否可用
- (BOOL)frontCameraAvailable;


#pragma mark - Audio Devices
// 取得預設的音效裝置
- (AVCaptureDevice *)defaultAudioDevice;

// 取得音效裝置
- (AVCaptureDevice *)audioDevice;

// 音效裝置是否可用
- (BOOL)audioDeviceAvailable;


#pragma mark - Devices Count
// 相機裝置的數量
- (NSUInteger)numberOfCameras;

// 音效裝置的數量
- (NSUInteger)numberOfAudioDevices;
@end
