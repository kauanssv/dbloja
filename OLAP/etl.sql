-- Cliente
insert into dwloja.dim_cliente(
	id_cliente_origem,
    nome_cliente,
    cpf,
    genero,
    data_nascimento
)
select 
	c.pk_id_cliente,
    concat(p.primeiro_nome, ' ', p.sobrenome),
    p.cpf,
    p.genero,
    p.data_nascimento
from dbloja.tb_cliente c
inner join dbloja.tb_pessoa p
	on c.fk_id_pessoa = p.pk_id_pessoa;
   
-- Categoria

insert into dwloja.dim_categoria(
	id_categoria_origem,
    nome_categoria
)
select
	pk_id_categoria_produto,
    nome_categoria
from dbloja.tb_categoria_produto;
	
-- Fornecedor

insert into dwloja.dim_fornecedor(
	id_fornecedor_origem,
    nome_fornecedor
)    
select
	pk_id_fornecedor,
    nome_fornecedor
from dbloja.tb_fornecedor;
	
-- Produto

insert into dwloja.dim_produto(
	id_produto_origem,
    nome_produto,
    preco_base
)
select
	pk_id_produto,
    nome_produto,
    preco_base
from dbloja.tb_produto;
    
-- pagamento

INSERT INTO dwloja.dim_pagamento (
    forma_pagamento,
    quantidade_parcelas
)
SELECT DISTINCT
    forma_pagamento,
    quantidade_parcelas
FROM dbloja.tb_pagamento;

-- Tempo 

INSERT INTO dwloja.dim_tempo (
    data_completa,
    dia,
    mes,
    nome_mes,
    trimestre,
    ano
)
SELECT DISTINCT
    data_pagamento,
    DAY(data_pagamento),
    MONTH(data_pagamento),
    MONTHNAME(data_pagamento),
    QUARTER(data_pagamento),
    YEAR(data_pagamento)
FROM dbloja.tb_pagamento
WHERE data_pagamento IS NOT NULL;

-- Fato

INSERT INTO dwloja.fato_vendas (
    sk_tempo,
    sk_cliente,
    sk_produto,
    sk_categoria,
    sk_fornecedor,
    sk_pagamento,
    id_pedido_origem,
    id_item_pedido_origem,
    quantidade_vendida,
    preco_unitario,
    valor_bruto,
    valor_desconto,
    valor_liquido
)
SELECT
    dt.sk_tempo,
    dc.sk_cliente,
    dp.sk_produto,
    dcat.sk_categoria,
    df.sk_fornecedor,
    dpg.sk_pagamento,

    ped.pk_id_pedido,
    ip.pk_id_item_pedido,

    ip.quantidade,
    ip.preco_unitario,
    ip.quantidade * ip.preco_unitario AS valor_bruto,
    ip.desconto AS valor_desconto,
    (ip.quantidade * ip.preco_unitario) - ip.desconto AS valor_liquido

FROM dbloja.tb_item_pedido ip
INNER JOIN dbloja.tb_pedido ped
    ON ip.fk_id_pedido = ped.pk_id_pedido

INNER JOIN dbloja.tb_produto prod
    ON ip.fk_id_produto = prod.pk_id_produto

INNER JOIN dbloja.tb_pagamento pag
    ON pag.fk_id_pedido = ped.pk_id_pedido

INNER JOIN dwloja.dim_tempo dt
    ON dt.data_completa = pag.data_pagamento

INNER JOIN dwloja.dim_cliente dc
    ON dc.id_cliente_origem = ped.fk_id_cliente

INNER JOIN dwloja.dim_produto dp
    ON dp.id_produto_origem = prod.pk_id_produto

INNER JOIN dwloja.dim_categoria dcat
    ON dcat.id_categoria_origem = prod.fk_id_categoria_produto

INNER JOIN dwloja.dim_fornecedor df
    ON df.id_fornecedor_origem = prod.fk_id_fornecedor

INNER JOIN dwloja.dim_pagamento dpg
    ON dpg.forma_pagamento = pag.forma_pagamento
   AND dpg.quantidade_parcelas = pag.quantidade_parcelas

WHERE pag.data_pagamento IS NOT NULL;