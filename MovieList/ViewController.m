//
//  ViewController.m
//  MovieList
//
//  Created by T on 2014. 1. 14..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "ViewController.h"
#import "MovieCenter.h"

@interface ViewController ()<UITableViewDataSource, UITextFieldDelegate,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *table;

@end

@implementation ViewController {
    MovieCenter *_movieCenter;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _movieCenter = [MovieCenter sharedMovieCenter];
    [self.table reloadData];
    [_movieCenter first];
    [_movieCenter openDB];
    

    
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.table reloadData];
    [textField resignFirstResponder];
    [_movieCenter addData:textField.text];
    return YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_movieCenter getNumberOfMovies];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MOVIE_CELL" forIndexPath:indexPath];
    cell.textLabel.text = [_movieCenter getNameOfMovieAtIndex:indexPath.row];
    return cell;
}



- (void)viewWillAppear:(BOOL)animated {
    [self.table reloadData];
    [self.navigationController setNavigationBarHidden:YES];
    
   

    
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.table reloadData];
    [self.navigationController setNavigationBarHidden:NO];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}

@end
