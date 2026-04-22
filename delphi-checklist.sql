Pau Lledó
paulledo_
Compartiendo su pantalla

BBA3RECORDS — 17/04/2026 9:27

Pau Lledó — 17/04/2026 9:39
jdbc:firebirdsql://localhost:3051/C:/Datos/mibasededatos.fdb?createDatabaseIfNotExist
BBA3RECORDS — 17/04/2026 9:39

BBA3RECORDS — 17/04/2026 10:02
Cannot invoke "org.firebirdsql.gds.ng.wire.ProtocolDescriptor.createWireOperations(org.firebirdsql.gds.ng.wire.WireConnection, org.firebirdsql.gds.ng.WarningMessageCallback)" because "protocolDescriptor" is null
Pau Lledó — 17/04/2026 10:09
jdbc:firebirdsql://localhost:3051/C:/Datos/mibasededatos.fdb?createDatabaseIfNotExist
BBA3RECORDS — 17/04/2026 10:10

BBA3RECORDS — 17/04/2026 10:32
https://github.com/FirebirdSQL/firebird/issues
GitHub
Issues · FirebirdSQL/firebird
Firebird server, client and tools. Contribute to FirebirdSQL/firebird development by creating an account on GitHub.

BBA3RECORDS — 17/04/2026 10:53
Unable to complete network request to host "localhost". [SQLState:08006, ISC error code:335544721] [SQL State=08006, DB Errorcode=335544721]
BBA3RECORDS — 17/04/2026 12:12
salvada a milesimas de segundo
Pau Lledó — 17/04/2026 12:36
https://1drv.ms/w/c/9A8714333726D6AD/IQDvr1luq4XoRLi_e1VH40c-AUTK0_t6WxknGyeirKJIka8?e=plYGIV
Pau Lledó — 17/04/2026 14:13
Hemos acabado con la instalación y manual de ambas versiones de FireBird. También hemos continuado con los diagramas correspondientes de la AP
Pau Lledó — 20/04/2026 9:35
https://1drv.ms/w/c/9A8714333726D6AD/IQDvr1luq4XoRLi_e1VH40c-AUTK0_t6WxknGyeirKJIka8?e=pH0ADe
BBA3RECORDS — 20/04/2026 10:32
https://youtu.be/L-J2XcNOC_I
YouTube
pablo gomez
motin la 40

BBA3RECORDS — 20/04/2026 12:00
Tipo de archivo adjunto: acrobat
Manual Instalación FB.pdf
308.28 KB

Pau Lledó — 20/04/2026 12:48
Tipo de archivo adjunto: acrobat
Manual Instalación FB.pdf
329.92 KB
Pau Lledó — 20/04/2026 15:23
Opción 2 — Registrar el servicio manualmente (si no existe)
Si el servicio de Firebird 5.0 directamente no existe, regístralo usando instsvc.exe, que viene incluido con Firebird:
cmdcd "C:\Program Files\Firebird\Firebird_5_0"
instsvc install -auto -name "Firebird50"

⚠️ Ajusta la ruta según donde hayas instalado Firebird 5.0.

Luego inícialo:
cmdnet start Firebird50
Pau Lledó — 20/04/2026 15:36
Tipo de archivo adjunto: acrobat
Manual Instalación FB.pdf
352.06 KB
Pau Lledó — 20/04/2026 15:48
ENUNCIADO CHECKLIST DELPHI
El proyecto consiste en desarrollar una aplicación de escritorio en Delphi que sirva como checklist visual de las carpetas y archivos que componen un proyecto de cine con arquitectura APIREST y Frontend.

La aplicación mostrará la estructura del proyecto en forma de árbol con desplegables, donde cada nodo representará una carpeta o archivo. El usuario podrá marcar o desmarcar cada elemento mediante checkboxes para indicar si está completado o no. El usuario también podrá borrar o crear nodos y checkbox

