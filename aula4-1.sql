-- Adicionar colunas de endereço à tabela "Usuarios"
-- MySQL
ALTER TABLE viagens_usuarios
ADD rua VARCHAR(100),
ADD numero VARCHAR(10),
ADD cidade VARCHAR(50),
ADD estado VARCHAR(50);

-- SQL Server
ALTER TABLE viagens_usuarios
ADD rua   VARCHAR(100),
    numero VARCHAR(10),
    cidade VARCHAR(50),
    estado VARCHAR(50);

-- Copia os dados da tabela original para a nova tabela
-- MySQL
UPDATE viagens_usuarios
SET rua = SUBSTRING_INDEX(SUBSTRING_INDEX(endereco, ',', 1), ',', -1),
    numero = SUBSTRING_INDEX(SUBSTRING_INDEX(endereco, ',', 2), ',', -1),
    cidade = SUBSTRING_INDEX(SUBSTRING_INDEX(endereco, ',', 3), ',', -1),
    estado = SUBSTRING_INDEX(endereco, ',', -1);

-- SQL Server
UPDATE u
SET
    rua = LTRIM(RTRIM(LEFT(u.endereco, CASE WHEN pos.p1 > 0 THEN pos.p1 - 1 ELSE LEN(u.endereco) END))),
    numero = LTRIM(RTRIM(
        CASE 
            WHEN pos.p1 > 0 AND pos.p2 > pos.p1 THEN SUBSTRING(u.endereco, pos.p1 + 1, pos.p2 - pos.p1 - 1)
            WHEN pos.p1 > 0 THEN SUBSTRING(u.endereco, pos.p1 + 1, LEN(u.endereco))
            ELSE ''
        END
    )),
    cidade = LTRIM(RTRIM(
        CASE 
            WHEN pos.p2 > 0 AND pos.p3 > pos.p2 THEN SUBSTRING(u.endereco, pos.p2 + 1, pos.p3 - pos.p2 - 1)
            WHEN pos.p2 > 0 THEN SUBSTRING(u.endereco, pos.p2 + 1, LEN(u.endereco))
            ELSE ''
        END
    )),
    estado = LTRIM(RTRIM(
        CASE WHEN pos.p3 > 0 THEN SUBSTRING(u.endereco, pos.p3 + 1, LEN(u.endereco) - pos.p3)
             ELSE ''
        END
    ))
FROM Usuarios u
CROSS APPLY (
    SELECT
        CHARINDEX(',', u.endereco) AS p1,
        CHARINDEX(',', u.endereco, CHARINDEX(',', u.endereco) + 1) AS p2,
        CHARINDEX(',', u.endereco, CHARINDEX(',', u.endereco, CHARINDEX(',', u.endereco) + 1) + 1) AS p3
) pos;

-- OU

-- Atenção: PARSENAME só aceita até 4 partes e usa '.' como separador
UPDATE Usuarios
SET
    rua = LTRIM(RTRIM(PARSENAME(REPLACE(endereco, ',', '.'), 4))),
    numero = LTRIM(RTRIM(PARSENAME(REPLACE(endereco, ',', '.'), 3))),
    cidade = LTRIM(RTRIM(PARSENAME(REPLACE(endereco, ',', '.'), 2))),
    estado = LTRIM(RTRIM(PARSENAME(REPLACE(endereco, ',', '.'), 1)));

-- Exclusão da coluna "endereco" da tabela original
ALTER TABLE viagens_usuarios
DROP COLUMN endereco;
