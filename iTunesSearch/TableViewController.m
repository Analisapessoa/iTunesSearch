//
//  ViewController.m
//  iTunesSearch
//
//  Created by joaquim on 09/03/15.
//  Copyright (c) 2015 joaquim. All rights reserved.
//

#import "TableViewController.h"
#import "TableViewCell.h"
#import "iTunesManager.h"
#import "Entidades/Filme.h"
#import "Musica.h"

@interface TableViewController () {
    NSArray *midias;
    NSArray *musicas;
}

@property iTunesManager *itunes;

@end

@implementation TableViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINib *nib = [UINib nibWithNibName:@"TableViewCell" bundle:nil];
    [self.tableview registerNib:nib forCellReuseIdentifier:@"celulaPadrao"];
    
    _itunes = [iTunesManager sharedInstance];
    
    musicas = [_itunes buscarMusicas:@"Apple"];
    midias = [_itunes buscarMidias:@"Apple"];

    
//#warning Necessario para que a table view tenha um espaco em relacao ao topo, pois caso contrario o texto ficara atras da barra superior
    //self.tableview.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableview.bounds.size.width, 25.f)];
    
}

//metodo para esconder a barra de cima
-(BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Metodos do UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [midias count];
            if(section == 0)
            {
             return [midias count];
            }
            else
                {
                    return [musicas count];
                }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *celula = [self.tableview dequeueReusableCellWithIdentifier:@"celulaPadrao"];
    
    if(indexPath.section == 0){
               Filme *filme = [midias objectAtIndex:indexPath.row];
                [celula.nome setText:filme.nome];
                [celula.tipo setText:filme.tipo];
                [celula.pais setText:filme.pais];
                [celula.genero setText:filme.genero];
        NSTimeInterval theTimeInterval = [filme.duracao intValue]/1000;
            NSCalendar *sysCalendar = [NSCalendar currentCalendar];
            NSDate *date1 = [[NSDate alloc] init];
            NSDate *date2 = [[NSDate alloc] initWithTimeInterval:theTimeInterval sinceDate:date1];
            NSCalendarUnit unitFlags = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
            NSDateComponents *conversionInfo = [sysCalendar components:unitFlags fromDate:date1 toDate:date2  options:0];
            [celula.duracao setText:[NSString stringWithFormat:@"%ld:%ld:%ld",(long)conversionInfo.hour,(long)conversionInfo.minute, (long)conversionInfo.second]];
            }
    else{
                Musica *musica = [musicas objectAtIndex:indexPath.row];
                [celula.nome setText:musica.nome];
                [celula.tipo setText:musica.tipo];
                [celula.genero setText:musica.genero];
                [celula.pais setText:musica.pais];
        NSTimeInterval theTimeInterval = [musica.duracao intValue]/1000;
            NSCalendar *sysCalendar = [NSCalendar currentCalendar];
            NSDate *date1 = [[NSDate alloc] init];
            NSDate *date2 = [[NSDate alloc] initWithTimeInterval:theTimeInterval sinceDate:date1];
            NSCalendarUnit unitFlags = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
            NSDateComponents *conversionInfo = [sysCalendar components:unitFlags fromDate:date1 toDate:date2  options:0];
            [celula.duracao setText:[NSString stringWithFormat:@"%ld:%ld:%ld",(long)conversionInfo.hour,(long)conversionInfo.minute, (long)conversionInfo.second]];
            }
    return celula;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
        if(section == 0)
        {
            return @"Filme";
            }
        else
            {
                return @"Musica";
            }
    }

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.searchBar resignFirstResponder];
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    iTunesManager *itunes = [iTunesManager sharedInstance];
    midias = [itunes buscarMidias:searchBar.text];
    [self.tableview reloadData];
}
@end
