//
//  ViewController.m
//  IDP_Demo
//
//  Created by 九州云腾 on 2019/11/14.
//  Copyright © 2019 九州云腾. All rights reserved.
//

#import "ViewController.h"
#import <NoPasswordSDK/NoPasswordLoginSDK.h>
#import "GestureUnlockViewController.h"

#define  IDP_SERVER_URL @"https://sdp.abm.idsmanager.com"
#define  ENTERPRISE_ID @"sdp"
#define  APP_KEY @"d59ad3f4b5218c259e0e9461dc42b076CEkuxSZrQw6"
#define  APP_SECRET @"9Xql4E9tb9YcPF9pBEMYwjEQVdDUmlDWZ2CCXdqGQN"

#define  ALIYUN_ACCESS_TOKEN @"NeedtoRequest_From_IDP_manufacturer"

@interface ViewController ()

@property (nonatomic,strong)NoPasswordLoginSDK *sdkInstacne;
@property (nonatomic, weak) IBOutlet UIButton *lastButton;
@property (nonatomic, weak) IBOutlet UIScrollView *containerView;

@property (nonatomic, weak) IBOutlet UITextField *username;
@property (nonatomic, weak) IBOutlet UITextField *password;
@property (nonatomic, weak) IBOutlet UITextField *phoneNumber;
@property (nonatomic, weak) IBOutlet UITextField *verifyCode;

@property (nonatomic,strong) NSString *refreshToken;
@property (nonatomic,strong) NSString *access_token;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //NSLog(@"%d",[NoPasswordLoginSDK saveCertificate:@{}]);
    // Do any additional setup after loading the view.
    
    [self initSDK];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSInteger contentHeight = self.lastButton.frame.origin.y + self.lastButton.frame.size.height +10;
    
    if (self.containerView.contentSize.height  != contentHeight) {
        self.containerView.contentSize = CGSizeMake(self.containerView.frame.size.width, contentHeight);
    }
}

- (void)initSDK {

    self.sdkInstacne = [[NoPasswordLoginSDK alloc]initWithIDPServerURL:IDP_SERVER_URL appKey:APP_KEY appSercert:APP_SECRET enterpriseId:ENTERPRISE_ID AES256Key:@"6okEqYkEs8N64q3q" ignoreCertificateVerify:YES];
    
}
- (IBAction)loginWithUsernamePassword:(id)sender {
    [self resignResponderFromTextField];
    
    if (self.username.text.length == 0 || self.password.text.length == 0) {
        [self showAlert:@"用户名或密码为空, 请填写。" needInput:NO];
        return;
    }
    __weak typeof(self) wself = self;
    [self.sdkInstacne loginWthUsername:self.username.text  password:self.password.text success:^(NSDictionary *resultDic) {
        
        wself.refreshToken = resultDic[@"data"][@"accessTokenDto"][@"refreshToken"];
        wself.access_token = resultDic[@"data"][@"accessTokenDto"][@"accessToken"];
        [self showAlert:@"用户名或密码登录成功。" needInput:NO];

    } failure:^(NSDictionary *errorDic) {

        [self showAlert:@"用户名或密码登录失败。" needInput:NO];
    }];
}



- (IBAction)refreshToken:(id)sender {
    [self resignResponderFromTextField];
    if (self.refreshToken.length == 0) {
        [self showAlert:@"refreshtoken 为空，无法刷新token, 需要重新登录。" needInput:NO];
        return;
    }
    [self.sdkInstacne refreshTokenWithToken:self.refreshToken success:^(NSDictionary *resultDic) {
        NSLog(@"成功 %@",resultDic);
    } failure:^(NSDictionary *errorDic) {
        NSLog(@"失败 %@",errorDic);
    }];
}

- (IBAction)isRealPersonAuthOpen:(id)sender {

    [self resignResponderFromTextField];
    [self.sdkInstacne aliyunGetConfigWithToken:self.access_token success:^(NSDictionary *resultDic) {
        NSLog(@"成功 %@",resultDic);
        
        [self showAlert:@"实人配置开启。" needInput:NO];
    } failure:^(NSDictionary *errorDic) {
        NSLog(@"失败 %@",errorDic);
        [self showAlert: [NSString stringWithFormat:@"实人配置未开启, 错误信息 %@。", errorDic[@"message"]] needInput:NO];
    }];
}

