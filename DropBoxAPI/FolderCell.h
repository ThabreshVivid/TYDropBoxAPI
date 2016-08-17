//
//  FolderCell.h
//  DropBoxAPI
//
//  Created by Thabresh on 8/16/16.
//  Copyright © 2016 VividInfotech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FolderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *txtTitle;
@property (weak, nonatomic) IBOutlet UIImageView *iconic;
@property (weak, nonatomic) IBOutlet UILabel *txtDate;

@end
