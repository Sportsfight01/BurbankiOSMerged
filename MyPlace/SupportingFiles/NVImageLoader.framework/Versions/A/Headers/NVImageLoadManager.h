//
//  NVImageLoadManager.h
//  NVImageLoad
//
//  Created by NARAYANA-IOS on 03/07/15.
//  Copyright (c) 2015 NARAYANA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NVImageCache.h"
#import "NVImageDownloadOperation.h"

typedef NS_OPTIONS(NSUInteger, NVImageLoadOptions) {
    /**
     * By default, when a URL fail to be downloaded, the URL is blacklisted so the library won't keep trying.
     * This flag disable this blacklisting.
     */
    NVImageLoadRetryFailed = 1 << 0,
    
    /**
     * By default, image downloads are started during UI interactions, this flags disable this feature,
     * leading to delayed download on UIScrollView deceleration for instance.
     */
    NVImageLoadLowPriority = 1 << 1,
    
    /**
     * This flag disables on-disk caching
     */
    NVImageLoadCacheMemoryOnly = 1 << 2,
    
    /**
     * This flag enables progressive download, the image is displayed progressively during download as a browser would do.
     * By default, the image is only displayed once completely downloaded.
     */
    NVImageLoadProgressiveDownload = 1 << 3,
    
    /**
     * Even if the image is cached, respect the HTTP response cache control, and refresh the image from remote location if needed.
     * The disk caching will be handled by NSURLCache instead of NVImageLoad leading to slight performance degradation.
     * This option helps deal with images changing behind the same request URL, e.g. Facebook graph api profile pics.
     * If a cached image is refreshed, the completion block is called once with the cached image and again with the final image.
     *
     * Use this flag only if you can't make your URLs static with embeded cache busting parameter.
     */
    NVImageLoadRefreshCached = 1 << 4,
    
    /**
     * In iOS 4+, continue the download of the image if the app goes to background. This is achieved by asking the system for
     * extra time in background to let the request finish. If the background task expires the operation will be cancelled.
     */
    NVImageLoadContinueInBackground = 1 << 5,
    
    /**
     * Handles cookies stored in NSHTTPCookieStore by setting
     * NSMutableURLRequest.HTTPShouldHandleCookies = YES;
     */
    NVImageLoadHandleCookies = 1 << 6,
    
    /**
     * Enable to allow untrusted SSL ceriticates.
     * Useful for testing purposes. Use with caution in production.
     */
    NVImageLoadAllowInvalidSSLCertificates = 1 << 7,
    
    /**
     * By default, image are loaded in the order they were queued. This flag move them to
     * the front of the queue and is loaded immediately instead of waiting for the current queue to be loaded (which
     * could take a while).
     */
    NVImageLoadHighPriority = 1 << 8,
    
    /**
     * By default, placeholder images are loaded while the image is loading. This flag will delay the loading
     * of the placeholder image until after the image has finished loading.
     */
    NVImageLoadDelayPlaceholder = 1 << 9,
    
    /**
     * We usually don't call transformDownloadedImage delegate method on animated images,
     * as most transformation code would mangle it.
     * Use this flag to transform them anyway.
     */
    NVImageLoadTransformAnimatedImage = 1 << 10,
    
    /**
     * By default, image is added to the imageView after download. But in some cases, we want to
     * have the hand before setting the image (apply a filter or add it with cross-fade animation for instance)
     * Use this flag if you want to manually set the image in the completion when success
     */
    NVImageLoadAvoidAutoSetImage = 1 << 11
};

typedef void(^NVImageLoadCompletionBlock)(UIImage *image, NSError *error, NVImageCacheType cacheType, NSURL *imageURL);

typedef void(^NVImageLoadCompletionWithFinishedBlock)(UIImage *image, NSError *error, NVImageCacheType cacheType, BOOL finished, NSURL *imageURL);

typedef NSString *(^NVImageLoadCacheKeyFilterBlock)(NSURL *url);


@class NVImageLoadManager;

@protocol NVImageLoadManagerDelegate <NSObject>

@optional

/**
 * Controls which image should be downloaded when the image is not found in the cache.
 *
 * @param imageManager The current `NVImageLoadManager`
 * @param imageURL     The url of the image to be downloaded
 *
 * @return Return NO to prevent the downloading of the image on cache misses. If not implemented, YES is implied.
 */
- (BOOL)imageManager:(NVImageLoadManager *)imageManager shouldDownloadImageForURL:(NSURL *)imageURL;

/**
 * Allows to transform the image immediately after it has been downloaded and just before to cache it on disk and memory.
 * NOTE: This method is called from a global queue in order to not to block the main thread.
 *
 * @param imageManager The current `NVImageLoadManager`
 * @param image        The image to transform
 * @param imageURL     The url of the image to transform
 *
 * @return The transformed image object.
 */
