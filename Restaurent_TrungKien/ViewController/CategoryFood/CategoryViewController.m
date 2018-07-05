//
//  CategoryViewController.m
//  Restaurent_TrungKien
//
//  Created by Trung Kiên on 5/29/18.
//  Copyright © 2018 Trung Kiên. All rights reserved.
//

#import "CategoryViewController.h"
#import "AFNetworking.h"
#import "CategoryTableViewCell.h"
#import "Ulti.h"
#import "MBProgressHUD.h"
#import "Common.h"
#import "Category.h"
#import "OrderViewController.h"
#import "CatViewController.h"
#import "Global.h"
#import "UIView+Toast.h"
@interface CategoryViewController ()

@end

@implementation CategoryViewController {
 
    NSMutableArray *arrFoodInCategory;
    NSMutableArray *arrFoodSelected;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    arrFoodSelected = [[NSMutableArray alloc] init];
    arrFoodInCategory = [[NSMutableArray alloc]init];
    _lblTitle.text = [NSString stringWithFormat:@"Table %@",_tableNumber];
    [_tblView registerNib:[UINib nibWithNibName:@"CategoryTableViewCell" bundle:nil] forCellReuseIdentifier:@"CategoryTableViewCell"];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:true];
    [self getDataFromAPI];
}
#pragma mark Get data
-(void) getDataFromAPI {
    [arrFoodSelected removeAllObjects];
    [arrFoodInCategory removeAllObjects];
    arrFoodSelected = [[Ulti getArrayObjectFromNSUserDefault:ARR_FOOD_SELECTED_SAVE_KEY] mutableCopy];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL,PRODUCT];
    NSDictionary *param = @{@"CategoryId" : _idCategory};
    [manager GET:url parameters:param success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSArray *arrDataRespone = [responseObject objectForKey:@"data"];
        for (NSDictionary *dic in arrDataRespone) {
            Category *cat = [[Category alloc]init];
            cat.IDCategory = [dic objectForKey:@"id"];
            cat.codeCategory = [NSString stringWithFormat:@"%@",[dic objectForKey:@"code"]];
            cat.nameCategory = [dic objectForKey:@"name"];
            cat.priceCategory = [NSString stringWithFormat:@"%@",[dic objectForKey:@"price"]];
            cat.numberNameCategory = @"0";
            cat.isSelected = false;
            cat.categoryId = [dic objectForKey:@"categoryId"];
            if (arrFoodSelected.count >0) {
                int check =1;
                for (Category *objSelectedFood in arrFoodSelected) {
                    if ([objSelectedFood.categoryId isEqualToString:_idCategory]&[objSelectedFood.IDCategory isEqualToString:cat.IDCategory]) {
                        [arrFoodInCategory addObject:objSelectedFood];
                        check =0;
                        break;
                    }
                }
                if (check==1) {
                    [arrFoodInCategory addObject:cat];
                    
                }
            }else{
                [arrFoodInCategory addObject:cat];
            }
        }
        if (arrFoodInCategory.count == 0) {
            [self.view makeToast:@"NO DATA"
                        duration:1.0
                        position:CSToastPositionTop];
        }
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [_tblView reloadData];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
    self.searchResult = [NSMutableArray arrayWithCapacity:[arrFoodInCategory count]];
    [_tblView reloadData];
}
#pragma mark Table View
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrFoodInCategory.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (100-tableView.bounds.size.height/6)?100:tableView.bounds.size.height;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CategoryTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    Category *cat = [arrFoodInCategory objectAtIndex:indexPath.row];
    cell.lblNameCategory.text = cat.nameCategory;
    cell.lblPriceCategory.text = cat.priceCategory;
    cell.lblStatus.text = cat.codeCategory;
    cell.lblNumberCategory.text = cat.numberNameCategory;
    [cell.btnPlus addTarget:self action:(@selector(onPlus:)) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnMinus addTarget:self action:(@selector(onMinus:)) forControlEvents:UIControlEventTouchUpInside];
    cell.btnPlus.tag = indexPath.row;
    cell.btnMinus.tag = indexPath.row;
    return cell;
}
#pragma mark Delete
-(void)saveSelectedFood{
    NSMutableArray *arrToDelete = [[NSMutableArray alloc]init];
    
    for (Category *obj in arrFoodInCategory) {
        if ([obj.numberNameCategory intValue]>0) {
            [arrToDelete removeAllObjects];
            for (Category *objSelected in arrFoodSelected) {
                if ([objSelected.IDCategory isEqualToString:obj.IDCategory]) {
                    [arrToDelete addObject:objSelected];
                }
            }
            [arrFoodSelected removeObjectsInArray:arrToDelete];
            [arrFoodSelected addObject:obj];
        }
    }
    [Ulti removeObjectForKey:ARR_FOOD_SELECTED_SAVE_KEY];
    [Ulti saveArrayObjectToNSUserDefault:arrFoodSelected forkey:ARR_FOOD_SELECTED_SAVE_KEY];
    
}
#pragma mark Plus Category
- (IBAction)onPlus:(id)sender {
    int i = (int)[sender tag];
    Category *obj = [arrFoodInCategory objectAtIndex:i];
    int value = [obj.numberNameCategory intValue];
    obj.numberNameCategory = [NSString stringWithFormat:@"%@",[NSNumber numberWithInt:value + 1]];
    [arrFoodInCategory replaceObjectAtIndex:i withObject:obj];
    
}
#pragma mark Minus Category
- (IBAction)onMinus:(id)sender {
    int i = (int)[sender tag];
    Category *obj = [arrFoodInCategory objectAtIndex:i];
    int value = [obj.numberNameCategory intValue];
    obj.numberNameCategory = [NSString stringWithFormat:@"%@",[NSNumber numberWithInt:value - 1]];
    [arrFoodInCategory replaceObjectAtIndex:i withObject:obj];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
#pragma mark Order
- (IBAction)onOrder:(id)sender {
    [self saveSelectedFood];
    OrderViewController *order = [[OrderViewController alloc]init];
    order.tableNumber = _tableNumber;
    order.arrFoodImage = _arrFoodImage;
    order.indexImage = _indexImage;
    [self.navigationController pushViewController:order animated:true];
}
- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}
#pragma mark Cart
- (IBAction)onCart:(id)sender {
    [self saveSelectedFood];
    CatViewController *cart = [[CatViewController alloc]init];
    cart.tableId = _tableNumber;
    [self.navigationController pushViewController:cart animated:true];
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
