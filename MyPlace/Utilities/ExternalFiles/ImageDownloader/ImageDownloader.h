//
//  ImageDownloader.h
//  REQUIRED
//
//  Created by NARAYANA-IOS on 06/11/14.
//  Copyright (c) 2014 Neuv Media Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

//#import <NVImageLoader/NVImageLoader.h>
//#import <NVImageLoader/NVImageOperation.h>


typedef void(^ImageDownloadBlock)(UIImage *image, BOOL status , NSError *error);

typedef void(^ImageProgressBlock)(CGFloat currentProgress);

@interface ImageDownloader : NSObject

@property (nonatomic, copy) ImageDownloadBlock imageDownloadBlock;

@property (nonatomic, copy) ImageProgressBlock imageProgressBlock;

/*
 *  Image downloading with using dispatch queue
 *  Its Exepecting Download url and saved filepath.
 *  Returns the image block with donload ststus and error
 *  Retuns the download progress if we implemented.
 */

+ (void) downloadImageWithUrl:(NSString*)url withFilePath:(NSString*)filePath  withBlock:(void (^)(UIImage *image, BOOL status , NSError *error))block withProgress:(void (^)(CGFloat currentProgress))blockProgress;

/**
 *  @author Paradigm
 *
 *  Store image in cache with url
 *
 *  @param image image from gallry or camera
 *  @param key   after upload url fro saving
 */

+ (void)storeImage:(UIImage *)image forKey:(NSString *)key;



+ (void)removeImageForKey:(NSString *)key completion:(void(^)(void))completion;

+ (UIImage *)imageFromMemoryCacheForKey:(NSString *)key;


@end
