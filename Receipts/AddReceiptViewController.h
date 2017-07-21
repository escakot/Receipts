//
//  AddReceiptViewController.h
//  Receipts
//
//  Created by Errol Cheong on 2017-07-20.
//  Copyright © 2017 Errol Cheong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddReceiptViewControllerDelegate <NSObject>

- (void)addReceipt;

@end

@class Receipt;
@interface AddReceiptViewController : UIViewController

@property (weak, nonatomic) id <AddReceiptViewControllerDelegate> delegate;
@property (assign, nonatomic) BOOL isEditing;
@property (strong, nonatomic) Receipt *receipt;

@end
