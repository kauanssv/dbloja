create database dbloja;
use dbloja;

/*Criando as tabelas*/

create table tb_pessoa(
	pk_id_pessoa int primary key auto_increment,
    primeiro_nome varchar(40) not null,
    sobrenome varchar(100) not null,
    cpf char(11) not null unique,
    data_nascimento date not null,
    genero enum('Masculino', 'Feminino', 'Outro') default 'Masculino' not null
);
create table tb_cliente(
	pk_id_cliente int primary key auto_increment,
    fk_id_pessoa int,
    
    foreign key (fk_id_pessoa) references tb_pessoa(pk_id_pessoa),
    
    index idx_cliente_pessoa (fk_id_pessoa)
);
create table tb_fornecedor(
	pk_id_fornecedor int primary key auto_increment,
    nome_fornecedor varchar(70) not null
);
create table tb_funcionario(
	pk_id_funcionario int primary key auto_increment,
    fk_id_pessoa int, 
    
    foreign key (fk_id_pessoa) references tb_pessoa(pk_id_pessoa),
    
    index idx_pessoa_funcionario (fk_id_pessoa)
);
create table tb_cargo_funcionario(
	pk_id_cargo_funcionario int primary key auto_increment,
    cargo enum('Gerente', 'Supervisor', 'Vendedor', 'Caixa', 
    'Estoquista', 'Atendente', 'Comprador', 'Auxiliar_administrativo', 
    'Analista_financeiro', 'Analista_rh', 'Tecnico_ti', 'Entregador', 
    'Operador_logistica') default 'Vendedor' not null,
    salario_base decimal(10,2) not null
);
create table tb_contrato_funcionario(
	pk_id_contrato_funcionario int primary key auto_increment,
    fk_id_funcionario int,
    fk_id_cargo_funcionario int,
    data_contratacao date not null,
    data_demissao date,
    status_contratacao enum('Ativo', 'Inativo') not null,
    tipo_contratacao enum('CLT', 'PJ') not null,
    salario_contrato decimal(10,2) not null,
    
    foreign key (fk_id_funcionario) references tb_funcionario(pk_id_funcionario),
    foreign key (fk_id_cargo_funcionario) references tb_cargo_funcionario(pk_id_cargo_funcionario),
    
    index idx_funcionario_contrato_funcionario (fk_id_funcionario),
    index idx_cargo_funcionario_contrato_funcionario (fk_id_cargo_funcionario)
);
create table tb_folha_pagamento(
	pk_id_folha_pagamento int primary key auto_increment,
    mes int not null,
    ano int not null,
    data_abertura date not null,
    data_fechamento date,
    status_folha enum('Aberta', 'Fechada', 'Paga', 'Cancelada') not null,
    
    constraint uk_folha_pagamento_mes_ano unique(ano, mes)
);
create table tb_item_folha_pagamento(
	pk_id_item_folha_pagamento int primary key auto_increment,
    fk_id_folha_pagamento int,
    fk_id_contrato_funcionario int,
    salario_referencia decimal(10,2) not null,
    valor_bonus decimal(10,2) not null,
    valor_desconto decimal(10,2) not null,
    valor_liquido decimal(10,2) not null,
    data_pagamento date not null,
    
    foreign key (fk_id_folha_pagamento) references tb_folha_pagamento(fk_id_folha_pagamento),
    foreign key (fk_id_contrato_funcionario) references tb_contrato_funcionario(pk_id_contrato_funcionario),
    
    index idx_id_folha_pagamento_item_folha_pagamento (fk_id_folha_pagamento),
    index idx_id_folha_pagamento_contrato_funcionario (fk_id_contrato_funcionario),
    
    constraint uk_item_folha_pagamento_id_folha_id_contrato unique (fk_id_folha_pagamento, fk_id_contrato_funcionario)
);
create table tb_numero(
	pk_ddd char(2),
    pk_numero char(9),
    fk_id_pessoa int,
    fk_id_fornecedor int,
    tipo_numero enum('Pessoa_fisica', 'Empresarial')default 'Pessoa_fisica' not null,
    
    primary key (pk_ddd, pk_numero),
    
	foreign key (fk_id_pessoa) references tb_pessoa(pk_id_pessoa),
    foreign key (fk_id_fornecedor) references tb_fornecedor(pk_id_fornecedor),
    
    constraint uk_ddd_numero_pessoa unique(pk_ddd, pk_numero, fk_id_pessoa),
    constraint uk_ddd_numero_fornecedor unique(pk_ddd, pk_numero, fk_id_fornecedor)
);
create table tb_email(
	pk_email varchar(70) primary key,
    fk_id_pessoa int,
    fk_id_fornecedor int,
    tipo_email enum('Pessoa_fisica', 'Empresarial') not null,
    
    foreign key (fk_id_pessoa) references tb_pessoa(pk_id_pessoa),
    foreign key (fk_id_fornecedor) references tb_fornecedor(pk_id_fornecedor),
    
    index idx_id_pessoa_email (fk_id_pessoa),
    index idx_id_fornecedor_email (fk_id_fornecedor)
);


















