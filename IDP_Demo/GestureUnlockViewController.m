//
//  GestureUnlockViewController.m
//  GestureUnlockViewSDK
//
//  Created by 九州云腾 on 2019/1/10.
//  Copyright © 2019 九州云腾. All rights reserved.
//

#import "GestureUnlockViewController.h"
#import <NoPasswordSDK/CoreArchive.h>
#import <NoPasswordSDK/CoreLockConst.h>
#import <NoPasswordSDK/CLLockView.h>
#import <NoPasswordSDK/CLLockLabel.h>
#import <NoPasswordSDK/NoPasswordLoginSDK.h>
@interface GestureUnlockViewController ()
@property (weak, nonatomic) IBOutlet CLLockView *lockView;
@property (weak, nonatomic) IBOutlet CLLockLabel *lockLabel;

@end

@implementation GestureUnlockViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.lockView.type = CoreLockTypeSetPwd;

    //根据手势点之间的距离,同时改变内圆和外圆的大小,距离越大圆越小
    
    [self changeViewAccordingToTyp:CoreLockTypeVerifyPwd];
    /*
     *  设置密码
     */

    /** 开始输入：第一次 */
    self.lockView.setPWBeginBlock = ^{

        [self.lockLabel showNormalMsg:CoreLockPWDTitleFirst];

    };
     /** 开始输入：确认 */
    self.lockView.setPWConfirmlock = ^{

        [self.lockLabel showNormalMsg:CoreLockPWDTitleConfirm];
    };
        /** 密码长度不够 */
    self.lockView.setPWSErrorLengthTooShortBlock = ^(NSUInteger currentCount) {

         [self.lockLabel showWarnMsg:[NSString stringWithFormat:@"为了提高新的账户安全，请连接至少%lu个点",(unsigned long)CoreLockMinItemCount]];

    };
    /** 两次密码不一致 */
    self.lockView.setPWSErrorTwiceDiffBlock = ^(NSString *pwd1, NSString *pwdNow) {


        [self.lockLabel showWarnMsg:CoreLockPWDDiffTitle];
        //绘制重新
        [self.lockView resetPwd];
    };
 /** 第一次输入密码：正确 */
    self.lockView.setPWFirstRightBlock = ^{

        [self.lockLabel showNormalMsg:CoreLockPWDTitleConfirm];

    };
     /** 再次输入密码一致 */
    self.lockView.setPWTwiceSameBlock = ^(NSString *pwd){

        [self.lockLabel showNormalMsg:CoreLockPWSuccessTitle];
        [CoreArchive setGesturePWD:pwd forkey:@"zhangsan"];
        //密码设置成功

    };
    /*
     *  验证密码
     */

    /** 开始 */
    self.lockView.verifyPWBeginBlock = ^{

        [self.lockLabel showNormalMsg:CoreLockVerifyNormalTitle];
    };
    /** 验证 */
    self.lockView.verifyPwdBlock = ^BOOL(NSString *pwd) {

         //取出本地密码
        NSString *pwdLocal = [CoreArchive getGesturePWDForkey:@"zhangsan"];
        if ([pwdLocal isEqualToString:pwd] ) {//密码一致
            if  (self.lockView.type == CoreLockTypeVerifyPwd) {

                [self.lockLabel showNormalMsg:CoreLockVerifySuccesslTitle];
                //密码验证成功,开发者执行自己的逻辑代码

            }else if (self.lockView.type == CoreLockTypeModifyPwd) { //修改密码

                 [self.lockLabel showNormalMsg:CoreLockPWDTitleFirst];

            }
            return YES;
        }else{//密码不一致

             [self.lockLabel showWarnMsg:CoreLockVerifyErrorPwdTitle];
            return NO;
        }
    };

    /*
     *  修改
     */

    /** 开始 */
    self.lockView.modifyPwdBlock = ^{

    };
    // Do any additional setup after loading the view, typically from a nib.
    
}
-(void)changeViewAccordingToTyp:(CoreLockType )type{

    if (CoreLockTypeSetPwd == type) {

        self.lockLabel.text = CoreLockPWDTitleFirst;

    }else if (CoreLockTypeVerifyPwd == type){

        self.lockLabel.text = CoreLockVerifyNormalTitle;

    }else if (CoreLockTypeModifyPwd == type){

        self.lockLabel.text = CoreLockModifyNormalTitle;

    }

}
- (IBAction)cancel:(id)sender {

    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
