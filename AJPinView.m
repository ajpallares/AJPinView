//
//  AJPinView.m
//  AJPinView
//
//  Created by AJPallares on 02/06/2018.
//  Copyright © 2018 AJPallares. All rights reserved.
//

#import "AJPinView.h"

@implementation AJPinView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    [self setupPinView];
    [self addTarget:self action:@selector(onTap:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupPinView {
    self.text = @"";
    self.filledColor = [UIColor darkGrayColor];
    self.blankColor = [UIColor lightGrayColor];
    self.codeLenght = 4;
    self.dotSeparation = 10;
    self.dotRadius = 2.5;
    
    self.keyboardAppearance = UIKeyboardAppearanceDefault;
}

- (CGSize)intrinsicContentSize {
    CGFloat width = [self totalWidth];
    CGFloat height = [self dotWidth];
    return CGSizeMake(width, height);
}

- (CGSize)systemLayoutSizeFittingSize:(CGSize)targetSize {
    return [self intrinsicContentSize];
}

- (CGSize)systemLayoutSizeFittingSize:(CGSize)targetSize withHorizontalFittingPriority:(UILayoutPriority)horizontalFittingPriority verticalFittingPriority:(UILayoutPriority)verticalFittingPriority{
    return [self intrinsicContentSize];
}


#pragma mark - Helper methods

- (CGFloat)dotWidth {
    return self.dotRadius * 2.f;
}

- (CGFloat)totalWidth {
    return self.codeLenght * [self dotWidth] + (self.codeLenght - 1) * self.dotSeparation;
}


#pragma mark - Getters & Setters

@synthesize text = _text;

- (void)setText:(NSString *)text {
    NSString *finalText = [text substringToIndex:MIN(self.codeLenght, text.length)];
    _text = finalText;
    [self setNeedsDisplay];
    if (_text.length == self.codeLenght && [self.delegate respondsToSelector:@selector(pinViewTextEntryDidReachEnd:)]) {
        [self.delegate pinViewTextEntryDidReachEnd:self];
    }
}

- (NSString *)text {
    if (!_text) {
        _text = @"";
    }
    return _text;
}


#pragma mark - Drawing the view

- (void)drawRect:(CGRect)rect {
    CGFloat centerX = (self.bounds.size.width - [self totalWidth]) / 2.f + self.dotRadius;
    CGFloat centerY = self.bounds.size.height / 2.f;
    
    CGPoint dotCenter = CGPointMake(centerX, centerY);
    
    for (int i = 0; i < self.codeLenght; i++) {
        
        UIColor *dotColor = i < self.text.length ? self.filledColor : self.blankColor;
        [self drawDotWithCenter:dotCenter color:dotColor];
        dotCenter.x = dotCenter.x + [self dotWidth] + self.dotSeparation;
    }
}

- (void)drawDotWithCenter:(CGPoint)center color:(UIColor *)color{
    UIBezierPath *dotPath = [UIBezierPath bezierPathWithArcCenter:center radius:self.dotRadius startAngle:0 endAngle:2 * M_PI clockwise:YES];
    dotPath.lineWidth = 0;
    
    [color setFill];
    [dotPath fill];
}


#pragma mark - Public methods

- (void)animateWrongEntryWithCompletion:(void (^)(void))completion; {
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [CATransaction begin];
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
        animation.duration = 0.06;
        animation.repeatCount = 3;
        animation.autoreverses = YES;
        animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(weakSelf.center.x - 5, weakSelf.center.y)];
        animation.toValue = [NSValue valueWithCGPoint:CGPointMake(weakSelf.center.x + 5, weakSelf.center.y)];
        
        [CATransaction setCompletionBlock:completion];
        
        [weakSelf.layer addAnimation:animation forKey:@"position"];
        
        [CATransaction commit];
    });
}


#pragma mark - User Interaction

- (void)onTap:(id)sender {
    [self becomeFirstResponder];
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}


#pragma mark - UIKeyInput

- (void)insertText:(NSString *)text {
    self.text = [self.text stringByAppendingString:text];
}

- (void)deleteBackward {
    if (self.text.length > 0) {
        self.text = [self.text substringToIndex:self.text.length - 1];
    }
}

- (BOOL)hasText {
    return self.text.length > 0;
}


#pragma mark - UITextInputTraits

- (void)setKeyboardType:(UIKeyboardType)keyboardType {
    NSLog(@"Setting the keyboard type on an object of class %@ does nothing because it can only use a keyboard of type UIKeyboardTypeNumberPad", NSStringFromClass([self class]));
}

- (UIKeyboardType)keyboardType {
    return UIKeyboardTypeNumberPad;
}

- (void)setReturnKeyType:(UIReturnKeyType)returnKeyType {
    NSLog(@"Setting the return key type on an object of class %@ has no effect since the only keyboard type supported by this class (that is, UIKeyboardTypeNumberPad) has no return key", NSStringFromClass([self class]));
}

- (UIReturnKeyType)returnKeyType {
    return UIReturnKeyDefault;
}

- (void)setTextContentType:(UITextContentType)textContentType {
    NSLog(@"Setting the text content type on an object of class %@ does nothing because it can only have text of type UITextContentTypePassword", NSStringFromClass([self class]));
}

- (UITextContentType)textContentType {
    return UITextContentTypePassword;
}

- (void)setSecureTextEntry:(BOOL)secureTextEntry {
    NSLog(@"Setting the secure text entry property on an object of class %@ does nothing because it can only have secured text entry", NSStringFromClass([self class]));
}

- (BOOL)secureTextEntry {
    return [self isSecureTextEntry];
}

- (BOOL)isSecureTextEntry {
    return YES;
}

@synthesize keyboardAppearance = _keyboardAppearance;

- (void)setAutocapitalizationType:(UITextAutocapitalizationType)autocapitalizationType {
    NSLog(@"Setting the autocapitalization type on an object of class %@ does nothing because it can only use a keyboard of type UIKeyboardTypeNumberPad", NSStringFromClass([self class]));
}

- (UITextAutocapitalizationType)autocapitalizationType {
    return UITextAutocapitalizationTypeNone;
}

- (void)setAutocorrectionType:(UITextAutocorrectionType)autocorrectionType {
    NSLog(@"Setting the autocorrection type on an object of class %@ does nothing because it can only have text of type UITextContentTypePassword. Therefore, its autocorrection type is UITextAutocapitalizationTypeNone", NSStringFromClass([self class]));
}

- (UITextAutocorrectionType)autocorrectionType {
    return UITextAutocorrectionTypeNo;
}

- (void)setSpellCheckingType:(UITextSpellCheckingType)spellCheckingType {
    NSLog(@"Setting the spell checking type on an object of class %@ does nothing because it can only have text of type UITextContentTypePassword. Therefore, its spell checking type is UITextSpellCheckingTypeNo", NSStringFromClass([self class]));
}

- (UITextSpellCheckingType)spellCheckingType {
    return UITextSpellCheckingTypeNo;
}

@end
