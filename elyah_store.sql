-- Elyah Store — estrutura e produtos demonstrativos
-- Importe este arquivo pelo phpMyAdmin. Nenhum administrador/senha é criado aqui.
CREATE DATABASE IF NOT EXISTS elyah_store
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;
USE elyah_store;

SET NAMES utf8mb4;

CREATE TABLE IF NOT EXISTS categorias (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nome VARCHAR(80) NOT NULL,
    slug VARCHAR(100) NOT NULL,
    ativa TINYINT(1) NOT NULL DEFAULT 1,
    PRIMARY KEY (id),
    UNIQUE KEY uq_categorias_nome (nome),
    UNIQUE KEY uq_categorias_slug (slug)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS administradores (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nome VARCHAR(120) NOT NULL,
    email VARCHAR(190) NOT NULL,
    senha_hash VARCHAR(255) NOT NULL,
    criado_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_administradores_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS clientes (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nome VARCHAR(120) NOT NULL,
    email VARCHAR(190) NOT NULL,
    senha_hash VARCHAR(255) NOT NULL,
    criado_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_clientes_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS produtos (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    categoria_id INT UNSIGNED NOT NULL,
    nome VARCHAR(150) NOT NULL,
    preco DECIMAL(10,2) NOT NULL,
    descricao TEXT NOT NULL,
    tamanhos VARCHAR(160) NOT NULL,
    cores VARCHAR(160) NOT NULL,
    imagem VARCHAR(255) NOT NULL,
    disponivel TINYINT(1) NOT NULL DEFAULT 1,
    destaque TINYINT(1) NOT NULL DEFAULT 0,
    novidade TINYINT(1) NOT NULL DEFAULT 0,
    criado_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    atualizado_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_produtos_nome (nome),
    KEY idx_produtos_categoria_disponivel (categoria_id, disponivel),
    CONSTRAINT fk_produtos_categoria FOREIGN KEY (categoria_id)
        REFERENCES categorias (id) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_produtos_preco_nao_negativo CHECK (preco >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO categorias (nome, slug, ativa) VALUES
    ('Vestidos', 'vestidos', 1),
    ('Conjuntos', 'conjuntos', 1),
    ('Bolsas', 'bolsas', 1)
ON DUPLICATE KEY UPDATE nome = VALUES(nome), ativa = VALUES(ativa);

INSERT INTO produtos (categoria_id, nome, preco, descricao, tamanhos, cores, imagem, disponivel, destaque, novidade)
SELECT c.id, 'Vestido Azul Serena', 219.90,
       'Um vestido leve e delicado para acompanhar momentos especiais. Peça fictícia de demonstração do catálogo.',
       'PP, P, M, G', 'Azul-claro', 'imagens/produtos/vestido-azul.jpg', 1, 1, 1
FROM categorias c WHERE c.slug = 'vestidos'
AND NOT EXISTS (SELECT 1 FROM produtos p WHERE p.nome = 'Vestido Azul Serena');

INSERT INTO produtos (categoria_id, nome, preco, descricao, tamanhos, cores, imagem, disponivel, destaque, novidade)
SELECT c.id, 'Conjunto Areia', 289.90,
       'Combinação elegante de blusa e calça de caimento confortável. Produto fictício para apresentação do sistema.',
       'P, M, G', 'Areia, Off-white', 'imagens/produtos/conjunto-areia.jpg', 1, 1, 0
FROM categorias c WHERE c.slug = 'conjuntos'
AND NOT EXISTS (SELECT 1 FROM produtos p WHERE p.nome = 'Conjunto Areia');

INSERT INTO produtos (categoria_id, nome, preco, descricao, tamanhos, cores, imagem, disponivel, destaque, novidade)
SELECT c.id, 'Bolsa Pérola', 179.90,
       'Bolsa clara com proposta clássica para compor diferentes produções. Produto fictício de demonstração.',
       'Único', 'Off-white', 'imagens/produtos/bolsa-perola.jpg', 1, 0, 1
FROM categorias c WHERE c.slug = 'bolsas'
AND NOT EXISTS (SELECT 1 FROM produtos p WHERE p.nome = 'Bolsa Pérola');
