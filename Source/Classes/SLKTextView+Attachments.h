//
//  SLKTextView+Attachments.h
//  Pods
//
//  Created by KattMing on 2/9/15.
//
//

#import "SLKTextView.h"

@interface SLKTextView (Attachments)

- (void)slk_insertImage:(UIImage *)image;
- (BOOL)slk_hasImageAttachment;

@end
