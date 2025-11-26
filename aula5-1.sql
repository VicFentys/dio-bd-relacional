INSERT INTO usuarios (nome, email, data_nascimento, rua, numero, cidade, estado) VALUES ('Usuario sem reservas', 'semreservar@teste.com', '1990-10-10', 'Rua','123','cidade','estado');

-- Traz apenas os usuario com reservas
SELECT * FROM usuarios us
INNER JOIN reservas rs
	ON us.id = rs.id_usuario;

-- Traz todos os usuario e suas reservas se tiver
SELECT * FROM viagens_usuarios us
INNER JOIN viagens_reservas rs
	ON us.id = rs.id_usuario;

INSERT INTO viagens.destinos ( nome, descricao) VALUES 
('Deestino sem reserva', 'Uma bela praia com areias brancas e mar cristalino')

-- Tras todos os destinos e as reservas se tiverem -- 
SELECT * FROM viagens_reservas rs
RIGHT JOIN viagens_destinos des
	ON des.id = rs.id_destino;

-- Produz o mesmo resultado que a anterior
SELECT * FROM viagens_destinos des
LEFT JOIN viagens_reservas rs
	ON des.id = rs.id_destino;

-- SUb consultas

-- Usuários que não fizeram nenhuma reserva
SELECT nome
FROM viagens_usuarios
WHERE id NOT IN (SELECT id_usuario FROM viagens_reservas);

-- Subconsulta para encontrar os destinos menos populares (com menos reservas):

SELECT nome
FROM viagens_destinos
WHERE id NOT IN (SELECT id_destino FROM viagens_reservas)
ORDER BY id;

-- contagem de reservas por usuario

SELECT nome, (SELECT COUNT(*) FROM viagens_reservas
WHERE id_usuario = viagens_usuarios.id) AS total_reservas
FROM viagens_usuarios;
