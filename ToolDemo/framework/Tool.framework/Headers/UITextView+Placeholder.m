// The MIT License (MIT)
//
// Copyright (c) 2014 Suyeol Jeon (http:xoul.kr)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#import <objc/runtime.h>
#import "UITextView+Placeholder.h"

@implementation UITextView (mh_placeholder)

#pragma mark - Swizzle Dealloc

+ (void)load {
    // is this the best solution?
    method_exchangeImplementations(class_getInstanceMethod(self.class, NSSelectorFromString(@"dealloc")),
                                   class_getInstanceMethod(self.class, @selector(swizzledDealloc)));
}

- (void)swizzledDealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    UITextView *textView = objc_getAssociatedObject(self, @selector(placeholderTextView));
    if (textView) {
        for (NSString *key in self.class.observingKeys) {
            @try {
                [self removeObserver:self forKeyPath:key];
            }
            @catch (NSException *exception) {
                // Do nothing
            }
        }
    }
    [self swizzledDealloc];
}


#pragma mark - Class Methods
#pragma mark `defaultPlaceholderColor`

+ (UIColor *)defaultPlaceholderColor {
    if (@available(iOS 13, *)) {
      SEL selector = NSSelectorFromString(@"placeholderTextColor");
      if ([UIColor respondsToSelector:selector]) {
        return [UIColor performSelector:selector];
      }
    }
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UITextField *textField = [[UITextField alloc] init];
        textField.placeholder = @" ";
        NSDictionary *attributes = [textField.attributedPlaceholder attributesAtIndex:0 effectiveRange:nil];
        color = attributes[NSForegroundColorAttributeName];
        if (!color) {
          color = [UIColor colorWithRed:0 green:0 blue:0.0980392 alpha:0.22];
        }
    });
    return color;
}


#pragma mark - `observingKeys`

+ (NSArray *)observingKeys {
    return @[@"attributedText",
             @"bounds",
             @"font",
             @"frame",
             @"text",
             @"textAlignment",
             @"textContainerInset",
             @"textContainer.lineFragmentPadding",
             @"textContainer.exclusionPaths"];
}


#pragma mark - Properties
#pragma mark `placeholderTextView`
- (UITextView *)mh_placeholderTextView {
    UITextView *textView = objc_getAssociatedObject(self, @selector(mh_placeholderTextView));
    if (!textView) {
        NSAttributedString *originalText = self.attributedText;
        self.text = @" "; // lazily set font of `UITextView`.
        self.attributedText = originalText;

        textView = [[UITextView alloc] init];
        textView.backgroundColor = [UIColor clearColor];
        textView.textColor = [self.class defaultPlaceholderColor];
        textView.userInteractionEnabled = NO;
        textView.isAccessibilityElement = NO;
        objc_setAssociatedObject(self, @selector(mh_placeholderTextView), textView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

        self.needsUpdateFont = YES;
        [self updatePlaceholderTextView];
        self.needsUpdateFont = NO;

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(updatePlaceholderTextView)
                                                     name:UITextViewTextDidChangeNotification
                                                   object:self];

        for (NSString *key in self.class.observingKeys) {
            [self addObserver:self forKeyPath:key options:NSKeyValueObservingOptionNew context:nil];
        }
    }
    return textView;
}


#pragma mark `placeholder`

- (NSString *)mh_placeholder {
    return self.mh_placeholderTextView.text;
}
- (void)setMh_placeholder:(NSString *)mh_placeholder {
    self.mh_placeholderTextView.text = mh_placeholder;
    [self updatePlaceholderTextView];
}

- (NSAttributedString *)mh_attributedPlaceholder {
    return self.mh_placeholderTextView.attributedText;
}

- (void)setMh_attributedPlaceholder:(NSAttributedString *)mh_attributedPlaceholder {
    self.mh_placeholderTextView.attributedText = mh_attributedPlaceholder;
    [self updatePlaceholderTextView];
}

#pragma mark `placeholderColor`

- (UIColor *)mh_placeholderColor {
    return self.mh_placeholderTextView.textColor;
}

- (void)setMh_placeholderColor:(UIColor *)mh_placeholderColor {
    self.mh_placeholderTextView.textColor = mh_placeholderColor;
}


#pragma mark `needsUpdateFont`

- (BOOL)needsUpdateFont {
    return [objc_getAssociatedObject(self, @selector(needsUpdateFont)) boolValue];
}

- (void)setNeedsUpdateFont:(BOOL)needsUpdate {
    objc_setAssociatedObject(self, @selector(needsUpdateFont), @(needsUpdate), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:@"font"]) {
        self.needsUpdateFont = (change[NSKeyValueChangeNewKey] != nil);
    }
    [self updatePlaceholderTextView];
}


#pragma mark - Update

- (void)updatePlaceholderTextView {
    if (self.text.length) {
        [self.mh_placeholderTextView removeFromSuperview];
        self.accessibilityValue = self.text;
    } else {
        [self insertSubview:self.mh_placeholderTextView atIndex:0];
        self.accessibilityValue = self.mh_placeholder;
    }

    if (self.needsUpdateFont) {
        self.mh_placeholderTextView.font = self.font;
        self.needsUpdateFont = NO;
    }
    if (self.mh_placeholderTextView.attributedText.length == 0) {
      self.mh_placeholderTextView.textAlignment = self.textAlignment;
    }
    self.mh_placeholderTextView.textContainer.exclusionPaths = self.textContainer.exclusionPaths;
    self.mh_placeholderTextView.textContainerInset = self.textContainerInset;
    self.mh_placeholderTextView.textContainer.lineFragmentPadding = self.textContainer.lineFragmentPadding;
    self.mh_placeholderTextView.frame = self.bounds;
}

@end

@implementation  UITextField (mh_placeholder)
static char mh_placeholderColor;
- (UIColor *)mh_placeholderColor {
    return objc_getAssociatedObject(self, &mh_placeholderColor);
}

- (void)setMh_placeholderColor:(UIColor *)mh_placeholderColor {
    Ivar ivar = class_getInstanceVariable([self class], "_placeholderLabel");
    id placeholderLabel = object_getIvar(self, ivar);
    [placeholderLabel performSelector:@selector(setTextColor:) withObject:mh_placeholderColor];
    objc_setAssociatedObject(self, &mh_placeholderColor, mh_placeholderColor, OBJC_ASSOCIATION_RETAIN);

}


@end
