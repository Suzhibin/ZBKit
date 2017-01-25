//
//  ZBDataBaseManager.m
//  ZBKit
//
//  Created by NQ UEC on 16/11/29.
//  Copyright © 2016年 Suzhibin. All rights reserved.
//

#import "ZBDataBaseManager.h"
#import "FMDB.h"
#import "ZBCacheManager.h"
#import "ZBConstants.h"
NSString *const dbName =@"ZBKit.db";
@interface ZBDataBaseManager()

@property (strong, nonatomic) FMDatabaseQueue * dbQueue;
@property (nonatomic ,copy)NSString *dbPath;
@end
@implementation ZBDataBaseManager

+(ZBDataBaseManager *)sharedManager{
    static ZBDataBaseManager *manager = nil;
    static dispatch_once_t onceTaken;
    dispatch_once(&onceTaken,^{
        manager=[[ZBDataBaseManager alloc]init];
        
    });
    
    return manager;
}

- (instancetype)init{
    return [self initWithName:dbName];
    
}
- (instancetype)initWithName:(NSString *)name{
    self = [super init];
    if (self) {
        if (_dbQueue) {
            [self closeDataBase];
        }
    
        NSString *dbPath =[[ZBCacheManager sharedManager]ZBKitPath];
        
        [[ZBCacheManager sharedManager]createDirectoryAtPath:dbPath];
        
        //初始化fmdatabase 并传递数据库的创建路径
        self.dbPath = [dbPath stringByAppendingPathComponent:name];
        //创建数据库，并加入到队列中，此时已经默认打开了数据库，无须手动打开
        _dbQueue=[FMDatabaseQueue databaseQueueWithPath:self.dbPath];
        
    }
    return self;
}

- (void)createTable:(NSString *)tableName{
    if ([self isTableName:tableName]==NO) {
        return;
    }
    NSString * sql = [NSString stringWithFormat:@"create table if not exists %@ (obj blob NOT NULL,itemId varchar(256) NOT NULL,time varchar(256) NOT NULL)", tableName];
    __block BOOL isSuccessed;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        isSuccessed = [db executeUpdate:sql];
        if (!isSuccessed) {
            ZBKLog(@"create table:%@ Error:%@",tableName,db.lastErrorMessage);
        }else{
            ZBKLog(@"create table:%@ time:%@ success",tableName,[self getDate]);
        }
    }];

}

- (void)table:(NSString *)tableName insertDataWithObj:(id)obj ItemId:(NSString *)itemId {
    if ([self isTableName:tableName]==NO) {
        return;
    }
    //此处把字典归档成二进制数据直接存入数据库，避免添加过多的数据库字段
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:obj];
    NSString *insertSql = [NSString stringWithFormat:@"insert into %@ (obj,itemId,time) values(?,?,?)", tableName];
    //NSLog(@"insertSql:%@",insertSql);
    __block BOOL result;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        
        result = [db executeUpdate:insertSql,data,itemId,[self getDate]];
        
        if (!result) {
            ZBKLog(@"insert table:%@ Error:%@ itemId:%@",tableName,db.lastErrorMessage,itemId);
        }else{
            ZBKLog(@"insert table:%@ itemId:%@  time:%@ success",tableName,itemId,[self getDate]);
        }
    }];
}

- (NSArray *)getAllDataWithTable:(NSString *)tableName{
    if ([self isTableName:tableName] == NO) {
        return nil;
    }
    NSString *selectSql = [NSString stringWithFormat:@"select *from %@", tableName];
    NSMutableArray *array = [NSMutableArray array];
    [_dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet * set = [db executeQuery:selectSql];
        while ([set next]) {
            NSData *data = [set dataForColumn:@"obj"];
            id obj = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            NSString *dateStr = [set stringForColumn:@"time"];
            [array addObject:obj];
            [array addObject:dateStr];
        }
        [set  close];
    }];
    return array;
}

