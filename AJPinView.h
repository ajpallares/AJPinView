//
//  AJPinView.h
//  AJPinView
//
//  Created by AJPallares on 02/06/2018.
//  Copyright © 2018 AJPallares. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AJPinView;

@protocol AJPinViewDelegate <NSObject>

@required
/**
 This method is used by the PinView instance to communicate to its delegate that the text entry should be ended. That is when the pin view's text has the same lenght as the pin view's codeLenght.
 
 

 @param pinView The PinView instance whose text entry has reached the end.
 */
- (void)pinViewTextEntryDidReachEnd:(AJPinView *)pinView;

@end

IB_DESIGNABLE
@interface AJPinView : UIControl <UIKeyInput>

@property (copy, nonatomic) IBInspectable NSString *text;
@property (copy, nonatomic) IBInspectable UIColor *filledColor;
@property (copy, nonatomic) IBInspectable UIColor *blankColor;
@property (assign, nonatomic) IBInspectable NSUInteger codeLenght;
@property (assign, nonatomic) IBInspectable CGFloat dotSeparation;
@property (assign, nonatomic) IBInspectable CGFloat dotRadius;

@property (weak, nonatomic) id<AJPinViewDelegate> delegate;

- (void)animateWrongEntryWithCompletion:(void (^)(void))completion;

@end
