//
//  MovieCenter.m
//  MovieList
//
//  Created by T on 2014. 1. 14..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "MovieCenter.h"
#import "Movie.h"
#import <sqlite3.h>


@implementation MovieCenter
{
    
    NSMutableArray *data;
    sqlite3 *db;
}

static MovieCenter *_instance = nil;


// DB 연결은 어디서 하나요?

+ (id)sharedMovieCenter
{
    if (nil == _instance) {
        _instance = [[MovieCenter alloc] init];
    }
    return _instance;
    
}

- (void)first
{
    data = [NSMutableArray array];
}

// DB 작업 모두 여기서 한다

- (void)openDB{
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *dbFilePath = [docPath stringByAppendingPathComponent:@"db3.splite"];
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL existFile = [fm fileExistsAtPath:dbFilePath];
    if(existFile == NO)
    {
        NSString *defalutDBPath =[[[NSBundle mainBundle]resourcePath] stringByAppendingPathComponent:@"db3.sqlite"];
        NSError *error;
        BOOL success = [fm copyItemAtPath:defalutDBPath toPath:dbFilePath error:&error];
        
        if(!success)
            NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
    int ret = sqlite3_open([dbFilePath UTF8String], &db);
    NSAssert1(SQLITE_OK==ret,@"Error on opening Database : %s", sqlite3_errmsg(db));
}

- (void)resolveData
{
    [data removeAllObjects];
    
    NSString *queryStr = @"SELECT rowid, title FROM Movie";
    sqlite3_stmt *stmt;
    int ret = sqlite3_prepare_v2(db, [queryStr UTF8String], -1, &stmt, NULL);
    
    NSAssert2(SQLITE_OK==ret, @"Error(%d) on resolving data : %s", ret, sqlite3_errmsg(db));
    
    
    while(SQLITE_ROW == sqlite3_step(stmt))
    {
        int rowID = sqlite3_column_int(stmt,0);
        char *title = (char *)sqlite3_column_text(stmt,1);
        
        Movie *one = [[Movie alloc]init];
        
        NSLog(@"%@",[NSString stringWithCString:title encoding:NSUTF8StringEncoding]);
        one.title = [NSString stringWithCString:title encoding:NSUTF8StringEncoding];
        one.rowID = rowID;
        [data addObject:one];
    }
    NSLog(@"%d",[data count]);
    sqlite3_finalize(stmt);
}

- (void)addData:(NSString *)input
{
    NSLog(@"adding data:%@",input);
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO Movie (title) VALUES ('%@')",input];
    NSLog(@"sql:%@",sql);
    
    char *errMsg;
    int ret = sqlite3_exec(db, [sql UTF8String], NULL, nil, &errMsg);
    
    if(SQLITE_OK !=ret)
    {
        NSLog(@"Error on Insert New data: %s",errMsg);
    }
    [self resolveData];
   
}




- (NSInteger)getNumberOfMovies {
    return [data count];
}

- (NSString *)getNameOfMovieAtIndex:(NSInteger)index {
    /*NSString *queryStr = [NSString stringWithFormat:@"SELECT rowid, title FROM MOVIE limit %d, 1", (int)index];
    sqlite3_stmt *stmt;
    int ret = sqlite3_prepare_v2(db, [queryStr UTF8String], -1, &stmt, NULL);
    
    NSAssert2(SQLITE_OK == ret, @"Error(%d) on resolving data : %s", ret,sqlite3_errmsg(db));
    
    NSString *titleString;
    while (SQLITE_ROW == sqlite3_step(stmt)) {
        char *title = (char *)sqlite3_column_text(stmt, 1);
        titleString = [NSString stringWithCString:title encoding:NSUTF8StringEncoding];
        
    }
    
    sqlite3_finalize(stmt);*/
    return [data objectAtIndex:index];
    
}


- (NSInteger)getNumberOfActorsInMovie:(NSInteger)movieIndex {
    return 3;
}

- (NSString *)getNameOfActorAtIndex:(NSInteger)index inMovie:(NSInteger)movieIndex {
    return @"스칼렛요한슨";
}

- (void)addActorWithName:(NSString *)name inMovie:(NSInteger)movieIndex {
    
}

@end
