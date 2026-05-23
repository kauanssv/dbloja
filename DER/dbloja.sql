CREATE TABLE `tb_pessoa` (
  `pk_id_pessoa` int PRIMARY KEY AUTO_INCREMENT,
  `primeiro_nome` varchar(40) NOT NULL,
  `sobrenome` varchar(100) NOT NULL,
  `cpf` char(11) UNIQUE NOT NULL,
  `data_nascimento` date NOT NULL,
  `genero` enum(Masculino,Feminino,Outro) NOT NULL
);

CREATE TABLE `tb_fornecedor` (
  `pk_id_fornecedor` int PRIMARY KEY AUTO_INCREMENT,
  `nome_fornecedor` varchar(70) UNIQUE NOT NULL
);

CREATE TABLE `tb_funcionario` (
  `pk_id_funcionario` int PRIMARY KEY AUTO_INCREMENT,
  `fk_id_pessoa` int
);

CREATE TABLE `tb_cargo_funcionario` (
  `pk_id_cargo_funcionario` int PRIMARY KEY AUTO_INCREMENT,
  `cargo` enum(Gerente,Supervisor,Vendedor,Caixa,Estoquista,Atendente,Comprador,Auxiliar_administrativo,Analista_financeiro,Analista_rh,Tecnico_ti,Entregador,Operador_logistica) NOT NULL,
  `salario_base` decimal
);

CREATE TABLE `tb_folha_pagamento` (
  `pk_id_folha_pagamento` int PRIMARY KEY AUTO_INCREMENT,
  `mes` int NOT NULL,
  `ano` int NOT NULL,
  `data_abertura` date NOT NULL,
  `data_fechamento` date NOT NULL,
  `status_folha` enum(Aberta,Fechada,Paga,Cancelada) NOT NULL
);

CREATE TABLE `tb_contrato_funcionario` (
  `pk_id_contrato_funcionario` int PRIMARY KEY AUTO_INCREMENT,
  `fk_id_funcionario` int,
  `fk_id_cargo_funcionario` int,
  `data_contratacao` date,
  `status_contratacao` enum(Ativo,Inativo),
  `tipo_contratacao` enum(CLT,PJ),
  `salario_contrato` decimal
);

CREATE TABLE `tb_item_folha_pagamento` (
  `pk_id_item_folha_pagamento` int PRIMARY KEY AUTO_INCREMENT,
  `fk_id_folha_pagamento` int NOT NULL,
  `fk_id_contrato_funcionario` int NOT NULL,
  `salario_base` decimal(10,2) NOT NULL,
  `valor_bonus` decimal(10,2) NOT NULL DEFAULT 0,
  `valor_desconto` decimal(10,2) NOT NULL DEFAULT 0,
  `valor_liquido` decimal(10,2) NOT NULL,
  `data_pagamento` date
);

CREATE TABLE `tb_numero` (
  `pk_ddd` char(2),
  `pk_numero` char(9),
  `fk_id_pessoa` int,
  `fk_id_fornecedor` int,
  `tipo_numero` enum(Pessoa fisica,Empresarial)
);

CREATE TABLE `tb_email` (
  `pk_email` varchar(70) PRIMARY KEY,
  `fk_id_pessoa` int,
  `fk_id_fornecedor` int,
  `tipo_email` enum(pessoa fisica,empresarial)
);

CREATE TABLE `tb_contrato_fornecedor` (
  `pk_id_contrato_fornecedor` int PRIMARY KEY AUTO_INCREMENT,
  `fk_id_fornecedor` int,
  `data_contrato` date,
  `status_contrato` enum(Ativo,Cancelado,Pausado,Concluido)
);

CREATE UNIQUE INDEX `tb_folha_pagamento_index_0` ON `tb_folha_pagamento` (`mes`, `ano`);

CREATE UNIQUE INDEX `tb_item_folha_pagamento_index_1` ON `tb_item_folha_pagamento` (`fk_id_folha_pagamento`, `fk_id_contrato_funcionario`);

CREATE UNIQUE INDEX `tb_numero_index_2` ON `tb_numero` (`pk_ddd`, `pk_numero`, `fk_id_pessoa`);

CREATE UNIQUE INDEX `tb_numero_index_3` ON `tb_numero` (`pk_ddd`, `pk_numero`, `fk_id_fornecedor`);

CREATE UNIQUE INDEX `tb_email_index_4` ON `tb_email` (`pk_email`, `fk_id_pessoa`);

CREATE UNIQUE INDEX `tb_email_index_5` ON `tb_email` (`pk_email`, `fk_id_fornecedor`);

CREATE UNIQUE INDEX `tb_contrato_fornecedor_index_6` ON `tb_contrato_fornecedor` (`fk_id_fornecedor`, `pk_id_contrato_fornecedor`, `data_contrato`);

ALTER TABLE `tb_numero` ADD FOREIGN KEY (`fk_id_pessoa`) REFERENCES `tb_pessoa` (`pk_id_pessoa`);

ALTER TABLE `tb_email` ADD FOREIGN KEY (`fk_id_pessoa`) REFERENCES `tb_pessoa` (`pk_id_pessoa`);

ALTER TABLE `tb_numero` ADD FOREIGN KEY (`fk_id_fornecedor`) REFERENCES `tb_fornecedor` (`pk_id_fornecedor`);

ALTER TABLE `tb_email` ADD FOREIGN KEY (`fk_id_fornecedor`) REFERENCES `tb_fornecedor` (`pk_id_fornecedor`);

ALTER TABLE `tb_contrato_fornecedor` ADD FOREIGN KEY (`fk_id_fornecedor`) REFERENCES `tb_fornecedor` (`pk_id_fornecedor`);

ALTER TABLE `tb_pessoa` ADD FOREIGN KEY (`pk_id_pessoa`) REFERENCES `tb_funcionario` (`pk_id_funcionario`);

ALTER TABLE `tb_contrato_funcionario` ADD FOREIGN KEY (`pk_id_contrato_funcionario`) REFERENCES `tb_funcionario` (`pk_id_funcionario`);

ALTER TABLE `tb_cargo_funcionario` ADD FOREIGN KEY (`pk_id_cargo_funcionario`) REFERENCES `tb_contrato_funcionario` (`fk_id_cargo_funcionario`);

ALTER TABLE `tb_item_folha_pagamento` ADD FOREIGN KEY (`fk_id_folha_pagamento`) REFERENCES `tb_folha_pagamento` (`pk_id_folha_pagamento`);

ALTER TABLE `tb_item_folha_pagamento` ADD FOREIGN KEY (`fk_id_contrato_funcionario`) REFERENCES `tb_contrato_funcionario` (`pk_id_contrato_funcionario`);
