//
//  SLKTextView+Attachments.m
//  Pods
//
//  Created by KattMing on 2/9/15.
//
//

#define IMAGE_THUMB_SIZE 45

#import "SLKTextView+Attachments.h"

@implementation SLKTextView (Attachments)

- (void)slk_insertImage:(UIImage *)image roundedCorners:(BOOL)roundedCorners {
    NSMutableAttributedString *attributedString = [self.attributedText mutableCopy];
    
    // find image if its already there and remove it
    [attributedString enumerateAttributesInRange:(NSMakeRange(0, attributedString.length)) options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        id attachment = [attrs objectForKey:NSAttachmentAttributeName];
        if ( attachment && [attachment isKindOfClass:[NSTextAttachment class]] ) {
            [attributedString deleteCharactersInRange:range];
            *stop = YES;
        }
    }];
    
    
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    textAttachment.image = [self imageWithImage:image scaledToSize:CGSizeMake(IMAGE_THUMB_SIZE, IMAGE_THUMB_SIZE) roundedCorners:roundedCorners];
    textAttachment.bounds = CGRectMake(0, 0, IMAGE_THUMB_SIZE, IMAGE_THUMB_SIZE);
    
    NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
    [attributedString insertAttributedString:attrStringWithImage atIndex:0];
    self.attributedText = attributedString;
    [[NSNotificationCenter defaultCenter] postNotificationName:UITextViewTextDidChangeNotification object:nil];
}

- (BOOL)slk_hasImageAttachment {
    __block BOOL result = NO;
    [self.attributedText enumerateAttributesInRange:(NSMakeRange(0, self.attributedText.length)) options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        id attachment = [attrs objectForKey:NSAttachmentAttributeName];
        if ( attachment && [attachment isKindOfClass:[NSTextAttachment class]] ) {
            result = YES;
            *stop = YES;
        }
    }];
    
    return result;
}

- (UIImage*)imageWithImage:(UIImage*)image
              scaledToSize:(CGSize)newSize roundedCorners:(BOOL)roundedCorners;
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    if(roundedCorners) {
        return [self makeRoundCornersWithRadius:5.0 inputImage:newImage];
    } else {
        return newImage;
    }
}

-(UIImage*)makeRoundCornersWithRadius:(const CGFloat)RADIUS inputImage:(UIImage *)inputImage {
    UIImage *image = inputImage;
    
    // Begin a new image that will be the new image with the rounded corners
    // (here with the size of an UIImageView)
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    
    const CGRect RECT = CGRectMake(0, 0, image.size.width, image.size.height);
    // Add a clip before drawing anything, in the shape of an rounded rect
    [[UIBezierPath bezierPathWithRoundedRect:RECT cornerRadius:RADIUS] addClip];
    // Draw your imageF
    [image drawInRect:RECT];
    
    UIImage *imageNew = UIGraphicsGetImageFromCurrentImageContext();
    
    // Cya later image that was drawn
    UIGraphicsEndImageContext();
    
    return imageNew;
}

@end
