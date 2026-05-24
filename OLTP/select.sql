use dbloja;

select p.pk_id_pessoa as 'ID',concat(p.primeiro_nome, ' ' , p.sobrenome) as 'nome completo', p.cpf as 'CPF', cf.cargo as 'Cargo Atual' from tb_pessoa p
join tb_funcionario f on p.pk_id_pessoa = f.fk_id_pessoa
join tb_contrato_funcionario cfu on pk_id_funcionario = fk_id_funcionario
join tb_cargo_funcionario cf on fk_id_cargo_funcionario = pk_id_cargo_funcionario
where cargo like 'Vendedor' or cargo like 'Gerente';

select genero, count(*) as 'total pessoas' from tb_pessoa group by genero;

select distinct genero from tb_pessoa;

select fk_id_cliente, sum(valor_total) as 'valor_total' from tb_pedido group by fk_id_cliente;

select status_contratacao, count(*) as 'Media de status' from tb_contrato_funcionario group by status_contratacao;

select p.pk_id_pessoa as 'ID',concat(p.primeiro_nome, ' ' , p.sobrenome) as 'nome completo', p.cpf as 'CPF', count(cargo) as 'Quantidade cargos' from tb_pessoa p
join tb_funcionario f on p.pk_id_pessoa = f.fk_id_pessoa
join tb_contrato_funcionario cfu on pk_id_funcionario = fk_id_funcionario
join tb_cargo_funcionario cf on fk_id_cargo_funcionario = pk_id_cargo_funcionario
group by p.pk_id_pessoa 
having cpf like '%4%'
order by id asc;