- (IBAction)checkRealPerson:(id)sender {
    
    [self resignResponderFromTextField];
    
    [self.sdkInstacne aliyunCheckUserRealPerson:self.access_token success:^(NSDictionary *resultDic) {
        NSLog(@"成功 %@",resultDic);
        [self showAlert:@"实人认证成功。" needInput:NO];
    } failure:^(NSDictionary *errorDic) {
        NSLog(@"失败 %@",errorDic);
        [self showAlert: [NSString stringWithFormat:@"实人认证失败, 错误信息 %@。", errorDic[@"message"]] needInput:NO];
    }];
}

- (IBAction)StartFaceVertify:(id)sender {
    [self resignResponderFromTextField];
    
    [self.sdkInstacne aliyunStartFaceVertifyWithAccessToken:self.access_token userId:@"userId" success:^(NSDictionary *resultDic) {
        NSLog(@"成功 %@",resultDic);
        [self showAlert:@"人脸活体验证成功。" needInput:NO];
    } failure:^(NSDictionary *errorDic) {
        NSLog(@"失败 %@",errorDic);
        [self showAlert: [NSString stringWithFormat:@"人脸活体验证失败, 错误信息 %@。", errorDic[@"message"]] needInput:NO];
    }];
}

- (IBAction)downloadCertificate:(id)sender {

    [self resignResponderFromTextField];
    
    if (self.username.text.length == 0 || self.password.text.length == 0) {
        [self showAlert:@"用户名或密码为空, 请填写。" needInput:NO];
        return;
    }
    
    [self.sdkInstacne DownLoadCertificateByPwdWithUsername:self.username.text pwd:self.password.text success:^(NSDictionary *resultDic) {
        [self showAlert:@"用户名或密码下载证书成功。" needInput:NO];

    } failure:^(NSDictionary *errorDic) {

        [self showAlert:@"用户名或密码下载证书失败。" needInput:NO];
    }];
}

- (IBAction)isCertificateExisted:(id)sender {
    [self resignResponderFromTextField];
    
    BOOL existed = [NoPasswordLoginSDK isExistCertificate];
    [self showAlert: [NSString stringWithFormat:@"证书是否存在: %@", @(existed) ] needInput:NO];
}

- (IBAction)LoginWithCertificate:(id)sender {
    [self resignResponderFromTextField];
    
    if (![NoPasswordLoginSDK isExistCertificate]) {
        [self showAlert:@"证书不存在，无法通过证书登录。" needInput:NO];
        return;
    }
    
    [self.sdkInstacne VertifyId_tokenWithSuccess:^(NSDictionary *resultDic) {
        NSLog(@"证书免登成功 %@",resultDic);
        [self showAlert: @"证书免登成功"  needInput:NO];
    } failure:^(NSDictionary *resultDic) {
        NSLog(@"证书免登失败 %@",resultDic);
        [self showAlert: @"证书免登失败"  needInput:NO];
    }];
}

- (IBAction)obtainSmsCaptcha:(id)sender {
    
    [self resignResponderFromTextField];
    
    if (self.username.text.length == 0) {
        [self showAlert:@"需要填写用户名" needInput:NO];
    }
    else if (self.phoneNumber.text.length == 0) {
        [self showAlert:@"需要填写电话号码" needInput:NO];
    }
    
    [self.sdkInstacne getSMSCodeWithUsername:self.username.text phoneNumber:self.phoneNumber.text  success:^(NSDictionary *resultDic) {
        NSLog(@"成功 %@",resultDic);
        [self showAlert:[NSString stringWithFormat:@"获取短信验证码成功: %@", resultDic[@"data"][@"code"]] needInput:NO];
       
    } failure:^(NSDictionary *errorDic) {
        NSLog(@"失败 %@",errorDic);
        [self showAlert:[NSString stringWithFormat:@"获取短信验证码失败: %@",  errorDic[@"message"]] needInput:NO];
    }];
}

