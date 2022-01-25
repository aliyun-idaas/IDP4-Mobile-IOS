//
//  NoPasswordLoginSDK.h
//  NoPasswordSDK
//
//  Created by 九州云腾 on 2018/12/14.
//  Copyright © 2018 九州云腾. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef void (^SuccessBlock)(NSDictionary *resultDic);
typedef void (^FailureBlock)(NSDictionary *errorDic);
typedef void (^CompleteBlock)(BOOL success);
typedef void (^CLCompleteBlock)(NSDictionary *resultDic);
@interface NoPasswordLoginSDK : NSObject

/**
 * @brief 初始化接口.
 * @param IDPServerURL IDP4地址.
 * @param appKey 公司的appKey.
 * @param appSecret 公司的appSecret.
 * @param enterpriseId 公司的enterpriseId.
 * @param aes256Key 公司的aes256Key.如果当前版本没有可以填空
 * @param ignoreCertificateVerify 是否忽略https 请求的服务器端证书验证
 */
- (id)initWithIDPServerURL:(NSString *)IDPServerURL appKey:(NSString *)appKey appSercert:(NSString *)appSecret enterpriseId:(NSString *)enterpriseId AES256Key:(NSString *)aes256Key ignoreCertificateVerify:(BOOL)ignoreCertificateVerify;

+ (instancetype)shareInstance;
/**
 * @brief U+P下载证书.
 * @param username 用户名.
 * @param pwd 密码.
 **/
-(void)DownLoadCertificateByPwdWithUsername:(NSString *)username pwd:(NSString *)pwd success:(SuccessBlock )success failure:(FailureBlock )failure;
/**
 * @brief 指纹免密登录.
 **/
-(void)FingerprintLoginWithSuccess:(SuccessBlock )success failure:(FailureBlock )failure;
/**
 * @brief 免密登录
 **/
-(void)VertifyId_tokenWithSuccess:(SuccessBlock )success failure:(FailureBlock )failure;

/**
 * @brief 获取登录短信码
 * @param username 用户名.
 * @param phoneNumber 电话号码.
 **/
-(void)getSMSCodeWithUsername:(NSString *)username phoneNumber:(NSString *)phoneNumber success:(SuccessBlock )success failure:(FailureBlock )failure;

/**
 * @brief 短信登录接口
 * @param username 用户名.
 * @param smsCode 短信码
 **/
-(void)loginWithUsername:(NSString *)username smsCode:(NSString *)smsCode success:(SuccessBlock )success failure:(FailureBlock )failure;
/**
 * @brief 获取动态口令OTP Code.
 * @param secret 密钥.
 * @param digits 长度,一般6位.
 * @param period 更换时间间隔,一般30秒.
 **/
+(NSString *)getOtpCodeWithSecret:(NSString *)secret digits:(NSInteger )digits period:(NSTimeInterval )period;
/**
 * @brief 解密二维码接口.
 * @param content 需要解密的二维码数据.
 **/
+(NSDictionary *)DecryptQRCodeiInformationWithContent:(NSString *)content;
/**
 * @brief 判断证书是否存在.
 **/
+(BOOL)isExistCertificate;
/**
 * @brief u+p登录IDP4
 * @param username 用户名.
 * @param password 密码.
 **/
- (void)loginWthUsername:(NSString *)username password:(NSString *)password success:(SuccessBlock)completionBlock failure:(FailureBlock)failureBlock;
/**
 * @brief 获取应用列表接口.
 * @param access_token 登录返回的accesstoken.
 */
-(void)getApplicationListWithAccessToken:(NSString *)access_token success:(SuccessBlock)completionBlock failure:(FailureBlock)failureBlock;
/**
 * @brief 用户token刷新
 * @param refreshToken 登录返回的refreshToken.
 */
- (void)refreshTokenWithToken:(NSString *)refreshToken success:(SuccessBlock)completionBlock failure:(FailureBlock)failureBlock;
/**
 * @brief 扫码登录IDP4.
 * @param verifyCode 解密二维码获取.
 * @param accessToken 登录返回的accesstoken.
 **/
-(void)sendCodeWithVerifyCode:(NSString *)verifyCode accessToken:(NSString *)accessToken success:(SuccessBlock )success failure:(FailureBlock )failure;
/**
* @brief 获取实人认证配置.
* @param access_token 登录成功后获取的accessToken值.
*/
-(void)aliyunGetConfigWithToken:(NSString *)access_token success:(SuccessBlock)completionBlock failure:(FailureBlock)failureBlock;
/**
* @brief 检查是否实人.
* @param access_token 登录成功后获取的accessToken值.
*/
-(void)aliyunCheckUserRealPerson:(NSString *)access_token success:(SuccessBlock)completionBlock failure:(FailureBlock)failureBlock;
/**
 * @brief step-1获取实人认证token,过此接口获取阿里云SDK需要的verifyToken.
 * @param username 用户名.
 * @param access_token 登录成功后获取的accessToken值.
 */
-(void)aliyunGet_tokenWithUsername:(NSString *)username accessToken:(NSString *)access_token success:(SuccessBlock)completionBlock failure:(FailureBlock)failureBlock;
/**
 * @brief step-2在阿里SDK实人成功后调用，实人认证结束后保存对应的用户实人信息，便于后面做活体认证.
 * @param bizId 实人认证请求的唯一标识.
 * @param access_token 登录成功后获取的accessToken值.
 */
-(void)aliyunQuery_statusWithAccessToken:(NSString *)access_token bizId:(NSString *)bizId success:(SuccessBlock)completionBlock failure:(FailureBlock)failureBlock;
/**
 * @brief step-3人脸活体认证开始,通过此接口获取阿里云SDK需要的verifyToken.
 * @param userId 用户的唯一标识,登录成功后获取.
 * @param access_token 登录成功后获取的accessToken值.
 */
-(void)aliyunStartFaceVertifyWithAccessToken:(NSString *)access_token userId:(NSString *)userId success:(SuccessBlock)completionBlock failure:(FailureBlock)failureBlock;
@end

