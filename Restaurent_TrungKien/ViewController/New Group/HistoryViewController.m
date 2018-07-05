//
//  HistoryViewController.m
//  Restaurent_TrungKien
//
//  Created by Trung Kiên on 6/7/18.
//  Copyright © 2018 Trung Kiên. All rights reserved.
//

#import "HistoryViewController.h"
#import "HistoryTableViewCell.h"
#import "Ulti.h"
#import "history.h"
@interface HistoryViewController ()

@end

@implementation HistoryViewController {
    NSMutableArray *arrHistory;
    int sumtotal;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    arrHistory = [[NSMutableArray alloc]init];
    [_tblView registerNib:[UINib nibWithNibName:@"HistoryTableViewCell" bundle:nil] forCellReuseIdentifier:@"HistoryTableViewCell"];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:true];
    NSArray *arr = [[Ulti getArrayObjectFromNSUserDefault:@"history"] mutableCopy];
    arrHistory = [[NSMutableArray alloc]initWithArray:arr];
    [_tblView reloadData];
    for (history *h in arrHistory) {
        sumtotal += [h.price intValue];
    }
    _lblTotal.text = [NSString stringWithFormat:@"Total : $ %d",sumtotal];
}
#pragma mark Table View
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrHistory.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    history *h = [arrHistory objectAtIndex:indexPath.row];
    HistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HistoryTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.lblDate.text = h.date;
    cell.lblTable.text = h.table;
    cell.lblPrice.text = h.price;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
