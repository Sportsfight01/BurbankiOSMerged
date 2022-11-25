//
//  NSString+Validations.h
//  BurbankApp
//
//  Created by Mohan Kumar on 22/12/16.
//  Copyright © 2016 DMSS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface NSString (Validations)

+(NSString *)checkNullValue:(NSString *)inputValue;

+(NSString *)priceFormat:(int)price;

+(float)checkIntegerNull:(id)value;

@end
