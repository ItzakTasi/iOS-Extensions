//
//  AVCaptureDeviceHelper.m
//  Extensions
//
//  Created by Itzak Tasi on 12/2/24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AVCaptureDeviceHelper.h"

#pragma mark -
#pragma mark Private Interfaces
@interface AVCaptureDeviceHelper (PrivateMethods)
// 根據指定位置取得對應的相機裝置
- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position;
@end


#pragma mark -
#pragma mark AVCaptureDeviceHelper
@implementation AVCaptureDeviceHelper


#pragma mark - Properties


#pragma mark - Initialization
// AVCaptureDevice 初始化方法
- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization here.
    }
    return self;
}


#pragma mark - Camera Device Methods
// 取得預設的相機裝置
- (AVCaptureDevice *)defaultCamera
{
    return [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
}

// 後置相機
- (AVCaptureDevice *)backCamera
{
    return [self cameraWithPosition:AVCaptureDevicePositionBack];   
}

// 後置相機是否可使用
- (BOOL)backCameraAvailable
{
    return ([self backCamera] != nil);
}

// 前置相機
- (AVCaptureDevice *)frontCamera
{
    return [self cameraWithPosition:AVCaptureDevicePositionFront];   
}

// 前置相機是否可使用
- (BOOL)frontCameraAvailable
{
    return ([self frontCamera] != nil);
}


#pragma mark - Audio Device Methods
// 預設的音訊裝置
- (AVCaptureDevice *)defaultAudioDevice
{
    return [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
}

- (AVCaptureDevice *)audioDevice
{
    NSArray *audioDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio];
    if (audioDevices.count > 0) {
        return [audioDevices objectAtIndex:0];
    }
    return nil;
}

- (BOOL)audioDeviceAvailable
{
    return ([self audioDevice] != nil);
}


#pragma mark - Devices Count Methods
// 相機裝置數量
- (NSUInteger)numberOfCameras
{
    NSArray *cameraDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    return cameraDevices.count;
}

// 音訊裝置數量
- (NSUInteger)numberOfAudioDevices
{
    NSArray *audioDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio];
    return audioDevices.count;
}

@end


#pragma mark -
#pragma mark AVCaptureDeviceHelper (PrivateMethods)
@implementation AVCaptureDeviceHelper (PrivateMethods)
// 根據指定位置取得對應的相機裝置
- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position
{
    NSArray *cameraDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *camera in cameraDevices) {
        if (camera.position == position) {
            return camera;
        }
    }
    return nil;
}
@end