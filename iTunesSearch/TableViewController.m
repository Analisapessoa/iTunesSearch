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
#import "Ebook.h"

@interface TableViewController () {
    NSArray *midias;
    NSArray *musicas;
    NSArray *ebooks;
    NSUserDefaults *ud;
}

@property iTunesManager *itunes;

@end

@implementation TableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINib *nib = [UINib nibWithNibName:@"TableViewCell" bundle:nil];
    [self.tableview registerNib:nib forCellReuseIdentifier:@"celulaPadrao"];
    
    _itunes = [iTunesManager sharedInstance];
    
    ud = [NSUserDefaults standardUserDefaults];
    NSString *ultimapesquisa = [ud objectForKey:@"ultimapesquisa"];
    
    musicas = [_itunes buscarMusicas:ultimapesquisa];
    midias = [_itunes buscarMidias:ultimapesquisa];
    ebooks = [_itunes buscarEBooks:ultimapesquisa];

    
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
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
            if(section == 0)
            {
             return [midias count];
            }
            else if(section ==1)
                {
                    return [musicas count];
                }
                 else
                {
                    return[ebooks count];
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
        [celula.image setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:filme.imagem]]]];
        NSTimeInterval theTimeInterval = [filme.duracao intValue]/1000;
            NSCalendar *sysCalendar = [NSCalendar currentCalendar];
            NSDate *date1 = [[NSDate alloc] init];
            NSDate *date2 = [[NSDate alloc] initWithTimeInterval:theTimeInterval sinceDate:date1];
            NSCalendarUnit unitFlags = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
            NSDateComponents *conversionInfo = [sysCalendar components:unitFlags fromDate:date1 toDate:date2  options:0];
            [celula.duracao setText:[NSString stringWithFormat:@"%ld:%ld:%ld",(long)conversionInfo.hour,(long)conversionInfo.minute, (long)conversionInfo.second]];
            }
    else if(indexPath.section ==1)
            {
                Musica *musica = [musicas objectAtIndex:indexPath.row];
                [celula.nome setText:musica.nome];
                [celula.tipo setText:musica.tipo];
                [celula.genero setText:musica.genero];
                [celula.pais setText:musica.pais];
                [celula.image setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:musica.imagem]]]];

        NSTimeInterval theTimeInterval = [musica.duracao intValue]/1000;
            NSCalendar *sysCalendar = [NSCalendar currentCalendar];
            NSDate *date1 = [[NSDate alloc] init];
            NSDate *date2 = [[NSDate alloc] initWithTimeInterval:theTimeInterval sinceDate:date1];
            NSCalendarUnit unitFlags = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
            NSDateComponents *conversionInfo = [sysCalendar components:unitFlags fromDate:date1 toDate:date2  options:0];
            [celula.duracao setText:[NSString stringWithFormat:@"%ld:%ld:%ld",(long)conversionInfo.hour,(long)conversionInfo.minute, (long)conversionInfo.second]];
            }
            else
            {
                Ebook *ebook = [ebooks objectAtIndex:indexPath.row];
                [celula.nome setText:ebook.nome];
                [celula.tipo setText:ebook.tipo];
                [celula.genero setText:ebook.artista];
                [celula.pais setText:ebook.preco];
                [celula.duracao setText:@""];
                [celula.image setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:ebook.imagem]]]];

                

            }
    return celula;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
        if(section == 0)
        {
            return @"Filme";
            }
        else if(section ==1)
            {
                return @"Música";
            }
            else
            {
            return @"Ebook";
            }
    }

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.searchBar resignFirstResponder];
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *text = searchBar.text;
    
    iTunesManager *itunes = [iTunesManager sharedInstance];
    NSError *error = NULL;
        if (!searchBar.text) {
                searchBar.text = @"";
            }
        NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:@"^[A-Z0-9a-z_+-]{2,100}$" options:NSRegularExpressionCaseInsensitive error:&error];
        if (error) {
                NSLog(@"Não foi possível fazer a busca. ERRO: %@", error);
                return;
            }
    
    midias = [itunes buscarMidias:searchBar.text];
    musicas = [itunes buscarMusicas:searchBar.text];
    ebooks = [itunes buscarEBooks:searchBar.text];
    [ud setObject:searchBar.text forKey:@"ultimapesquisa"];
    [self.tableview reloadData];
}
@end