-(BOOL)isCollectedWithTable:(NSString *)tableName itemId:(NSString *)itemId{
    if ([self isTableName:tableName] == NO) {
        return nil;
    }
    NSString *selectSql =[NSString stringWithFormat:@"select *from %@ where itemId =?", tableName];
    __block BOOL result;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *set = [db executeQuery:selectSql,itemId];
        
        if ([set next]) {
            result=YES;
        }else{
            result=NO;
        }
        [set  close];
    }];
    return result;
}

- (void)getAllDataWithTable:(NSString *)tableName itemId:(NSString *)itemId data:(getAllExistData)data{
    if ([self isTableName:tableName] == NO) {
        return;
    }
    NSString *selectSql = [NSString stringWithFormat:@"select *from %@ where itemId = ?", tableName];
    NSMutableArray *array = [NSMutableArray array];
    __block BOOL isExist;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet * set = [db executeQuery:selectSql,itemId];
        if ([set next]) {
            isExist=YES;
        }else{
            isExist=NO;
        }
        while ([set next]) {
            NSData *data = [set dataForColumn:@"obj"];
            id obj = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            NSString *dateStr = [set stringForColumn:@"time"];
            [array addObject:obj];
            [array addObject:dateStr];
        }
      
        [set  close];
        
    }];
    data ? data(array,isExist) : nil;
}

- (void)table:(NSString *)tableName deleteDataWithItemId:(NSString *)itemId{
    if ([self isTableName:tableName] == NO) {
        return;
    }
    NSString *deleteSql = [NSString stringWithFormat:@"delete from %@ where itemId = ?", tableName];
    [_dbQueue inDatabase:^(FMDatabase *db) {
        if (![db executeUpdate:deleteSql,itemId]) {
            ZBKLog(@"delete %@ table error:%@ itemId:%@",tableName,db.lastErrorMessage,itemId);
        }
        ZBKLog(@"delete %@ table %@",tableName,itemId);
    }];
}

- (void)table:(NSString *)tableName updateDataWithObj:(id)obj itemId:(NSString *)itemId{
    if ([self isTableName:tableName] == NO) {
        return;
    }
    NSString *updateSql =[NSString stringWithFormat:@"update %@ set obj =?,time=? where itemId = ?", tableName];
    [_dbQueue inDatabase:^(FMDatabase *db) {
        
        BOOL isSuccessed = [db executeUpdate:updateSql,obj,itemId,[self getDate]];
        if (!isSuccessed) {
            ZBKLog(@"update %@ table error:%@ itemId:%@",tableName,db.lastErrorMessage,itemId);
        }
    }];
}


-(NSUInteger)getDBSize{
    __block NSUInteger size = 0;
    NSDictionary *fileAttributeDic=[[NSFileManager defaultManager] attributesOfItemAtPath:self.dbPath error:nil];
   return size = fileAttributeDic.fileSize;
}

- (NSUInteger)getDBCountWithTable:(NSString *)tableName{
    if ([self isTableName:tableName] == NO) {
        return 0;
    }
    __block NSUInteger statuscount = 0;
    NSString *selectSql =[NSString stringWithFormat:@"SELECT count(*) FROM %@",tableName];
    
    [_dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *s = [db executeQuery:selectSql];
        if ([s next]) {
            statuscount = [s intForColumnIndex:0];
        }
    }];
    return statuscount;
}

-(void)cleanDBWithTable:(NSString *)tableName{
    if ([self isTableName:tableName] == NO) {
        return;
    }
    NSString *selectSql =[NSString stringWithFormat:@"DELETE FROM %@",tableName];
    [_dbQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:selectSql];
    }];
    return;
}

- (void)closeDataBase {
    [_dbQueue close];
    _dbQueue=nil;    
}

- (NSString *)getDate{

    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy-MM-dd HH:mm:ss:SSS";
    NSString *dateStr = [format stringFromDate:[NSDate date]];
    return dateStr;
}

- (BOOL)isTableName:(NSString *)tableName {
    if (tableName == nil || tableName.length == 0 || [tableName rangeOfString:@" "].location != NSNotFound) {
        NSLog(@"ERROR, table name: %@ format error.", tableName);
        return NO;
    }
    return YES;
}

@end
