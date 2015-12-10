//
//  MusicListTableViewCell.h
//  coreDataMusicList
//
//  Created by zhang xu on 15/11/24.
//  Copyright © 2015年 zhang xu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MusicListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *picImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *singerLabel;
@end
