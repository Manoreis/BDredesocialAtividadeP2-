-- Criação do Banco de Dados
CREATE DATABASE IF NOT EXISTS RedeSocia2DB;
USE RedeSocia2DB;

-- Tabela de Usuários
CREATE TABLE Usuarios (
    id_usuario INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    data_nascimento DATE,
    cidade VARCHAR(50),
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabela de Postagens
CREATE TABLE Postagens (
    id_postagem INT PRIMARY KEY AUTO_INCREMENT,
    id_usuario INT,
    texto TEXT,
    data_postagem TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario)
);

-- Tabela de Comentários
CREATE TABLE Comentarios (
    id_comentario INT PRIMARY KEY AUTO_INCREMENT,
    id_postagem INT,
    id_usuario INT,
    texto TEXT,
    data_comentario TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_postagem) REFERENCES Postagens(id_postagem),
    FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario)
);

-- Inserir um novo usuário
INSERT INTO Usuarios (nome, email, data_nascimento, cidade) VALUES 
('João', 'joao@email.com', '1990-01-01', 'Cidade João');

INSERT INTO Usuarios (nome, email, data_nascimento, cidade) VALUES 
('Maria', 'maria@email.com', '1995-12-01', 'Cidade Maria');


-- Inserir uma nova postagem para o usuário 'João'
INSERT INTO Postagens (id_usuario, texto) VALUES (
  (SELECT id_usuario FROM Usuarios WHERE nome = 'João' LIMIT 1),
  'Minha primeira postagem! Olá Mundo!'
);


INSERT INTO Postagens (id_usuario, texto) VALUES (
(SELECT id_usuario FROM Usuarios WHERE nome = 'Maria'), 'Olá a todos! Boa noite!');

-- Inserir comentários na postagem
INSERT INTO Comentarios (id_postagem, id_usuario, texto) 
VALUES 
    ((SELECT id_postagem FROM Postagens WHERE texto = 'Minha primeira postagem!' LIMIT 1), 
    (SELECT id_usuario FROM Usuarios WHERE nome = 'João' LIMIT 1), 'Ótimo post, João!'),
    ((SELECT id_postagem FROM Postagens WHERE texto = 'Minha primeira postagem!' LIMIT 1), 
    (SELECT id_usuario FROM Usuarios WHERE nome = 'Maria' LIMIT 1), 'Parabéns, João!');


-- Inserir outra postagem
INSERT INTO Postagens (id_usuario, texto) VALUES (
(SELECT id_usuario FROM Usuarios WHERE nome = 'Maria'), 'Boa noite, pessoal!');

INSERT INTO Postagens (id_usuario, texto) VALUES (
(SELECT id_usuario FROM Usuarios WHERE nome = 'Maria'), 'Bom dia, mundo!');

-- Inserir comentários na segunda postagem
INSERT INTO Comentarios (id_postagem, id_usuario, texto) 
VALUES 
    ((SELECT id_postagem FROM Postagens WHERE texto = 'Boa noite, pessoal!' LIMIT 1), 
    (SELECT id_usuario FROM Usuarios WHERE nome = 'João' LIMIT 1), 'Tenham todos uma boa noite!'),
    ((SELECT id_postagem FROM Postagens WHERE texto = 'Boa noite, pessoal!' LIMIT 1), 
    (SELECT id_usuario FROM Usuarios WHERE nome = 'Maria' LIMIT 1), 'Obrigada, pessoal!');


INSERT INTO Comentarios (id_postagem, id_usuario, texto) 
VALUES 
    ((SELECT id_postagem FROM Postagens WHERE texto = 'Bom dia, mundo!' LIMIT 1), 
    (SELECT id_usuario FROM Usuarios WHERE nome = 'João' LIMIT 1), 'Tenha um ótimo dia, Maria!'),
    ((SELECT id_postagem FROM Postagens WHERE texto = 'Bom dia, mundo!' LIMIT 1), 
    (SELECT id_usuario FROM Usuarios WHERE nome = 'Maria'), 'Obrigada, João!');


    -- Criar tabela de Amizades
    CREATE TABLE Amizades (
        id_amizade INT PRIMARY KEY AUTO_INCREMENT,
        id_usuario1 INT,
        id_usuario2 INT,
        data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (id_usuario1) REFERENCES Usuarios(id_usuario),
        FOREIGN KEY (id_usuario2) REFERENCES Usuarios(id_usuario)
    );

-- Recuperação de Postagens por Usuário 'João':
SELECT *
FROM Postagens
WHERE id_usuario IN (SELECT id_usuario FROM Usuarios WHERE nome = 'João');


-- Comentários em uma Postagem
SELECT *
FROM Postagens
WHERE id_postagem IN (SELECT id_postagem FROM Postagens);


-- Comentários em uma Postagem com o Texto 'Bom dia, mundo!':
SELECT *
FROM Postagens
WHERE id_postagem IN (
SELECT 
id_postagem FROM Postagens WHERE texto = 'Bom dia, mundo!');


-- Estatísticas de Atividades - Contagem de Postagens e Comentários por Usuário:
SELECT
    U.nome AS Usuario,
    COUNT(DISTINCT P.id_postagem) AS Total_Postagens,
    COUNT(DISTINCT C.id_comentario) AS Total_Comentarios
FROM Usuarios U
    LEFT JOIN Postagens P ON U.id_usuario = P.id_usuario
    LEFT JOIN Comentarios C ON U.id_usuario = C.id_usuario
GROUP BY U.id_usuario;

-- Amizades Recentes Formadas nos Últimos 30 Dias:
SELECT *
FROM Amizades
WHERE data_criacao >= NOW() - INTERVAL 30 DAY;

-- Detalhes de um Usuário Chamado 'Maria', Incluindo Postagens e Amizades:
SELECT
    U.*,
    P.id_postagem,
    P.texto AS postagem_texto,
    A.id_amizade,
    A.id_usuario1 AS amigo_id_1,
    A.id_usuario2 AS amigo_id_2
FROM Usuarios U
    INNER JOIN Postagens P ON U.id_usuario = P.id_usuario
    LEFT JOIN Amizades A ON (U.id_usuario = A.id_usuario1 OR U.id_usuario = A.id_usuario2)
WHERE U.nome = 'Maria';


-- Verifique Postagens de Maria
SELECT *
FROM Postagens
WHERE id_usuario = (SELECT id_usuario FROM Usuarios WHERE nome = 'Maria');

-- Verifique Amizades de Maria
SELECT *
FROM Amizades
WHERE id_usuario1 = (SELECT id_usuario FROM Usuarios WHERE nome = 'Maria')
   OR id_usuario2 = (SELECT id_usuario FROM Usuarios WHERE nome = 'Maria');