- (IBAction)loginWithSmsCode:(id)sender {
    [self resignResponderFromTextField];
    
    [self.sdkInstacne loginWithUsername:self.username.text smsCode:self.verifyCode.text success:^(NSDictionary *resultDic) {
        NSLog(@"成功 %@",resultDic);
        [self showAlert:@"短信成功" needInput:NO];
       
    } failure:^(NSDictionary *errorDic) {
        NSLog(@"失败 %@",errorDic);
        [self showAlert:[NSString stringWithFormat:@"获取短信验证码失败: %@",  errorDic[@"message"]] needInput:NO];
    }];
    
}

- (IBAction)obtainOTPCode:(id)sender {
    [self resignResponderFromTextField];
    NSString *otp = [NoPasswordLoginSDK getOtpCodeWithSecret:APP_SECRET digits:6 period:30];
    [self showAlert: [NSString stringWithFormat:@"OTP: %@", otp ] needInput:NO];
    NSLog(@"OTP : %@",otp);
}

- (IBAction)decryptQRCode:(id)sender {
    [self resignResponderFromTextField];
    NSString *qr = @"{\"authKey\":\"9KE7bBa3bKkQqeZV\",\"info\":\"HoAFoViqbrQ2x3y6SyqEbMwYqhYZqDZ7xPpRoEF1F+BAZ/By9GlMvB8SyPvTmFVHA3EpSRigPumYm3AsTeMGHY987dyNbQs/KCtdYXJn00o=\"}";
    NSDictionary *decryptedContent = [NoPasswordLoginSDK DecryptQRCodeiInformationWithContent:qr];
    NSLog(@"二维码 : %@",decryptedContent);
}

- (IBAction)loginIDPWithQRCodeScan:(id)sender {
    
    [self resignResponderFromTextField];

    [self.sdkInstacne  sendCodeWithVerifyCode:@"{\"authKey\":\"9KE7bBa3bKkQqeZV\",\"info\":\"HoAFoViqbrQ2x3y6SyqEbMwYqhYZqDZ7xPpRoEF1F+BAZ/By9GlMvB8SyPvTmFVHA3EpSRigPumYm3AsTeMGHY987dyNbQs/KCtdYXJn00o=\"}" accessToken:self.access_token success:^(NSDictionary *resultDic) {
        [self showAlert: @"扫码登录IDP成功" needInput:NO];
    } failure:^(NSDictionary *errorDic) {
        [self showAlert: @"扫码登录IDP失败s" needInput:NO];
    }];
}

- (IBAction)obtainApplicationList:(id)sender {

    [self resignResponderFromTextField];
    
    [self.sdkInstacne getApplicationListWithAccessToken:self.access_token success:^(NSDictionary *resultDic) {
        NSLog(@"获取应用列表成功 %@",resultDic);
    } failure:^(NSDictionary *errorDic) {
        NSLog(@"获取应用列表失败 %@",errorDic);
    }];
}

- (IBAction)fingerprintLogin:(id)sender {
    [self resignResponderFromTextField];

    [self.sdkInstacne FingerprintLoginWithSuccess:^(NSDictionary *resultDic) {

        NSLog(@"%@",resultDic);
        [self showAlert:@"指纹解锁成功" needInput:NO];

    } failure:^(NSDictionary *errorDic) {

        [self showAlert:[NSString stringWithFormat: @"指纹解锁失败, %@", errorDic[@"message"]]  needInput:NO];
        NSLog(@"%@",errorDic);
    }];
    
}

- (IBAction)gesture:(id)sender {
    [self resignResponderFromTextField];
    GestureUnlockViewController *gesture = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"GestureUnlock"];
    gesture.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.navigationController pushViewController:gesture animated:YES];
}


#pragma -- mark utility method

- (void)showAlert:(NSString *)alertText needInput:(BOOL)needInput {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"IDP Demo" message:alertText preferredStyle:UIAlertControllerStyleAlert];
    if (needInput) {
        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = NSLocalizedString(@"TextPlaceholder", @"Text");
        }];
    }
    
    UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        // Do something after clicking OK button
        if (needInput) {
            UITextField *textField = alert.textFields.firstObject;
        }
    }];
    [alert addAction:okButton];

    [self presentViewController:alert animated:YES completion:nil];
}

- (void)resignResponderFromTextField {
    [self.username resignFirstResponder];
    [self.password resignFirstResponder];
    [self.phoneNumber resignFirstResponder];
    [self.verifyCode resignFirstResponder];
    
}

@end
