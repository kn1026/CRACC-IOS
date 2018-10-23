//
//  bridge-header.h
//  CRACC
//
//  Created by Khoi Nguyen on 10/19/17.
//  Copyright © 2017 Cracc LLC. All rights reserved.
//

#ifndef bridge_header_h
#define bridge_header_h
#import <JSQMessagesViewController/JSQMessagesViewController.h>



@interface JSQMessagesViewController (Private)

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolbarHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolbarBottomLayoutGuide;

@end


#endif /* bridge_header_h */
