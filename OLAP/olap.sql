create database dwloja;
use dwloja;

create table dim_tempo(
	sk_tempo int primary key auto_increment, -- sk significa surrogate key que é a pk do OLAP
    data_completa date not null unique,
    dia int not null,
    mes int not null,
    nome_mes varchar(20) not null,
    trimestre int not null,
    ano int not null
);
create table dim_cliente(
	sk_cliente int primary key auto_increment,
	id_cliente_origem int not null unique,
	nome_cliente varchar(150) not null,
	cpf char(11) not null unique,
	genero varchar(20),
	data_nascimento date
);
create table dim_produto(
	sk_produto int primary key auto_increment,
    id_produto_origem int not null unique,
    nome_produto varchar(100) not null,
    preco_base decimal(10,2) not null
);
create table dim_categoria(
	sk_categoria int primary key auto_increment,
    id_categoria_origem INT NOT NULL UNIQUE,
    nome_categoria VARCHAR(80) NOT NULL
);

CREATE TABLE dim_fornecedor (
    sk_fornecedor INT PRIMARY KEY AUTO_INCREMENT,
    id_fornecedor_origem INT NOT NULL UNIQUE,
    nome_fornecedor VARCHAR(70) NOT NULL
);
CREATE TABLE dim_pagamento (
    sk_pagamento INT PRIMARY KEY AUTO_INCREMENT,
    forma_pagamento VARCHAR(30) NOT NULL,
    quantidade_parcelas INT NOT NULL,
    
	CONSTRAINT uk_dim_pagamento UNIQUE (forma_pagamento, quantidade_parcelas)
);

-- tabela fato

create table fato_vendas(
	sk_fato_venda int primary key auto_increment,
    
    sk_tempo int not null,
    sk_cliente int not null,
    sk_produto int not null,
    sk_categoria int not null,
    sk_fornecedor int not null,
	sk_pagamento int not null,
    
    id_pedido_origem INT NOT NULL,
    id_item_pedido_origem INT NOT NULL,

    quantidade_vendida INT NOT NULL,
    preco_unitario DECIMAL(10,2) NOT NULL,
    valor_bruto DECIMAL(10,2) NOT NULL,
    valor_desconto DECIMAL(10,2) NOT NULL,
    valor_liquido DECIMAL(10,2) NOT NULL,

    CONSTRAINT fk_fato_tempo
        FOREIGN KEY (sk_tempo) REFERENCES dim_tempo(sk_tempo),

    CONSTRAINT fk_fato_cliente
        FOREIGN KEY (sk_cliente) REFERENCES dim_cliente(sk_cliente),

    CONSTRAINT fk_fato_produto
        FOREIGN KEY (sk_produto) REFERENCES dim_produto(sk_produto),

    CONSTRAINT fk_fato_categoria
        FOREIGN KEY (sk_categoria) REFERENCES dim_categoria(sk_categoria),

    CONSTRAINT fk_fato_fornecedor
        FOREIGN KEY (sk_fornecedor) REFERENCES dim_fornecedor(sk_fornecedor),

    CONSTRAINT fk_fato_pagamento
        FOREIGN KEY (sk_pagamento) REFERENCES dim_pagamento(sk_pagamento),

    INDEX idx_fato_tempo (sk_tempo),
    INDEX idx_fato_cliente (sk_cliente),
    INDEX idx_fato_produto (sk_produto),
    INDEX idx_fato_categoria (sk_categoria),
    INDEX idx_fato_fornecedor (sk_fornecedor),
    INDEX idx_fato_pagamento (sk_pagamento),
    INDEX idx_fato_pedido_origem (id_pedido_origem)
    
);