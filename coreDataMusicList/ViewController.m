//
//  ViewController.m
//  coreDataMusicList
//
//  Created by zhang xu on 15/11/24.
//  Copyright © 2015年 zhang xu. All rights reserved.
//

#import "ViewController.h"
#import "MusicListTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "MuiscModel.h"
#import <CoreData/CoreData.h>
#import "MusicList.h"
#define kUrl @"http://project.lanou3g.com/teacher/UIAPI/MusicInfoList.plist"
@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    
    NSManagedObjectContext *_context;
}
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
      self.automaticallyAdjustsScrollViewInsets = YES;
    
    [self.myTableView registerNib:[UINib nibWithNibName:@"MusicListTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
        [self openDB];
    [self returnData];
    

    
   
    // Do any additional setup after loading the view, typically from a nib.
    
 
    
    
}

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
    
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MusicListTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    

    if ([self allMusicList]!=nil) {
        MusicList *list =[self.dataArray objectAtIndex:indexPath.row];
        cell.nameLabel.text =list.name;
        cell.singerLabel.text=list.singer;
        [cell.picImage sd_setImageWithURL:[NSURL URLWithString:list.picUrl]];
        
    }else{
        
        
        MuiscModel *model =self.dataArray[indexPath.row];
        cell.nameLabel.text=model.name;
        cell.singerLabel.text=model.singer;
        [cell.picImage  sd_setImageWithURL:[NSURL URLWithString:model.picUrl]];
        
        
    }

    
    return cell;
    
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 60;
}


-(void)getData{
    
   
    
    
    __weak typeof(self)weakSelf =self;
    self.dataArray =[NSMutableArray array];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray *arr =[NSArray arrayWithContentsOfURL:[NSURL URLWithString:kUrl]];
        for (NSDictionary *dic in arr) {
            MuiscModel *model =[[MuiscModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [weakSelf.dataArray addObject:model];
            
            [weakSelf addMusicList:model];
//            NSLog(@"%@",weakSelf.dataArray);
    
        }
                __strong typeof(weakSelf)strongSelf= weakSelf;
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf.myTableView reloadData];
        });

    });
    
    
    
    
    

}

-(void)openDB{
    NSManagedObjectModel *model =[NSManagedObjectModel mergedModelFromBundles:nil];
    
    NSPersistentStoreCoordinator *store =[[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:model];
    
    NSArray *docs=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * path =[docs[0] stringByAppendingPathComponent:@"my.db"];
                                  
    NSURL *url =[NSURL fileURLWithPath:path];
    
    NSError *error =nil;
    
    [store addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&error];
    
    if (error) {
        NSLog(@"打开失败 %@",error.localizedDescription );
        
    }else{
        NSLog(@"打开成功 ");
        
        _context =[[NSManagedObjectContext alloc]initWithConcurrencyType:NSMainQueueConcurrencyType];
        _context.persistentStoreCoordinator =store;
        
    }
    
}




- (IBAction)removeData:(id)sender {
    
    __weak typeof(self)weakSelf=self;
    UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"提示" message:@"是否清除数据" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction =[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *sureAction =[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self clearDB];
        
        __strong typeof(weakSelf)strongSelf =weakSelf;
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf.myTableView reloadData];
            
        });

    }];
    
    [alert addAction:cancelAction];
    [alert addAction:sureAction];
    [self presentViewController:alert animated:YES completion:^{
        
    }];
    
    
}


/**
 *  删除记录
 */

-(void)removeMusic{
    //1.实例化查询请求
    NSFetchRequest *request =[NSFetchRequest fetchRequestWithEntityName:@"MusicList"];
    
    //2. 设置谓词条件
//    request.predicate =[NSPredicate predicateWithFormat:@"name = '李白'"];
    
    //3.由上下文查询数据
    NSArray *result =[_context executeFetchRequest:request error:nil];
    
    //4 输出结果
    
    for (MusicList *musicList in result) {
        NSLog(@"%@ %@ %@",musicList.name,musicList.singer,musicList.picUrl);
        //删除一条记录
        [_context deleteObject:musicList];
        break;
        
    }
    
    //5 通知_context 保存数据
    if ([_context save:nil]) {
        NSLog(@"删除成功");
    }else{
        NSLog(@"删除失败");
    }

}

/**
 *  更新数据
 */


-(void)updateList{
    
    //1 实例化查询请求
    NSFetchRequest *request =[NSFetchRequest fetchRequestWithEntityName:@"MusicList"];
    
    //2 设置谓词条件
    request.predicate =[NSPredicate predicateWithFormat:@" ",nil];
    
    //3 由上下文查询数据
    
    NSArray *result =[_context executeFetchRequest:request error:nil];
    
    
    //4 输出结果
    for (MusicList *muiscList in result) {
        NSLog(@"%@ %@ %@",muiscList.name,muiscList.singer,muiscList.picUrl);
        
        //更新书名
        muiscList.name =@"dasdada";
    }
    [_context save:nil];
    

}


/**
 *  查询所有用户记录
 */

-(NSArray *)allMusicList{
    
    NSFetchRequest *request =[NSFetchRequest fetchRequestWithEntityName:@"MusicList"];
    
    NSError *error =nil;
    NSArray *array =[_context executeFetchRequest:request error:&error];
    
    if (error) {
        NSLog(@"查询失败");
    }else{
        
        
    }
    
    
    
    return array;
    
}


/**
 *  新增歌曲
 */

-(void)addMusicList:(MuiscModel *)model{

    MusicList *list =[NSEntityDescription insertNewObjectForEntityForName:@"MusicList" inManagedObjectContext:_context];
    list.name=model.name;
    list.singer =model.singer;
    list.picUrl=model.picUrl;
    
    if ([_context save:nil]) {
        NSLog(@"添加成功");
    }else{
        
        NSLog(@"添加失败");
    }

}

-(void)clearDB{
    [self removeMusic];
    
    NSFileManager *manager =[NSFileManager defaultManager];
    
    NSString *docs =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    
    [manager removeItemAtPath:docs error:nil];
    [manager createDirectoryAtPath:docs withIntermediateDirectories:YES attributes:nil error:nil];
    
    
    
    self.dataArray =nil;
    
}


-(void)returnData{
    
    if ([[self allMusicList]count]!=0) {
        NSLog(@"coreData加载数据");
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            self.dataArray =nil;
            [self.myTableView reloadData];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.dataArray =[NSMutableArray arrayWithArray:[self allMusicList]];
                [self.myTableView reloadData];
            });
  
        });

    }else{
        
        NSLog(@"从网络中加载");
        [self openDB];
        [self getData];
        
        
    }

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
