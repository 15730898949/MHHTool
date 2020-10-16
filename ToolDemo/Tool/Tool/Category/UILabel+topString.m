//
//  UILabel+topString.m
//  Tool
//
//  Created by Mac on 2020/8/17.
//  Copyright © 2020 Mac. All rights reserved.
//

#import "UILabel+topString.h"
#import <CoreText/CoreText.h>
#import <objc/runtime.h>
@interface UILabel (topString)
@property (nonatomic,copy) void (^TapBlock)(void);
@property (nonatomic,copy) void (^TapArrayBlock)(NSString * string);
@property (nonatomic,strong) NSMutableDictionary *textMapDictionary;
@end
@implementation UILabel (topString)



- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    if ([self isKindOfClass:[UILabel class]]) {
        
        if (self.textMapDictionary || [self.textMapDictionary allKeys].count != 0) {
            if ([self yb_getTapFrameWithTouchPoint:point result:nil]) {
                return self;
            }
        }
    }
    return [super hitTest:point withEvent:event];
}
-(void)setTapBlock:(void (^)(void))TapBlock{
    objc_setAssociatedObject(self, @selector(TapBlock), TapBlock, OBJC_ASSOCIATION_COPY);
}
-(void (^)(void))TapBlock{
    id object = objc_getAssociatedObject(self, @selector(TapBlock));
    return object?:nil;
}
-(void)setTextMapDictionary:(NSMutableDictionary *)textMapDictionary{
    objc_setAssociatedObject(self, @selector(textMapDictionary), textMapDictionary, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)setTapArrayBlock:(void (^)(NSString *))TapArrayBlock{
    objc_setAssociatedObject(self, @selector(TapArrayBlock), TapArrayBlock, OBJC_ASSOCIATION_COPY);
}
-(void (^)(NSString *))TapArrayBlock{
    id object = objc_getAssociatedObject(self, @selector(TapArrayBlock));
    return object?:nil;
}
-(NSMutableDictionary *)textMapDictionary{
    id object = objc_getAssociatedObject(self, @selector(textMapDictionary));
    return object?:nil;
}
-(void)addTapWithString:(NSString *)string attributes:(NSDictionary *)attributes tapBlock:(void (^)(void))tap{
    //创建富文本，并且将超链接文本设置为蓝色+下划线
    if (self.text.length>0) {
        if (self.numberOfLines != 1) {//多行显示
            self.font = [UIFont systemFontOfSize:12.];//字号大于或小于这个点击就会有偏差
        }
        NSRange range = [self.text rangeOfString:string];
        if (range.location != NSNotFound) {
            self.userInteractionEnabled = YES;
            if (!self.textMapDictionary||!self.textMapDictionary[NSStringFromRange(range)]) {
                UITapGestureRecognizer *taped = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(mu_Text_Taped:)];
                [self addGestureRecognizer:taped];
            }
            NSMutableAttributedString * content = [[NSMutableAttributedString alloc] initWithString:self.text];
            [content addAttributes:attributes range:range];
            self.attributedText = content;
            self.TapBlock = tap;
            if (!self.textMapDictionary) {
                self.textMapDictionary = [NSMutableDictionary dictionary];
            }
            self.textMapDictionary[NSStringFromRange(range)] = string;
        }
    }
    
}
-(void)addTapWithArray:(NSArray<__kindof NSString *> *)array attributes:(NSDictionary *)attributes tapBlock:(void (^)(NSString *))tap{
    //创建富文本，并且将超链接文本设置为蓝色+下划线
    if (self.text.length>0) {
        if (self.numberOfLines != 1) {//多行显示
            self.font = [UIFont systemFontOfSize:12.];//字号大于或小于这个点击就会有偏差
        }
        
        for (NSString *str in array) {
            
            NSRange range = [self.text rangeOfString:str];
            if (range.location != NSNotFound) {
                self.userInteractionEnabled = YES;
                if (!self.textMapDictionary||!self.textMapDictionary[NSStringFromRange(range)]) {
                    UITapGestureRecognizer *taped = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(mu_TextArray_Taped:)];
                    [self addGestureRecognizer:taped];
                }
                NSMutableAttributedString * content = [[NSMutableAttributedString alloc] initWithString:self.text];
                [content addAttributes:attributes range:range];
                self.attributedText = content;
                self.textMapDictionary[NSStringFromRange(range)] = str;
            }
            self.TapArrayBlock  = tap;
            if (!self.textMapDictionary) {
                self.textMapDictionary = [NSMutableDictionary dictionary];
            }
            
        }
    }
}

