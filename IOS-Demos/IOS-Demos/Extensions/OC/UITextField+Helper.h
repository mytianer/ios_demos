//
//  UITextField+Helper.h
//  Xchat
//
//  Created by zwj on 2020/12/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextField(helper)

/// 限制最大长度
@property (nonatomic, assign)IBInspectable int maxLength;

@end

NS_ASSUME_NONNULL_END