Además, cada nodo tendrá asociada una nota de texto que el usuario podrá escribir y que se guardará en una base de datos, de forma que al cerrar y abrir la aplicación el estado de los checks y las notas se mantenga. 
BBA3RECORDS — 20/04/2026 17:01
Hoy hemos continuado y terminado el manual de instalación de FireBird, hemos planteado como hacer el organizador de archivos para la api y hemos hecho
Hoy hemos continuado y terminado el manual de instalación de FireBird, hemos planteado como hacer el organizador de archivos para la api y hemos ayudado a compañeros con la instalación de lo correspondiente al manual
Pau Lledó — 20/04/2026 17:03
Hoy hemos acabado de terminar el manual de instalación de FireBird porque nos habian pedido que añadiesemos un par de cosas más, hemos ayudado a dos compañeros a instalarlo y hemos planteado una aplicacion en Delphi para un gestor de tareas
Pau Lledó — ayer a las 9:12
https://drive.google.com/drive/folders/1D56_mY5ogPk1Q5vtjWPvqMVfBMs22d_o?usp=sharing
Google Drive
Pau Lledó — ayer a las 9:32
https://drive.google.com/file/d/1vZZjDD4qsDOpZQedE6iqq-R1U8kac0gc/view?usp=sharing
Google Docs
Diagrama E/R Checklist
BBA3RECORDS — ayer a las 9:37
Aqu铆 tienes la lista completa y estructurada de todas las tablas (entidades) y sus variables (atributos) que han aparecido en esta conversaci贸n, tal como se definieron para el modelo **EER de la aplicaci贸n de notas tipo checklist con 铆tems multinivel**.

Se incluyen las tablas principales, las tablas de relaci贸n y las extensiones opcionales mencionadas.

---

message.txt
5 KB
-- =============================================================================
-- MODELO RELACIONAL: SISTEMA DE 脕RBOL MULTIPROP脫SITO CON PROYECTOS
-- Base de datos: MySQL
-- Incluye: Espacios > Proyectos > Nodos jer谩rquicos (carpetas/notas/tareas/archivos)
-- =============================================================================

message.txt
12 KB
Pau Lledó — ayer a las 9:48
https://drive.google.com/file/d/1u82BCV0QUWxZ2ojF4lkmA8nOGl-wn206/view?usp=sharing
Google Docs
ER_Checklist_Cine.drawio
BBA3RECORDS
 ha fijado un mensaje en este canal. Ver todos los mensajes fijados. — ayer a las 10:34
BBA3RECORDS — ayer a las 12:03
Imagen
Pau Lledó — ayer a las 12:37
Tabla Lista
id_lista: 1
titulo: APIREST

Tabla ITEM
id_item: 1
id_lista: 1
id_item_padre: null
texto: controllers/
completado: false

id_item:2
id_lista:1
id_item_padre: 1
texto: Revisar nombres de rutas
completado: false
BBA3RECORDS — ayer a las 12:53
Imagen
BBA3RECORDS — ayer a las 17:02
Hoy hemos ayudado a un compañero a  instalar firebird, hemos avanzado con el proyecto del gestor, hemos casi terminado de organizarlo y hemos planteado que haremos mañana
BBA3RECORDS — 9:13
Pau Lledó — 9:20
https://github.com/CamaleonCuliao/delphi-checklist
GitHub
GitHub - CamaleonCuliao/delphi-checklist: Proyecto pequeño para or...
Proyecto pequeño para organizar las tareas de un equipo - CamaleonCuliao/delphi-checklist
Proyecto pequeño para organizar las tareas de un equipo - CamaleonCuliao/delphi-checklist
BBA3RECORDS — 9:50
https://search.brave.com/search?q=como+conectar+github+a+delphi&spellcheck=0&summary=1&conversation=08ffde9bf757ddbe07fac69d1c1d07103b89
Brave Search
Como conectar github a delphi
Para conectar GitHub con Delphi, es fundamental entender que no existe una integración nativa directa para crear repositorios o autenticarse dentro del IDE sin configuraciones previas o herramientas externas, ya que Delphi depende de la instalación local de Git y de su gestión de credenciales.

Los pasos esenciales para lograr esta conexión ...
Como conectar github a delphi
BBA3RECORDS — 10:16
Rq6yj6xZul2QFIF
if0_41725052
BBA3RECORDS — 10:52
A}D)a{lYss)J
Imagen
Pau Lledó — 11:40
estas vivo?
BBA3RECORDS — 11:43
Imagen
Imagen
pruebafdsf.whf.bz
BBA3RECORDS — 12:13
Imagen
Imagen
Pau Lledó — 12:20
-- phpMyAdmin SQL Dump modificado
-- Proyecto: Checklist Árbol Dinámico - Cine
-- Base de datos: delphi-checklist
-- MariaDB 10.4.32

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";

message.txt
6 KB
BBA3RECORDS — 12:28
Imagen
﻿
BBA3RECORDS
bba3records
 
 
 
Canal de música:
https://www.youtube.com/@BBA_RECORDS/videos

https://open.spotify.com/artist/0jYoQkuZ1xMtu7hMZD7oD9?si=Nzvq18LuSwyxoJO3pivv-Q
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
message.txt
6 KB
