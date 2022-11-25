//
//  ImageDownloader.m
//  REQUIRED
//
//  Created by NARAYANA-IOS on 06/11/14.
//  Copyright (c) 2014 Neuv Media Pvt Ltd. All rights reserved.
//

#import "ImageDownloader.h"
#import <NVImageLoader/NVImageLoadManager.h>


@implementation ImageDownloader

/*
 *  Image downloading with using dispatch queue
 *  Its Exepecting Download url and saved filepath.
 *  Returns the image block with donload ststus and error
 *  Retuns the download progress if we implemented.
 */


//+ (void) downloadImageWithUrl:(NSString*)url withFilePath:(NSString*)filePath  withBlock:(void (^)(UIImage *image, BOOL status , NSError *error))block withProgress:(void (^)(CGFloat currentProgress))blockProgress{
//
//    if (url == nil && [url isEqualToString:@""]) {
//        if (block) {
//            block (nil,NO, nil);
//        }
//    }else{
//
//        [[NVImageLoadManager sharedManager]downloadImageWithURL:[NSURL URLWithString:url] options:NVImageLoadHighPriority progress:nil completed:^(UIImage *image, NSError *error, NVImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
//            if (finished && image != nil) {
//
//                if (block) {
//                    block (image,YES,nil);
//                }
//
//            }
//
//        }];
//
//    }
//
//}

+ (void) downloadImageWithUrl:(NSString*)url withFilePath:(NSString*)filePath  withBlock:(void (^)(UIImage *image, BOOL status , NSError *error))block withProgress:(void (^)(CGFloat currentProgress))blockProgress{
    
    if (url == nil && [url isEqualToString:@""]) {
        if (block) {
            block (nil,NO, nil);
        }
    }else{
        
        [[NVImageLoadManager sharedManager] downloadImageWithURL:[NSURL URLWithString:[ImageDownloader urlString:url]] options:NVImageLoadContinueInBackground progress:nil completed:^(UIImage *image, NSError *error, NVImageCacheType cacheType, BOOL finished, NSURL *imageURL) {

            if (finished && image != nil) {

                if (block) {
                    block (image, YES, nil);
                }
            }else {

                if (block) {
                    block (nil, NO ,error);
                }
            }

        }];

    }
    
}

+ (void)storeImage:(UIImage *)image forKey:(NSString *)key;
{
    [[NVImageCache sharedImageCache] storeImage:image forKey:[ImageDownloader urlString:key]];
}


+ (void)removeImageForKey:(NSString *)key completion:(void(^)(void))completion;
{
//    [[NVImageCache sharedImageCache] removeImageForKey:key fromDisk:YES withCompletion:^{
//        completion ();
//    }];
//
//    [[NVImageCache sharedImageCache] removeImageForKey:key withCompletion:^{
//
//        completion ();
//    }];
    
    [[NVImageCache sharedImageCache] removeImageForKey:[ImageDownloader urlString:key]];
    [[NVImageCache sharedImageCache] removeImageForKey:[ImageDownloader urlString:key] fromDisk:YES];

    
    __block int total = 3;
       __block int completed = 0;
       
       
       [[NVImageCache sharedImageCache] removeImageForKey:key fromDisk:NO withCompletion:^{
           completed = completed + 1;
           if (completed == total) {
               completion ();
           }
       }];
       
       [[NVImageCache sharedImageCache] removeImageForKey:key fromDisk:YES withCompletion:^{
           completed = completed + 1;
           if (completed == total) {
               completion ();
           }
       }];
       
       [[NVImageCache sharedImageCache] removeImageForKey:key withCompletion:^{
           completed = completed + 1;
           if (completed == total) {
               completion ();
           }
       }];
}


+ (UIImage *)imageFromMemoryCacheForKey:(NSString *)key;
{
    return [[NVImageCache sharedImageCache] imageFromMemoryCacheForKey: [ImageDownloader urlString:key]];

}


+(NSString *)urlString:(NSString *)string {
    
    return [string stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}


@end