- (UIImage *)imageManager:(NVImageLoadManager *)imageManager transformDownloadedImage:(UIImage *)image withURL:(NSURL *)imageURL;

@end

/**
 * The NVImageLoadManager is the class behind the UIImageView+WebCache category and likes.
 * It ties the asynchronous downloader (NVImageLoadDownloader) with the image cache store (SDImageCache).
 * You can use this class directly to benefit from web image downloading with caching in another context than
 * a UIView.
 *
 * Here is a simple example of how to use NVImageLoadManager:
 *
 * @code
 
 NVImageLoadManager *manager = [NVImageLoadManager sharedManager];
 [manager downloadImageWithURL:imageURL
 options:0
 progress:nil
 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
 if (image) {
 // do something with image
 }
 }];
 
 * @endcode
 */

@interface NVImageLoadManager : NSObject

@property (weak, nonatomic) id <NVImageLoadManagerDelegate> delegate;

@property (strong, nonatomic, readonly) NVImageCache *imageCache;
@property (strong, nonatomic, readonly) NVImageDownloader *imageDownloader;

/**
 * The cache filter is a block used each time NVImageLoadManager need to convert an URL into a cache key. This can
 * be used to remove dynamic part of an image URL.
 *
 * The following example sets a filter in the application delegate that will remove any query-string from the
 * URL before to use it as a cache key:
 *
 * @code
 
 [[NVImageLoadManager sharedManager] setCacheKeyFilter:^(NSURL *url) {
 url = [[NSURL alloc] initWithScheme:url.scheme host:url.host path:url.path];
 return [url absoluteString];
 }];
 
 * @endcode
 */
@property (nonatomic, copy) NVImageLoadCacheKeyFilterBlock cacheKeyFilter;

/**
 * Returns global NVImageLoadManager instance.
 *
 * @return NVImageLoadManager shared instance
 */
+ (NVImageLoadManager *)sharedManager;

/**
 * Downloads the image at the given URL if not present in cache or return the cached version otherwise.
 *
 * @param url            The URL to the image
 * @param options        A mask to specify options to use for this request
 * @param progressBlock  A block called while image is downloading
 * @param completedBlock A block called when operation has been completed.
 *
 *   This parameter is required.
 *
 *   This block has no return value and takes the requested UIImage as first parameter.
 *   In case of error the image parameter is nil and the second parameter may contain an NSError.
 *
 *   The third parameter is an `NVImageCacheType` enum indicating if the image was retrived from the local cache
 *   or from the memory cache or from the network.
 *
 *   The last parameter is set to NO when the NVImageLoadProgressiveDownload option is used and the image is
 *   downloading. This block is thus called repetidly with a partial image. When image is fully downloaded, the
 *   block is called a last time with the full image and the last parameter set to YES.
 *
 * @return Returns an NSObject conforming to NVImageLoadOperation. Should be an instance of NVImageLoadDownloaderOperation
 */
- (id <NVImageOperation>)downloadImageWithURL:(NSURL *)url
                                         options:(NVImageLoadOptions)options
                                        progress:(NVImageLoadDownloaderProgressBlock)progressBlock
                                       completed:(NVImageLoadCompletionWithFinishedBlock)completedBlock;

/**
 * Saves image to cache for given URL
 *
 * @param image The image to cache
 * @param url   The URL to the image
 *
 */

- (void)saveImageToCache:(UIImage *)image forURL:(NSURL *)url;

/**
 * Cancel all current opreations
 */
- (void)cancelAll;

/**
 * Check one or more operations running
 */
- (BOOL)isRunning;

/**
 *  Check if image has already been cached
 *
 *  @param url image url
 *
 *  @return if the image was already cached
 */
- (BOOL)cachedImageExistsForURL:(NSURL *)url;

/**
 *  Check if image has already been cached on disk only
 *
 *  @param url image url
 *
 *  @return if the image was already cached (disk only)
 */
- (BOOL)diskImageExistsForURL:(NSURL *)url;

/**
 *  Async check if image has already been cached
 *
 *  @param url              image url
 *  @param completionBlock  the block to be executed when the check is finished
 *
 *  @note the completion block is always executed on the main queue
 */
- (void)cachedImageExistsForURL:(NSURL *)url
                     completion:(NVImageLoadCheckCacheCompletionBlock)completionBlock;

/**
 *  Async check if image has already been cached on disk only
 *
 *  @param url              image url
 *  @param completionBlock  the block to be executed when the check is finished
 *
 *  @note the completion block is always executed on the main queue
 */
- (void)diskImageExistsForURL:(NSURL *)url
                   completion:(NVImageLoadCheckCacheCompletionBlock)completionBlock;


/**
 *Return the cache key for a given URL
 */
- (NSString *)cacheKeyForURL:(NSURL *)url;

@end

