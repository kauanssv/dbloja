drop database dbloja;
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
    
    foreign key (fk_id_folha_pagamento) references tb_folha_pagamento(pk_id_folha_pagamento),
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
create table tb_endereco(
	pk_cep char(8),
    pk_numero int,
    fk_id_pessoa int,
    fk_id_fornecedor int,
    complemento varchar(60),
    
    primary key (pk_cep, pk_numero),
    
    foreign key (fk_id_pessoa) references tb_pessoa(pk_id_pessoa),
    foreign key (fk_id_fornecedor) references tb_fornecedor(pk_id_fornecedor),
    
    index idx_id_pessoa_endereco (fk_id_pessoa),
    index idx_id_fornecedor_endereco(fk_id_fornecedor)
);
create table tb_contrato_fornecedor(
	pk_id_contrato_fornecedor int primary key auto_increment,
    fk_id_fornecedor int,
    data_contrato date not null,
    status_contrato enum('Ativo', 'Cancelado', 'Pausado', 'Concluido') not null,
    
    foreign key (fk_id_fornecedor) references tb_fornecedor(pk_id_fornecedor),
    
    index idx_id_fornecedor_contrato_fornecedor(fk_id_fornecedor)
);
create table tb_categoria_produto(
	pk_id_categoria_produto int primary key auto_increment,
    nome_categoria varchar(80) not null unique
);
create table tb_produto(
	pk_id_produto int primary key auto_increment,
    fk_id_fornecedor int,
    fk_id_categoria_produto int,
    nome_produto varchar(100) unique not null,
    preco_base decimal(10,2) not null,
    
    foreign key (fk_id_fornecedor) references tb_fornecedor(pk_id_fornecedor),
    foreign key (fk_id_categoria_produto) references tb_categoria_produto(pk_id_categoria_produto),
    
    index idx_id_fornecedor_produto(fk_id_fornecedor),
    index idx_id_categoria_produto(fk_id_categoria_produto)
);
create table tb_pedido(
	pk_id_pedido int primary key auto_increment,
    fk_id_cliente int,
    valor_total decimal(10,2) not null,
    
    foreign key (fk_id_cliente) references tb_cliente(pk_id_cliente),
    
    index idx_cliente_cliente(fk_id_cliente)
);
create table tb_item_pedido(
	pk_id_item_pedido int primary key auto_increment,
	fk_id_pedido int,
	fk_id_produto int,
	quantidade int not null,
	preco_unitario decimal(10,2) not null,
	desconto decimal(10,2) not null,
	  
	foreign key (fk_id_pedido) references tb_pedido(pk_id_pedido),
	foreign key (fk_id_produto) references tb_produto(pk_id_produto),
	  
	index idx_pedido_item_pedido(fk_id_pedido),
	index idx_produto_item_pedido(fk_id_produto)
);
create table tb_pagamento(
	pk_id_pagamento int primary key auto_increment,
	fk_id_pedido int not null,
	forma_pagamento enum('Pix', 'Dinheiro', 'Cartao_credito', 'Cartao_debito', 'Boleto') not null,
	quantidade_parcelas int not null,
	valor_pago decimal(10,2) not null,
	status_pagamento enum('Pendente', 'Aprovado', 'Recusado', 'Cancelado', 'Estornado') not null,
	data_pagamento date,
  
	foreign key (fk_id_pedido) references tb_pedido(pk_id_pedido),
    
    index idx_pedido_pagamento(fk_id_pedido)
);
create table tb_estoque(
	pk_id_estoque int primary key auto_increment,
	fk_id_produto int,
	quantidade_atual int not null,
	quantidade_minima int not null,
	quantidade_maxima int,
	localizacao varchar(100),
	status_estoque enum('Disponivel', 'Baixo', 'Esgotado', 'Bloqueado') not null,
	data_ultima_atualizacao datetime not null,
    
    foreign key (fk_id_produto) references tb_produto(pk_id_produto),
    
    index idx_produto_estoque(fk_id_produto)
);