-(void)mu_TextArray_Taped:(UITapGestureRecognizer *)gesture{
    if (self.textMapDictionary || [self.textMapDictionary allKeys].count != 0) {
        CGPoint point = [gesture locationInView:self];
        [self yb_getTapFrameWithTouchPoint:point result:self.TapArrayBlock];
        //        if ([self yb_getTapFrameWithTouchPoint:point result:self.TapArrayBlock]) {
        //        }
    }
}

-(void)mu_Text_Taped:(UITapGestureRecognizer *)gesture{
    if (self.textMapDictionary || [self.textMapDictionary allKeys].count != 0) {
        CGPoint point = [gesture locationInView:self];
        if ([self yb_getTapFrameWithTouchPoint:point result:nil]) {
            if (self.TapBlock) {
                self.TapBlock();
            }
        }
    }
}


#pragma mark - getTapFrame
- (BOOL)yb_getTapFrameWithTouchPoint:(CGPoint)point result:(void (^) (NSString *clickedString))resultBlock
{
    
    [self sizeToFit];
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)self.attributedText);
    
    CGMutablePathRef Path = CGPathCreateMutable();
    
    CGPathAddRect(Path, NULL, CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height));
    
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), Path, NULL);
    
    CFRange range = CTFrameGetVisibleStringRange(frame);
    
    if (self.attributedText.length > range.length) {
        
        UIFont *font = [UIFont systemFontOfSize:12];
        
        CGPathRelease(Path);
        
        Path = CGPathCreateMutable();
        
        CGPathAddRect(Path, NULL, CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height + font.lineHeight));
        
        frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), Path, NULL);
    }
    
    CFArrayRef lines = CTFrameGetLines(frame);
    
    if (!lines) {
        CFRelease(frame);
        CFRelease(framesetter);
        CGPathRelease(Path);
        return NO;
    }
    
    
    CFIndex count = CFArrayGetCount(lines);
    
    CGPoint origins[count];
    
    CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), origins);
    
    CGAffineTransform transform = [self yb_transformForCoreText];
    
    CGFloat verticalOffset = 0;
    
    for (CFIndex i = 0; i < count; i++) {
        CGPoint linePoint = origins[i];
        
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        
        CGRect flippedRect = [self yb_getLineBounds:line point:linePoint];
        
        CGRect rect = CGRectApplyAffineTransform(flippedRect, transform);
        
        rect = CGRectInset(rect, 0, 0);
        
        rect = CGRectOffset(rect, 0, verticalOffset);
        
        NSParagraphStyle *style = [self.attributedText attribute:NSParagraphStyleAttributeName atIndex:0 effectiveRange:nil];
        
        CGFloat lineSpace;
        
        if (style) {
            lineSpace = style.lineSpacing;
        }else {
            lineSpace = 0;
        }
        
        CGFloat lineOutSpace = (self.bounds.size.height - lineSpace * (count - 1) -rect.size.height * count) / 2;
        
        rect.origin.y = lineOutSpace + rect.size.height * i + lineSpace * i;
        
        if (CGRectContainsPoint(rect, point)) {
            
            CGPoint relativePoint = CGPointMake(point.x - CGRectGetMinX(rect), point.y - CGRectGetMinY(rect));
            
            CFIndex index = CTLineGetStringIndexForPosition(line, relativePoint);
            
            CGFloat offset;
            
            CTLineGetOffsetForStringIndex(line, index, &offset);
            
            if (offset > relativePoint.x) {
                index = index - 1;
            }
            for (NSString *str in [self.textMapDictionary allKeys]) {
                
                NSRange range = NSRangeFromString(str);
                if (NSLocationInRange(index, range)) {
                    
                    if (resultBlock) {
                        resultBlock(str);
                    }
                    CFRelease(frame);
                    CFRelease(framesetter);
                    CGPathRelease(Path);
                    return YES;
                }
            }
        }
    }
    CFRelease(frame);
    CFRelease(framesetter);
    CGPathRelease(Path);
    return NO;
}
- (CGAffineTransform)yb_transformForCoreText
{
    return CGAffineTransformScale(CGAffineTransformMakeTranslation(0, self.bounds.size.height), 1.f, -1.f);
}

- (CGRect)yb_getLineBounds:(CTLineRef)line point:(CGPoint)point
{
    CGFloat ascent = 0.0f;
    CGFloat descent = 0.0f;
    CGFloat leading = 0.0f;
    CGFloat width = (CGFloat)CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    CGFloat height = ascent + fabs(descent) + leading;
    
    return CGRectMake(point.x, point.y , width, height);
}

@end
