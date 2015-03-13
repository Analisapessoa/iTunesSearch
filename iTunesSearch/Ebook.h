//
//  Ebook.h
//  iTunesSearch
//
//  Created by Ana Elisa Pessoa Aguiar on 13/03/15.
//  Copyright (c) 2015 joaquim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Ebook : NSObject

@property (nonatomic, strong) NSString *nome;
@property (nonatomic, strong) NSString *trackId;
@property (nonatomic, strong) NSString *artista;
@property (nonatomic, strong) NSString *duracao;
@property (nonatomic, strong) NSString *genero;
@property (nonatomic, strong) NSString *pais;
@property (nonatomic, strong) NSString *tipo;
@property (nonatomic, strong) NSString *preco;
@property (nonatomic, strong) NSString *imagem;

@end
