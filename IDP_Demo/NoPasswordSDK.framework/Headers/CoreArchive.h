

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface CoreArchive : NSObject

#pragma mark - 偏好类信息存储

/**
 *  本地保存手势密码
 */
+(void)setGesturePWD:(NSString *)str forkey:(NSString *)userId;

/**
 *  读取
 */
+(NSString *)getGesturePWDForkey:(NSString *)userId;

/**
 *  删除
 */
+(void)removeGesturePWDForkey:(NSString *)userId;



@end
