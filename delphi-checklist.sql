-- phpMyAdmin SQL Dump modificado
-- Proyecto: Checklist Árbol Dinámico - Cine
-- Base de datos: delphi-checklist
-- MariaDB 10.4.32

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";
SET NAMES utf8mb4;

-- ============================================================
-- IMPORTANTE: Orden de creación respeta claves foráneas
-- USUARIOS → PROYECTO → LISTA → ITEM → HISTORIAL
-- ============================================================

-- --------------------------------------------------------
-- 1. USUARIOS
-- --------------------------------------------------------
CREATE TABLE `usuarios` (
  `id`          INT(11)       NOT NULL AUTO_INCREMENT,
  `nombre`      VARCHAR(100)  NOT NULL,
  `email`       VARCHAR(150)  NOT NULL,
  `contraseña`  VARCHAR(255)  NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Usuario de prueba para desarrollo
INSERT INTO `usuarios` (`id`, `nombre`, `email`, `contraseña`) VALUES
(1, 'Admin', 'admin@cine.com', '1234');

-- --------------------------------------------------------
-- 2. PROYECTO
-- --------------------------------------------------------
CREATE TABLE `proyecto` (
  `id`             INT(11)      NOT NULL AUTO_INCREMENT,
  `id_usuario`     INT(11)      NOT NULL,
  `nombre`         VARCHAR(150) NOT NULL,
  `descripcion`    TEXT                  DEFAULT NULL,
  `fecha_creacion` DATETIME     NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `id_usuario` (`id_usuario`),
  CONSTRAINT `proyecto_ibfk_1`
    FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------
-- 3. LISTA  ← modificada respecto a la original
--    Añadido: id_usuario (FK), ES_NOTA
--    fecha_creacion cambiada de VARCHAR a DATETIME
-- --------------------------------------------------------
CREATE TABLE `lista` (
  `id`             INT(11)      NOT NULL AUTO_INCREMENT,
  `id_usuario`     INT(11)      NOT NULL DEFAULT 1,
  `titulo`         VARCHAR(255) NOT NULL,
  `descripcion`    VARCHAR(255)          DEFAULT NULL,
  `fecha_creacion` DATETIME     NOT NULL DEFAULT current_timestamp(),
  `ES_NOTA`        TINYINT(1)   NOT NULL DEFAULT 0,  -- 0=Lista normal, 1=Nota
  PRIMARY KEY (`id`),
  KEY `id_usuario` (`id_usuario`),
  CONSTRAINT `lista_ibfk_1`
    FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Vuestro dato original conservado
INSERT INTO `lista` (`id`, `id_usuario`, `titulo`, `descripcion`, `fecha_creacion`, `ES_NOTA`) VALUES
(1, 1, 'api', 'Estructura de datos de la API', NOW(), 0);

-- --------------------------------------------------------
-- 4. ITEM  ← modificada respecto a la original
--    Renombrado: id_lista_padre → id_item_padre (autorrelación real)
--    Añadido: fecha_creacion, fecha_completado
--    Corregido: raíces con 0 → NULL
-- --------------------------------------------------------
CREATE TABLE `item` (
  `id`               INT(11)      NOT NULL AUTO_INCREMENT,
  `id_lista`         INT(11)               DEFAULT NULL,
  `id_item_padre`    INT(11)               DEFAULT NULL,  -- NULL = nodo raíz
  `texto`            VARCHAR(255)          DEFAULT NULL,
  `completado`       TINYINT(1)   NOT NULL DEFAULT 0,
  `fecha_creacion`   DATETIME     NOT NULL DEFAULT current_timestamp(),
  `fecha_completado` DATETIME              DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_lista`      (`id_lista`),
  KEY `id_item_padre` (`id_item_padre`),
  CONSTRAINT `item_ibfk_1`
    FOREIGN KEY (`id_lista`)      REFERENCES `lista` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `item_ibfk_2`
    FOREIGN KEY (`id_item_padre`) REFERENCES `item` (`id`)  -- autorrelación
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Vuestros datos originales conservados
-- CORRECCIÓN: el 0 de id_item_padre se convierte en NULL (nodo raíz)
INSERT INTO `item` (`id`, `id_lista`, `id_item_padre`, `texto`, `completado`) VALUES
(1,  1, NULL, 'app',                    0),  -- raíz (era 0, ahora NULL)
(2,  1, 1,    'Filters',                0),
(3,  1, 1,    'HTTP',                   0),
(6,  1, 1,    'Models',                 0),
(7,  1, 1,    'config',                 0),
(8,  1, 1,    'database',               0),
(9,  1, 1,    'route',                  0),
(11, 1, 3,    'Controllers',            0),
(12, 1, 11,   'ClienteController.php',  0),
(13, 1, 11,   'EntradaController.php',  0);

-- Resetear AUTO_INCREMENT tras insertar IDs manuales
ALTER TABLE `item` AUTO_INCREMENT = 14;
ALTER TABLE `lista` AUTO_INCREMENT = 2;

-- --------------------------------------------------------
-- 5. HISTORIAL
-- --------------------------------------------------------
CREATE TABLE `historial` (
  `id`            INT(11)     NOT NULL AUTO_INCREMENT,
  `id_item`       INT(11)     NOT NULL,
  `id_usuario`    INT(11)     NOT NULL,
  `tipo_cambio`   VARCHAR(50) NOT NULL,  -- 'COMPLETADO','TEXTO','BORRADO','CREADO'
  `dato_anterior` TEXT                   DEFAULT NULL,
  `fecha_cambio`  DATETIME    NOT NULL   DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `id_item`    (`id_item`),
  KEY `id_usuario` (`id_usuario`),
  CONSTRAINT `historial_ibfk_1`
    FOREIGN KEY (`id_item`)    REFERENCES `item` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `historial_ibfk_2`
    FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

COMMIT;
