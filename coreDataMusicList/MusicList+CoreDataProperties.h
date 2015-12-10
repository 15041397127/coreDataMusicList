//
//  MusicList+CoreDataProperties.h
//  coreDataMusicList
//
//  Created by zhang xu on 15/11/24.
//  Copyright © 2015年 zhang xu. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "MusicList.h"

NS_ASSUME_NONNULL_BEGIN

@interface MusicList (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *picUrl;
@property (nullable, nonatomic, retain) NSString *singer;

@end

NS_ASSUME_NONNULL_END
