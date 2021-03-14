DROP DATABASE IF EXISTS `locals`;
CREATE DATABASE `locals`;
USE `locals`;

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

CREATE TABLE `categoriaFoto` (
  `idCategoriaFoto` int(11) NOT NULL AUTO_INCREMENT,
  `nomCategoria` varchar(50) NOT NULL UNIQUE,
  `descripcio` varchar(250) DEFAULT NULL,
  PRIMARY KEY (`idCategoriaFoto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `categoriaPreu` (
  `idCategoriaPreu` int(11) NOT NULL AUTO_INCREMENT,
  `tipusPreu` varchar(100) NOT NULL UNIQUE,
  PRIMARY KEY (`idCategoriaPreu`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `establiment` (
  `idEstabliment` int(11) NOT NULL AUTO_INCREMENT,
  `nom` varchar(55) NOT NULL UNIQUE,
  `web` varchar(100) DEFAULT NULL,
  `descripcio` varchar(250) DEFAULT NULL,
  `telefon` varchar(16) DEFAULT NULL,
  `direccio` varchar(50) DEFAULT NULL,
  `latitud` varchar(50) DEFAULT NULL,
  `longitud` varchar(50) DEFAULT NULL,
  `nota` decimal(2,1) DEFAULT NULL,
  `idCategoriaPreu` int(11) DEFAULT NULL,
  `destacat` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`idEstabliment`),
  CONSTRAINT `establiment__categoriaPreu` FOREIGN KEY (`idCategoriaPreu`) REFERENCES `categoriaPreu` (`idCategoriaPreu`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `foto` (
  `idFoto` int(11) NOT NULL AUTO_INCREMENT,
  `idEstabliment` int(11) NOT NULL,
  `idCategoriaFoto` int(11) NOT NULL DEFAULT 1,
  `nomFoto` varchar(250) NOT NULL,
  PRIMARY KEY (`idFoto`),
  CONSTRAINT `foto__categoriaFoto` FOREIGN KEY (`idCategoriaFoto`) REFERENCES `categoriaFoto` (`idCategoriaFoto`) ON DELETE CASCADE,
  CONSTRAINT `foto__establiment` FOREIGN KEY (`idEstabliment`) REFERENCES `establiment` (`idEstabliment`) ON DELETE CASCADE

) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `horari` (
  `idHorari` int(11) NOT NULL AUTO_INCREMENT,
  `idEstabliment` int(11) NOT NULL,
  `dia` varchar(20) NOT NULL,
  `obren` time DEFAULT NULL,
  `tanquen` time DEFAULT NULL,
  PRIMARY KEY (`idHorari`),
  CONSTRAINT `horari__establiment` FOREIGN KEY (`idEstabliment`) REFERENCES `establiment` (`idEstabliment`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `tipusCuina` (
  `idTipusCuina` int(11) NOT NULL AUTO_INCREMENT,
  `titol` varchar(50) NOT NULL,
  `descripcio` varchar(250) DEFAULT NULL,
  PRIMARY KEY (`idTipusCuina`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `tipusCuina_establiment` (
  `idEstabliment` int(11) NOT NULL,
  `idTipusCuina` int(11) NOT NULL,
  PRIMARY KEY (`idEstabliment`, `idTipusCuina`),
  CONSTRAINT `tipusCuina_establiment__tipusCuina` FOREIGN KEY (`idTipusCuina`) REFERENCES `tipusCuina` (`idTipusCuina`) ON DELETE CASCADE,
  CONSTRAINT `tipusCuina_establiment__establiment` FOREIGN KEY (`idEstabliment`) REFERENCES `establiment` (`idEstabliment`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `usuari` (
  `idUsuari` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(70) NOT NULL UNIQUE,
  `nom` varchar(55) NOT NULL,
  `password` varchar(150) NOT NULL,
  `avatar` varchar(200) NOT NULL DEFAULT 'noAvatar.jpg',
  `createdAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `token` varchar(200) DEFAULT NULL,
  `tokenLimit` datetime DEFAULT NULL,
  `isAdmin` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`idUsuari`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `comentari` (
  `idComentari` int(11) NOT NULL AUTO_INCREMENT,
  `idEstabliment` int(11) NOT NULL,
  `idUsuari` int(11) NOT NULL,
  `comentari` text DEFAULT NULL,
  `isValidat` tinyint(1) NULL DEFAULT 0,
  `data` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `valoracio` decimal(2,1) DEFAULT NULL,
  PRIMARY KEY (`idComentari`),
  CONSTRAINT `comentari__establiment` FOREIGN KEY (`idEstabliment`) REFERENCES `establiment` (`idEstabliment`),
  CONSTRAINT `comentari__usuari` FOREIGN KEY (`idUsuari`) REFERENCES `usuari` (`idUsuari`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


DELIMITER $$
CREATE TRIGGER comentari__isValidat_on_update_before BEFORE UPDATE ON `comentari`
FOR EACH ROW
BEGIN
    SET new.`isValidat` = IFNULL(new.`isValidat`, 0);
END $$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER comentari__isValidat_on_update_after AFTER UPDATE ON `comentari`
FOR EACH ROW
BEGIN
    UPDATE `establiment` SET `establiment`.`nota` = ( SELECT AVG(`comentari`.`valoracio`) FROM `comentari` WHERE `comentari`.`idEstabliment` = new.`idEstabliment` ) WHERE `establiment`.`idEstabliment` = new.`idEstabliment`;
END $$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER comentari__isValidat_on_insert_after AFTER INSERT ON `comentari`
FOR EACH ROW
BEGIN
    UPDATE `establiment` SET `establiment`.`nota` = ( SELECT AVG(`comentari`.`valoracio`) FROM `comentari` WHERE `comentari`.`idEstabliment` = new.`idEstabliment` ) WHERE `establiment`.`idEstabliment` = new.`idEstabliment`;
END $$
DELIMITER ;

INSERT INTO `categoriaFoto` (`nomCategoria`, `descripcio`) VALUES
('Sense Categoria', 'La foto no té categoria.'),
('Foto Destacada', 'Es la foto destacada del establiment.'),
('Prova', 'Prova'),
('Basura', 'Llabreso'),
('Jo que se', 'Cabras obesas');

INSERT INTO `categoriaPreu` (`tipusPreu`) VALUES
('menys de 10 €'),
('entre 10 i 15 €'),
('entre 15 i 20 €'),
('entre 20 i 25 €'),
('entre 25 i 30 €'),
('entre 30 i 40 €'),
('entre 40 i 50 €'),
('més de 50 €');

INSERT INTO `establiment` (`nom`, `destacat`, `latitud`, `longitud`, `web`, `descripcio`, `direccio`, `telefon`, `idCategoriaPreu`) VALUES
('Asa', 0, '26.233529', '-83.775816', 'http://www.bosco.com/', 'Earum suscipit vitae molestias maxime occaecati. Delectus est animi porro occaecati. Quis iure quia officiis nostrum.', 'Suite 569', '(231)718-1813x21', 2),
('Jerry', 0, '47.979036', '123.898378', 'http://wisozk.net/', 'Eveniet laudantium ut magnam a. Omnis ex architecto sint ipsam. Tenetur blanditiis dolorum quisquam exercitationem nesciunt debitis. Velit veniam dolore laudantium.', 'Apt. 435', '489-281-3469x559', 7),
('Julie', 0, '-16.745346', '-31.248857', 'http://lynch.com/', 'Ex quas facere asperiores praesentium qui consequatur. Quae ab ut beatae magnam officiis. Nesciunt eum ut repellat odio. Et dolorem dolorem dicta.', 'Apt. 134', '531-151-9326', 5),
('Adella', 0, '-58.441515', '58.809732', 'http://kshlerinhettinger.info/', 'Quia non iste magnam sit at. Asperiores est dolorum dolore odit. Facere vero sunt impedit culpa et quis.', 'Suite 548', '429.864.5297', 2),
('Mable', 0, '-21.014375', '-20.748211', 'http://mosciski.com/', 'Sequi provident eius maiores repellat. Deleniti nemo sit rem eius. Ea quas eos omnis esse in quos veritatis.', 'Suite 118', '725-259-6353x280', 7),
('Rosalia', 0, '-25.380980', '95.429926', 'http://schmitt.info/', 'Iusto aut assumenda inventore hic molestias. Consequatur officia fugit animi quam libero. Eius odit neque quia et natus modi enim.', 'Suite 927', '497-346-4596x810', 6),
('Meta', 0, '61.490273', '-12.456049', 'http://www.crona.net/', 'Dolorem doloremque deserunt veritatis id. Omnis nemo culpa aliquid minima rerum rerum. Eius esse modi nihil nam reiciendis veritatis et dolorum. Explicabo aut sapiente assumenda sint.', 'Suite 958', '1-048-424-4486x7', 6),
('Rudy', 0, '31.218268', '-102.709861', 'http://tromp.biz/', 'At tenetur ipsum deserunt dicta pariatur ut deleniti doloremque. Natus aut ut est pariatur accusamus nulla fugit facere. Qui velit debitis reprehenderit blanditiis.', 'Apt. 360', '1-880-835-5976x5', 3),
('Bert', 0, '40.206048', '-81.826365', 'http://www.kiehnpfeffer.org/', 'Facilis rerum quisquam modi. Et impedit debitis ut odio omnis rerum. Sequi eos provident quo sed saepe soluta quod.', 'Suite 527', '165-790-9984x780', 4),
('Jaden', 0, '32.127718', '-125.228889', 'http://www.harber.com/', 'Maxime eos ullam et et. Et porro culpa voluptatibus fugit et voluptatem. Dolores nihil placeat illo similique incidunt magni possimus.', 'Apt. 183', '929-869-0773', 8),
('Shaina', 0, '2.118787', '-149.226097', 'http://volkman.com/', 'Eos tenetur totam possimus facilis et eveniet tempora. Similique ut voluptates illum. Id vero accusantium reprehenderit velit doloribus.', 'Suite 295', '+75(4)6112744798', 5),
('Edd', 0, '-5.809991', '29.569735', 'http://www.rueckerluettgen.org/', 'Suscipit ipsam eaque sed sint adipisci eum. Quibusdam aut molestiae consequatur. Voluptas blanditiis et est sint quos enim.', 'Apt. 814', '1-850-112-5360x1', 3),
('Angelo', 0, '-16.737623', '-55.092419', 'http://www.sporer.biz/', 'Quis dignissimos et et libero ipsum. Excepturi at accusantium fugit dolores. Aperiam voluptates ratione quo qui alias mollitia quia. Qui similique expedita quos.', 'Suite 052', '519.234.0414x220', 2),
('Rosamond', 0, '83.099428', '72.880121', 'http://hansenrogahn.net/', 'Minus ea deserunt aut magni. Natus sint est quia vitae. Et est fuga velit molestiae.', 'Apt. 624', '(846)767-9068x97', 6),
('Elton', 0, '4.077869', '-152.667351', 'http://www.kling.net/', 'Ullam doloremque quam sunt voluptas. At voluptates dolor facilis sunt. Ducimus consequatur perspiciatis dolore doloremque sit molestias.', 'Suite 836', '03544505124', 8),
('Marcelina', 0, '-11.807692', '120.672649', 'http://www.stehrmclaughlin.com/', 'Eos amet alias sapiente. Ullam qui quo placeat alias et atque velit veritatis. Dolores placeat sunt ipsam laborum.', 'Apt. 257', '(014)939-7895', 1),
('Justina', 0, '73.980458', '-16.091748', 'http://herman.com/', 'Sit eaque quisquam modi repellendus omnis. Consectetur quasi dolores excepturi error quia ad. Impedit in molestiae soluta et.', 'Apt. 516', '+18(1)9775073531', 4),
('Kelsi', 0, '3.296309', '153.626516', 'http://www.gislason.com/', 'Modi provident voluptate sint aliquid. Quia explicabo iste cumque voluptatem quis ea deleniti et. Iure animi quod consectetur quod fugit enim praesentium vel.', 'Suite 115', '1-409-681-1629x4', 8),
('Stone', 0, '-8.054315', '-161.462189', 'http://www.aufderhar.net/', 'Incidunt non mollitia dolore et. Dolorum placeat quod laudantium placeat rerum quia officiis. Sed illo maxime perferendis laudantium quaerat sequi.', 'Suite 466', '751-222-9435', 8),
('Candelario', 0, '82.242995', '83.835232', 'http://www.kirlin.org/', 'Sit possimus consequatur aut aut delectus laborum et. Doloremque similique dolore aperiam quia laudantium.', 'Suite 039', '369-613-0253x614', 6),
('Lisandro', 0, '89.590474', '72.319711', 'http://www.bahringer.org/', 'Dignissimos minus quibusdam doloremque accusantium molestiae. Corrupti aut corporis est. Aspernatur sit rerum pariatur ratione ipsum.', 'Apt. 029', '(860)925-1396', 8),
('Jamaal', 0, '23.581203', '73.287009', 'http://www.funkhartmann.com/', 'Voluptatem veniam amet quas nihil accusantium. Voluptatem qui fugit quaerat aperiam nemo dignissimos soluta aut. Dolorem minima error illum molestiae.', 'Suite 768', '525-223-3321x115', 2),
('Johnathon', 0, '-44.526786', '-85.128170', 'http://www.harber.org/', 'Repudiandae animi in velit. Omnis autem voluptatem libero iure eum quaerat et.', 'Suite 631', '(337)236-0646', 5),
('Gerardo', 0, '-65.154918', '-29.370466', 'http://www.heidenreich.com/', 'Ut occaecati voluptatum accusantium expedita. Ab reprehenderit qui nihil non. Veritatis perferendis nihil in reiciendis consequuntur similique. Molestias sapiente nisi molestiae modi id incidunt.', 'Apt. 887', '443-485-7785', 4),
('Marielle', 0, '-57.274575', '-49.751901', 'http://www.douglas.com/', 'Possimus facere voluptates ea sit. Mollitia vitae aut doloremque nemo eaque. Repudiandae mollitia nam repudiandae nisi. Laudantium quia dolorem voluptatum dolorum sed quasi eos.', 'Apt. 479', '1-015-598-0978', 3),
('Meagan', 0, '-32.236123', '97.385181', 'http://www.smithwest.com/', 'Pariatur soluta earum maxime ipsa veniam rerum omnis autem. Deleniti est vero amet aperiam inventore. In explicabo quas quia voluptates nihil.', 'Suite 179', '1-408-242-7421x0', 7),
('Arvid', 0, '41.647036', '112.335281', 'http://www.kris.com/', 'Temporibus vero quae molestiae eveniet reprehenderit culpa. Qui doloribus tempore quibusdam et omnis.', 'Apt. 927', '1-056-509-2923x3', 8),
('Sierra', 0, '27.846565', '-125.253325', 'http://oconner.com/', 'Illo asperiores minima omnis aut sit facilis. Adipisci blanditiis deserunt quis et. Sit expedita ut provident sapiente sint quia. Et maiores iure ea alias quod sed.', 'Suite 061', '754.225.1548x588', 3),
('Angel', 0, '60.709057', '-59.736935', 'http://braunwalsh.com/', 'Porro neque magnam alias molestiae quas. Praesentium aut in excepturi architecto laborum. Earum omnis ex sit dicta qui eaque. Atque repellat ducimus aut.', 'Suite 261', '1-917-303-9146x3', 5),
('Dallin', 0, '-49.912837', '-173.644533', 'http://www.murray.net/', 'Voluptas delectus non ut quis. Quia ipsa mollitia aut et laboriosam. Sit vitae et minima aliquam est rerum. At eos temporibus quisquam corrupti tempora.', 'Suite 469', '395-700-7526', 5),
('Sandra', 0, '42.135338', '101.027721', 'http://marvinbode.net/', 'Id in qui eveniet aperiam. Iusto architecto hic harum aut cupiditate laboriosam. Vel adipisci sunt tenetur at deserunt consequatur beatae labore.', 'Apt. 691', '561-783-6946x108', 4),
('Katarina', 0, '31.856171', '-130.118384', 'http://www.romagueraconroy.org/', 'Labore unde voluptas eveniet officiis ut provident cum. Vel qui fugiat eos totam accusamus voluptatum ab.\nOmnis vitae eum ut quia eos rerum. Est illum possimus optio repellat esse possimus omnis.', 'Apt. 183', '564.276.2917', 6),
('Mellie', 0, '48.014529', '-96.644591', 'http://mrazdibbert.com/', 'Non tempore commodi a enim. Ex voluptatem ducimus dolores ullam temporibus consequatur.', 'Suite 322', '+51(1)5707352209', 4),
('Johnathan', 0, '-49.635780', '-97.284419', 'http://www.pagacrice.com/', 'Laudantium ipsum sit commodi quis. Facilis numquam quasi iste. Est adipisci et voluptatem et consequuntur. Illo voluptatem alias hic eos sunt.', 'Suite 987', '987-284-4537', 7),
('Gladys', 0, '19.988770', '100.471299', 'http://www.connellyfeest.com/', 'Nisi quis incidunt autem aliquam quae voluptatem. Laborum placeat rem ipsum enim quia fugit. Nihil recusandae voluptate eveniet similique optio corrupti sed iure. Quos eum ut corrupti.', 'Apt. 587', '1-591-626-4677x6', 4),
('Jacynthe', 0, '58.967273', '125.272298', 'http://www.braungibson.org/', 'Amet qui eos explicabo voluptates. Minima eius nobis alias error natus. Nobis et et impedit consequuntur. Rem dolore cumque repellat quasi molestias. Culpa voluptas perferendis sit.', 'Apt. 548', '944-300-1555x964', 2),
('Westley', 0, '-57.941775', '1.340701', 'http://www.bailey.com/', 'Aliquid quaerat sint blanditiis sed. Voluptatem dolor eos accusamus aut optio ipsam. Quidem illum quibusdam accusamus.', 'Suite 443', '(216)958-7315', 8),
('Estelle', 0, '68.599036', '5.404587', 'http://www.paucek.biz/', 'Numquam voluptatem provident unde odio maxime. Eligendi expedita quia quidem consequatur non et. Modi delectus ut qui aut.', 'Suite 603', '+67(3)8396459636', 5),
('Bernie', 0, '32.119112', '113.256900', 'http://buckridge.com/', 'Maiores doloremque tenetur voluptas praesentium magni est perspiciatis. Reprehenderit impedit ipsum vel dolorum repudiandae labore hic. Ullam cumque est atque facilis ut consequatur.', 'Apt. 126', '(327)666-4142', 8),
('Desmond', 0, '-60.014458', '-156.216240', 'http://www.wilkinson.com/', 'Nihil et ad qui distinctio magni omnis. Non ducimus ea perferendis quisquam omnis. Sed aut delectus nam beatae.', 'Apt. 252', '703-842-0618x878', 5),
('Jaime', 0, '14.239518', '-164.981037', 'http://bayerwaters.com/', 'Consequatur neque et dolor molestiae exercitationem cupiditate. Dolorem quidem sit dicta pariatur. Dolorem architecto officia eum tempora.', 'Suite 383', '1-421-448-5786x0', 3),
('Jan', 0, '37.948813', '-37.115560', 'http://cronin.info/', 'Delectus nihil sapiente aliquam aliquam explicabo molestiae aut. Perspiciatis atque maiores architecto molestiae molestiae voluptatem.', 'Apt. 908', '06249555371', 8),
('Anais', 0, '31.485569', '-103.815670', 'http://gorczany.com/', 'Maxime non commodi cumque qui explicabo sit. Voluptas repellendus a quos laboriosam deserunt accusamus aut. Sapiente tempora consequatur est voluptas ex praesentium. Numquam nobis quasi officiis.', 'Suite 298', '(972)710-9297x34', 5),
('Precious', 1, '-33.380954', '-165.017833', 'http://www.goodwin.com/', 'Numquam repellendus exercitationem qui non illo magni. Consequatur eum accusamus odit iure eos et. Nobis esse suscipit libero numquam nulla a doloribus. Possimus quia voluptatem qui nihil.', 'Suite 445', '(682)253-7389', 8),
('Marley', 0, '71.318671', '57.948063', 'http://rowe.com/', 'Dicta animi ullam accusamus vel et laudantium. Est distinctio ducimus ipsam doloribus quia est odio. Ea quibusdam quas quaerat iure ut optio. Sapiente dolore magni nam ut quas.', 'Suite 931', '(579)364-5689', 5),
('Jesse', 0, '-42.345923', '-83.145733', 'http://grant.com/', 'Quasi explicabo dignissimos accusantium. Iste maiores at nulla dolorem provident neque. Consequatur odio ab magnam eum veniam sapiente ratione. Atque quo suscipit eaque qui nihil et temporibus nihil.', 'Apt. 865', '1-856-492-6509', 1),
('Jason', 0, '72.205675', '75.854290', 'http://www.bechtelar.org/', 'Sequi nesciunt a exercitationem et nam quasi debitis aliquid. Eveniet excepturi ea eum voluptatem quia et odio. Soluta quis voluptas maiores eaque.', 'Apt. 962', '1-103-625-4741x9', 8),
('Yessenia', 0, '-14.421634', '-44.856325', 'http://beckerauer.org/', 'Debitis error quidem deleniti eaque deleniti. Nesciunt earum mollitia velit. Et dignissimos accusamus ut porro et quos rerum assumenda.', 'Suite 534', '1-064-588-8215x4', 7),
('Kianna', 0, '3.601093', '-114.123674', 'http://oberbrunner.biz/', 'Aut vel sunt illum ea commodi. Quis natus quidem enim quia. Veniam quos quaerat magnam odit. Tempore nobis cupiditate vel iusto.', 'Suite 570', '+80(3)8901136916', 1),
('Vada', 0, '47.849971', '3.675344', 'http://effertz.com/', 'Cumque voluptatibus neque quod fugit voluptatibus enim. Nulla aut quibusdam est fuga sunt ad. Sunt aut quisquam repellat pariatur mollitia ea.', 'Apt. 580', '1-743-302-5838', 4),
('Annabelle', 0, '-73.915202', '-151.882778', 'http://kleinzulauf.org/', 'Delectus rerum temporibus suscipit voluptatem minus. Voluptas repellat amet voluptatem fugit in veritatis labore. Veniam velit neque optio.', 'Suite 213', '1-138-651-7490', 5),
('Stacy', 0, '-6.501580', '-146.696870', 'http://www.breitenberg.com/', 'Facere ipsa ipsam praesentium nemo omnis. Dolorum accusamus dolore soluta nemo harum cumque possimus.', 'Suite 727', '015.476.5758x987', 5),
('Enoch', 0, '-82.316898', '-14.447830', 'http://pacocha.com/', 'Omnis ut sequi provident aut libero accusamus ex sint. Eius ducimus a suscipit. Illo laboriosam placeat magni repudiandae id id voluptatibus.', 'Apt. 801', '016.641.0225', 6),
('Albertha', 0, '-21.386167', '-89.097607', 'http://torphykling.info/', 'Est ea neque doloremque minus vero perspiciatis neque voluptates. Iste aut ipsa nostrum ad. Nisi iure dignissimos quia ea est qui aut. Autem aut qui possimus molestias vitae alias quam nesciunt.', 'Apt. 965', '(253)482-8965x22', 7),
('Will', 0, '-16.795038', '-130.595701', 'http://hamillmarks.net/', 'Qui eum voluptates itaque repellendus quisquam labore. Incidunt quasi qui qui voluptatem omnis libero nobis.', 'Suite 056', '553-271-9659', 1),
('Gardner', 0, '-13.932520', '14.223425', 'http://www.hermistonshanahan.com/', 'Veritatis mollitia recusandae ea nihil et delectus vel provident. Ex sit quae consequuntur repellendus corporis reprehenderit eum. Occaecati voluptatum et rem velit incidunt vero et.', 'Suite 140', '1-435-745-7266x1', 3),
('Hardy', 0, '-22.097698', '-97.279448', 'http://www.heaney.com/', 'Sit perferendis aut et non. Modi similique qui ut eum in dignissimos nemo. Velit repellendus iusto doloremque nemo facilis ratione. Pariatur voluptas id officiis qui nulla.', 'Apt. 281', '1-855-074-7024x1', 7),
('Annalise', 0, '42.911922', '-31.341784', 'http://www.dickens.net/', 'Enim error ea dignissimos nobis quibusdam. Facere voluptatibus sed iste ratione. Eveniet ipsam nemo et a sed.', 'Apt. 984', '1-980-808-7695', 7),
('Nakia', 0, '-22.257895', '23.301052', 'http://west.com/', 'Nam qui voluptas tenetur quos et. Similique laborum est ipsa ullam iusto ut voluptatum. Sapiente rerum quia sunt sunt doloribus. Quos ut dolorem eos necessitatibus.', 'Apt. 040', '(262)213-5084', 5),
('Julien', 0, '-55.558511', '-111.368225', 'http://www.conn.com/', 'Nostrum cupiditate rerum fugiat odit. Consequatur autem maiores cupiditate alias. Ut dignissimos qui dolores dolor nam voluptate non.', 'Suite 810', '486-584-6902x769', 5),
('Andreane', 0, '-85.757176', '23.998642', 'http://cormierkerluke.com/', 'Est tempora soluta ut deleniti quos corporis suscipit. Est cum a ducimus. Velit rerum non nihil. Natus voluptatem sapiente dolor explicabo blanditiis.', 'Suite 464', '1-061-963-6157x3', 1),
('Pat', 0, '89.322050', '139.890297', 'http://www.lind.com/', 'Voluptate ut repudiandae ut qui. Quod error ut ab labore autem. Voluptatibus rem iste ut suscipit.', 'Suite 117', '(467)152-1845x54', 7),
('Joannie', 0, '-61.971555', '-55.463194', 'http://prosacco.biz/', 'Tempora dolorem quo natus error itaque qui. Rerum facilis iusto ratione deleniti et. Dolorem quam error aut rem autem reiciendis accusamus minima.', 'Suite 142', '(262)550-6318x52', 7),
('Jaylin', 0, '-81.039648', '131.256840', 'http://champlin.org/', 'Beatae repellat ratione commodi qui aliquam aut est. Occaecati quis ex qui omnis eius et qui veniam. Quia aut vel veritatis sunt quibusdam ut at. Ipsa minus qui numquam sit tempora rerum quidem.', 'Apt. 210', '360-637-3666x673', 3),
('Neil', 1, '63.703877', '-34.470513', 'http://www.tromp.org/', 'Minima occaecati et quia sit dolor dicta. Est ipsam nam error quaerat exercitationem itaque in. Sunt totam ipsum iusto et accusantium tempore.', 'Apt. 433', '478.374.8284', 8),
('Floy', 0, '39.734257', '158.313853', 'http://lind.org/', 'Quae quas aut quisquam eos quis corporis. Sequi repudiandae voluptas laborum non. Animi aspernatur mollitia quia doloremque est quis. Assumenda aliquid ratione rerum vel quo qui sunt facilis.', 'Suite 521', '459-043-7699x150', 5),
('Herman', 0, '32.739357', '12.743371', 'http://www.little.com/', 'Est ipsa aut deleniti ullam ullam. Quis consequuntur cum vel. Sunt et dolorum maxime voluptatem placeat et ut consectetur.', 'Apt. 010', '(363)587-0962', 3),
('Marielles', 0, '4.699749', '-161.318300', 'http://schamberger.com/', 'Aperiam cumque et dolores ipsa in aliquam hic. Est explicabo dolorum impedit. Voluptatem a vero voluptas quaerat magni. Quisquam ad nam cupiditate similique.', 'Suite 734', '1-387-709-1615', 2),
('Joesph', 0, '89.327493', '-81.598967', 'http://www.nicolas.info/', 'Vel quibusdam explicabo impedit. Reiciendis molestias provident voluptatem minima libero debitis distinctio. Vel neque dolor consequatur enim est commodi a.', 'Suite 858', '004-343-7922', 1),
('Darrell', 0, '59.139328', '157.745544', 'http://www.klein.com/', 'Atque iste deleniti tempore est provident. Fugit quo eum iure qui. Fugiat harum dolorem occaecati voluptatem quis asperiores aut.', 'Apt. 635', '593.134.2843x750', 8),
('Ona', 0, '-0.174086', '-69.324691', 'http://www.wilkinson.biz/', 'Iure atque harum doloremque occaecati voluptatem. Culpa sit placeat omnis eos voluptatem commodi maxime. Nemo autem dolores sit tenetur id hic nulla. Temporibus sint quod labore aut rerum.', 'Suite 265', '571-434-1716', 3),
('Dorthy', 0, '-34.413185', '-3.076016', 'http://mclaughlin.com/', 'Est ut et ab dignissimos. Et molestiae pariatur tenetur maiores facilis pariatur omnis cumque.', 'Apt. 794', '(851)342-7825', 4),
('Makayla', 0, '73.122517', '166.974062', 'http://www.lynchmarks.biz/', 'Omnis deserunt molestias nisi omnis et. Omnis ducimus vero dolor aut. Eius beatae explicabo et omnis delectus aperiam odio quas.', 'Apt. 931', '1-310-991-1907', 6),
('Thomas', 0, '65.400095', '81.659250', 'http://powlowskicummings.info/', 'Aut quam non et dolore est voluptate in. Maxime laudantium deleniti et sed.\nRerum repellat tempore eum deserunt beatae. Doloribus recusandae quo maiores in. Perferendis dolor inventore quia.', 'Apt. 249', '857.925.9501x316', 5),
('Orlando', 0, '-43.530572', '-8.147150', 'http://heidenreich.com/', 'Cupiditate amet enim ullam voluptas in ipsa. Sed voluptates est non delectus sit. Dolor eos voluptatem non fugit ducimus impedit inventore. Vel labore numquam ea est sit.', 'Suite 684', '(160)334-5723x13', 8),
('Keara', 1, '-31.622364', '-114.669026', 'http://www.oharahegmann.com/', 'Vel animi eaque cumque eaque. Sed sed qui et necessitatibus. Harum quo animi dicta enim. Officia libero illo dolorum pariatur ut autem sed. Magnam dolores natus repellat dolores nobis aut est.', 'Suite 915', '00049133406', 2),
('Wava', 0, '46.786818', '-151.067744', 'http://mclaughlinbeatty.com/', 'Dicta non nemo accusamus consequuntur. At provident laboriosam sit voluptas aut labore eaque. Incidunt dolor voluptatem doloremque quas ab.', 'Suite 464', '1-717-486-1578', 3),
('Zackery', 0, '51.943377', '147.584503', 'http://www.schaefer.com/', 'Quisquam eos enim qui aspernatur sunt sit. Reprehenderit unde ut omnis harum autem sapiente. Rerum tempore tenetur repellat repellat quae aliquam eum. Molestiae repudiandae repudiandae et.', 'Apt. 791', '048-666-2787x468', 2),
('Emilio', 0, '72.894914', '121.592276', 'http://www.mertz.com/', 'Est sit error fuga consequatur. Similique eligendi facilis et quae quasi error inventore. Illo impedit dolorum voluptate dignissimos eos voluptas.', 'Apt. 350', '172.325.8186', 5),
('Elaina', 0, '-83.824550', '130.469545', 'http://brekke.org/', 'Veritatis id dignissimos molestias eos quos in. Atque sequi ratione aspernatur fugit quasi esse repellat. Dolor enim dolorem cupiditate et ipsa esse ad. Omnis error sapiente non.', 'Suite 514', '(568)730-5320', 1),
('Halie', 0, '-25.655819', '28.043556', 'http://www.dubuqueernser.com/', 'Repellat atque et dolor voluptatum sed est est ut. Quia laborum sapiente rerum eligendi minus non. Ipsam ut maxime vitae est accusantium sit. Eum neque eum atque placeat aperiam vitae.', 'Suite 090', '01116057125', 6),
('Woodrow', 0, '-13.371316', '-105.945900', 'http://www.gutkowski.net/', 'Ex dolor nostrum est perferendis placeat. Dicta enim est ut nobis.\nNobis magni sequi ut eaque impedit inventore. Aspernatur voluptate ut ratione reiciendis et. Aut quia nulla autem.', 'Suite 450', '1-820-311-5242x0', 6),
('Cassandra', 0, '26.019348', '-27.354407', 'http://www.bins.com/', 'Repudiandae earum explicabo incidunt aperiam similique placeat. Molestiae quibusdam vel at. Amet nihil veritatis quis autem exercitationem suscipit odit. Omnis ex quia ex nobis.', 'Apt. 622', '1-882-393-7361x4', 7),
('Louvenia', 0, '59.940123', '46.939541', 'http://www.sawaynwaelchi.com/', 'Nulla itaque sit aut distinctio voluptas neque. Voluptatem nihil voluptate amet ut vel. Deserunt consequatur dolor excepturi deleniti incidunt. Molestias quis sunt ut voluptatem earum quia voluptate.', 'Apt. 300', '1-449-780-5800x7', 2),
('Ressie', 0, '-54.450946', '-58.524226', 'http://heller.com/', 'Sed consequuntur quia id voluptatibus. Fugit voluptatem beatae qui impedit doloremque veniam et. Et voluptatum dolore ullam nostrum animi doloremque.', 'Apt. 141', '658-372-7407x576', 8),
('Schuyler', 0, '-29.069250', '69.765005', 'http://www.kihngutmann.com/', 'Explicabo tempore explicabo est velit. Dolor cupiditate a voluptatem rerum minima dolores et. Harum architecto est quod laborum et. Aut earum cumque quidem sed dolores quia.', 'Apt. 920', '(866)960-4786x56', 1),
('Enola', 0, '30.337762', '119.820678', 'http://quigley.com/', 'Eum est tempore qui. Quod enim amet vero dolor soluta ipsam optio quia. Voluptatem voluptatem nulla molestiae quia. Velit sunt quis et odit corporis.', 'Suite 450', '(211)238-7846x37', 4),
('Larry', 0, '66.584993', '-150.707385', 'http://www.rosenbaum.biz/', 'Voluptas qui voluptatem quae alias illum. Nihil porro rerum illum aliquam qui. Deserunt adipisci corporis sint dolore incidunt voluptates.', 'Apt. 185', '998.045.8686', 3),
('Roderick', 1, '-60.493269', '-99.466760', 'http://torphy.biz/', 'Nam inventore quis sit. Et tempore pariatur qui officiis. Eveniet et corrupti eum autem incidunt. Sint velit et quod.', 'Apt. 209', '951-512-1751', 4),
('Edwin', 0, '87.542187', '88.367207', 'http://www.buckridge.com/', 'Dolorum minus deserunt autem consequuntur numquam et quibusdam quod. Ea voluptatem in eius deleniti quasi eius. Veritatis fuga non est sequi.', 'Apt. 222', '339-359-4422', 6),
('Maggie', 0, '-79.943271', '-63.798577', 'http://www.schumm.com/', 'Molestias ea quia voluptatum eaque maxime veniam ipsam sunt. Quasi id unde sed. Neque sapiente inventore sint. Exercitationem autem nihil animi consequatur nesciunt corrupti.', 'Apt. 750', '1-862-776-2799', 6),
('Retta', 0, '19.639712', '9.664978', 'http://reynolds.biz/', 'Occaecati quod sit velit quidem ut. Autem officiis sit qui incidunt consequatur. Et in eveniet soluta velit.', 'Suite 680', '(960)604-9646x17', 6),
('Deanna', 0, '16.668353', '42.037038', 'http://www.medhurst.info/', 'Necessitatibus enim eos sit harum id. In voluptas animi aliquam quis totam. Beatae delectus odio deserunt magni laborum itaque quo.', 'Suite 411', '170.251.7430x440', 1),
('Harold', 1, '-35.060859', '-33.143017', 'http://hammes.info/', 'Nostrum ex tempora sit dolore sint nihil consectetur. Dolorem hic non esse et maxime. Saepe laborum officiis quae dignissimos. Rem quas iste voluptatem cupiditate enim.', 'Apt. 410', '769-215-0901x026', 3),
('Mohammad', 0, '-69.946359', '-104.147092', 'http://braunkemmer.info/', 'Alias sit rerum magnam. In est reiciendis in perspiciatis. Provident tenetur error molestias nisi neque aspernatur.', 'Apt. 563', '048-756-2434x573', 7),
('Danyka', 0, '18.198874', '73.651714', 'http://www.bednarwolff.net/', 'Iste sequi aut omnis fuga. Natus sint officiis iste omnis voluptates quos dolorem. Incidunt quas delectus laudantium rerum quibusdam tenetur enim. Est totam aut ut quos voluptas ipsam.', 'Suite 199', '1-919-776-0078', 5),
('Oceane', 1, '89.649222', '-63.903854', 'http://kuvalisfeil.com/', 'Ut nihil voluptatum et tenetur vel autem eius. Labore aut voluptas voluptate provident. Ex architecto dicta et dolores beatae veniam est.', 'Suite 451', '387-774-5480', 1),
('Bessie', 0, '76.560256', '47.849767', 'http://www.murray.org/', 'Et qui eligendi maxime aut. Sint explicabo exercitationem aut earum soluta aut velit.\nEveniet explicabo voluptas ea delectus quaerat a commodi. Aut debitis ut fuga.', 'Apt. 051', '851.239.4618', 1),
('Nedra', 0, '79.926604', '-79.947212', 'http://www.lubowitz.info/', 'Voluptatem iusto explicabo in consequatur asperiores beatae et. Et est consequatur dolorem aut soluta repellendus deserunt.', 'Suite 654', '+42(8)9559528369', 5),
('Isobel', 1, '-86.397903', '124.104910', 'http://www.casperkoss.info/', 'Qui minus corrupti sed quas non omnis distinctio. Culpa nihil praesentium tempora quidem. Consequatur in sit cumque sed.', 'Suite 495', '(218)039-1827', 8);

INSERT INTO `tipusCuina` (`titol`, `descripcio`) VALUES
('a domicili', NULL),
('alta cuina', NULL),
('arrosseria', NULL),
('asiàtic', NULL),
('cafeteria', NULL),
('carns', NULL),
('casolà', NULL),
('sopas d\'empresa', NULL),
('chillout', NULL),
('amb nins', ''),
('amb terrassa', NULL),
('copes', NULL),
('costa', NULL),
('creperia', NULL),
('d\'autor', NULL),
('econòmic', NULL),
('espectacle', NULL),
('exòtic', NULL),
('fusió', NULL),
('gallec', NULL),
('grups', NULL),
('hamburgueseria', NULL),
('indú', NULL),
('internacional', NULL),
('italià', NULL),
('japonès', NULL),
('mallorquí', NULL),
('mariscs', NULL),
('mediterrani', NULL),
('mercat', NULL),
('mexicà', NULL),
('pa amb oli', NULL),
('pasta', NULL),
('pizza', NULL),
('romàntic', NULL),
('tailandès', NULL),
('tapes', NULL),
('tenda gourmet', NULL),
('tradicional', NULL),
('vasc', NULL),
('vegeterià', NULL),
('vietnamita', NULL),
('vins', NULL),
('arebe', 'si');

INSERT INTO `usuari` (`nom`, `email`, `password`, `isAdmin`) VALUES
('Maria Arbona', 'mariaarbona45@gmail.com', 'uyjC38', 0),
('Biel Mesquida', '3pn4pG', '', 0),
('Miguel Gomez', 'mgomez97@gmail.com', '2c6qXA', 0),
('Toni Llull', 'tllull52@gmail.com', 'CTAVHB', 0),
('Joana Salou', 'jsalou34@gmail.com', 'BSWRvK', 0),
('Cristina Perez', 'crisperez77@gmail.com', 'P5ucpx', 0),
('Jaume Vidal', 'jaumevidalplanes45@gmail.com', '5jfZHK', 0),
('Bel Soler', 'bsoler90@gmail.com', 'TxfC4f', 0),
('Victoria Martinez', 'martinezv35@gmail.com', 'SJhS5C', 0),
('Jordi Soler', 'jordisolermayol22@gmail.com', 'p9ewRz', 0),
('Carme Riera', 'criera44@gmail.com', 'dDYTKR', 0),
('Joan Estelrich', 'jestelrich31@gmail.com', 'fx8cre', 1);

INSERT INTO `comentari` (`idEstabliment`, `idUsuari`, `comentari`, `isValidat`, `data`, `valoracio`) VALUES
(74, 8, 'These were the two creatures got so much into the darkness as hard as she listened, or seemed to be no sort of circle, (\'the exact shape doesn\'t matter,\' it said,) and then quietly marched off after.', 1, '2020-10-02', 4.5),
(31, 3, 'I suppose.\' So she stood still where she was, and waited. When the sands are all dry, he is gay as a lark, And will talk in contemptuous tones of the Rabbit\'s little white kid gloves and a great.', 0, '2019-06-01', 4.5),
(63, 12, 'Let me see how IS it to be an old Crab took the least notice of her head on her lap as if nothing had happened. \'How am I to do?\' said Alice. \'Come on, then,\' said Alice, \'we learned French and.', 0, '2012-09-08', 2.1),
(39, 7, 'Dormouse crossed the court, \'Bring me the list of singers. \'You may not have lived much under the window, and some were birds,) \'I suppose so,\' said Alice. \'Off with his head!\' or \'Off with her.', 1, '2012-02-04', 3.4),
(1, 8, 'Mock Turtle yawned and shut his eyes. \'Tell her about the same year for such dainties would not stoop? Soup of the door began sneezing all at once. The Dormouse shook its head impatiently, and.', 0, '2010-12-18', 3.7),
(83, 4, 'As there seemed to Alice a little three-legged table, all made of solid glass, there was not a moment to think this a good deal until she made out that it ought to be a very deep well. Either the.', 1, '2016-04-22', 2.6),
(66, 6, 'I can say.\' This was not even get her head on her hand, watching the setting sun, and thinking of little Alice and all would change (she knew) to the Caterpillar, just as she spoke, \'either you or.', 1, '2019-12-24', 3.8),
(35, 10, 'Ann, and be turned out of their hearing her, and when she was small enough to look through into the court, arm-in-arm with the end of the tail, and ending with the other side of the officers of the.', 0, '2020-02-24', 3.0),
(91, 10, 'Just then she had never left off writing on his spectacles. \'Where shall I begin, please your Majesty,\' he began. \'You\'re a very difficult question. However, at last it sat down and saying to.', 0, '2011-06-19', 3.9),
(4, 3, 'Duchess. \'Everything\'s got a moral, if only you can find it.\' And she went back for a baby: altogether Alice did not like to try the effect: the next thing is, to get in?\' \'There might be hungry, in.', 1, '2020-10-03', 2.3),
(56, 9, 'Alice, \'I might as well as the March Hare said in a tone of great curiosity. \'Soles and eels, of course,\' he said to herself, \'I should have liked teaching it tricks very much, if--if I\'d only been.', 0, '2015-11-29', 4.0),
(25, 4, 'Alice. \'I\'m a--I\'m a \' \'Well! WHAT are you?\' And then a voice outside, and stopped to listen. The Fish-Footman began by producing from under his arm a great crash, as if nothing had happened. \'How.', 0, '2017-10-05', 1.0),
(9, 5, 'Mock Turtle would be very likely true.) Down, down, down. Would the fall was over. However, when they passed too close, and waving their forepaws to mark the time, while the Dodo could not taste.', 1, '2014-11-03', 1.8),
(24, 9, 'Mock Turtle went on. Her listeners were perfectly quiet till she was considering in her lessons in the middle, nursing a baby, the cook tulip-roots instead of onions.\' Seven flung down his cheeks,.', 1, '2011-09-12', 4.8),
(38, 7, 'However, on the floor: in another moment, splash! she was looking up into the open air. \'IF I don\'t want YOU with us!\"\' \'They were learning to draw,\' the Dormouse crossed the court, without even.', 0, '2019-06-21', 3.5),
(60, 9, 'Mouse to tell me your history, you know,\' said the Mock Turtle. So she was to get to,\' said the Caterpillar. Alice said to herself in a coaxing tone, and everybody else. \'Leave off that!\' screamed.', 0, '2018-06-21', 1.3),
(44, 1, 'Mouse. \'Of course,\' the Mock Turtle yet?\' \'No,\' said the King: \'however, it may kiss my hand if it makes rather a hard word, I will just explain to you to death.\"\' \'You are not attending!\' said the.', 1, '2013-01-11', 3.3),
(73, 6, 'King, \'that only makes the world go round!\"\' \'Somebody said,\' Alice whispered, \'that it\'s done by everybody minding their own business,\' the Duchess sneezed occasionally, and as the hall was very.', 0, '2010-12-02', 4.3),
(1, 12, 'Why, I wouldn\'t be in before the trial\'s over!\' thought Alice. \'I wonder how many hours a day did you call him Tortoise, if he thought it would,\' said the Queen, in a hurry that she had peeped into.', 0, '2012-06-03', 2.3),
(41, 7, 'Why, it fills the whole pack of cards!\' At this moment the door opened inwards, and Alice\'s elbow was pressed so closely against her foot, that there was no more to come, so she waited. The Gryphon.', 1, '2014-12-30', 4.2),
(41, 7, 'And oh, I wish you wouldn\'t squeeze so.\' said the Mock Turtle. \'No, no! The adventures first,\' said the Pigeon in a tone of the cakes, and was suppressed. \'Come, that finished the first day,\' said.', 1, '2013-10-29', 2.0),
(65, 4, 'KNOW IT TO BE TRUE--\" that\'s the queerest thing about it.\' \'She\'s in prison,\' the Queen never left off quarrelling with the next witness.\' And he added in an agony of terror. \'Oh, there goes his.', 0, '2019-12-07', 3.8),
(44, 1, 'I\'ve got to go on. \'And so these three weeks!\' \'I\'m very sorry you\'ve been annoyed,\' said Alice, (she had grown up,\' she said to the baby, the shriek of the busy farm-yard--while the lowing of the.', 0, '2017-07-29', 1.1),
(69, 3, 'You\'re mad.\' \'How do you mean by that?\' said the Mock Turtle: \'nine the next, and so on, then, when you\'ve cleared all the time he was going to say,\' said the Caterpillar. Alice said nothing: she.', 0, '2013-08-21', 2.1),
(2, 10, 'Mock Turtle recovered his voice, and, with tears running down his brush, and had no pictures or conversations?\' So she tucked her arm affectionately into Alice\'s, and they repeated their arguments.', 1, '2019-12-10', 4.0),
(59, 7, 'English coast you find a thing,\' said the Caterpillar. \'Well, perhaps you were never even introduced to a mouse, That he met in the same year for such a very difficult game indeed. The players all.', 1, '2015-03-14', 4.0),
(21, 9, 'March Hare said in a piteous tone. And the executioner ran wildly up and repeat \"\'TIS THE VOICE OF THE SLUGGARD,\"\' said the Duchess, it had been, it suddenly appeared again. \'By-the-bye, what became.', 0, '2016-06-24', 2.0),
(21, 1, 'Hatter. \'You might just as I\'d taken the highest tree in the distance would take the hint, but the tops of the Rabbit\'s voice along--\'Catch him, you by the time he had never before seen a rabbit.', 1, '2019-07-25', 3.0),
(93, 6, 'Then it got down off the cake. \'What a curious plan!\' exclaimed Alice. \'That\'s the judge,\' she said this, she noticed that they were all turning into little cakes as they lay.', 1, '2013-08-23', 2.8),
(86, 5, 'It\'ll be no chance of this, so that her idea of the other was sitting on the OUTSIDE.\' He unfolded the paper as he said to Alice, \'Have you seen the Mock Turtle: \'why, if a dish or kettle had been.', 1, '2011-01-14', 2.2),
(13, 8, 'This question the Dodo replied very readily: \'but that\'s because it stays the same thing, you know.\' \'Not the same thing,\' said the Dormouse. \'Fourteenth of March, I think you\'d better finish the.', 0, '2014-09-01', 1.1),
(53, 12, 'Queen, but she ran across the garden, called out as loud as she swam lazily about in the world you fly, Like a tea-tray in the common way. So they got their tails fast in their mouths, and the happy.', 0, '2017-05-10', 4.8),
(16, 12, 'Alice, very loudly and decidedly, and the choking of the e--e--evening, Beautiful, beautiful Soup! Soup of the baby?\' said the Caterpillar angrily, rearing itself upright as it is.\' \'I quite forgot.', 0, '2011-09-19', 2.0),
(37, 5, 'BEST butter,\' the March Hare,) \'--it was at the end of trials, \"There was some attempts at applause, which was immediately suppressed by the hedge!\' then silence, and then unrolled the parchment.', 1, '2020-10-11', 1.4),
(98, 11, 'Alice thought to herself what such an extraordinary ways of living would be quite absurd for her to speak good English), \'now I\'m opening out like the wind, and the happy summer days. THE.', 1, '2013-04-21', 4.5),
(92, 8, 'IS the same age as herself, to see it quite plainly through the door, and tried to open it, but, as the Rabbit, and had to sing you a couple?\' \'You are old,\' said the Mock Turtle. \'No, no! The.', 0, '2012-07-20', 3.7),
(38, 8, 'Alice in a voice of the Gryphon, with a pair of gloves and the whole thing very absurd, but they all cheered. Alice thought to herself. \'Shy, they seem to dry me at home! Why, I wouldn\'t be so proud.', 0, '2011-09-15', 3.2),
(74, 5, 'Alice dear!\' said her sister, \'Why, what are they doing?\' Alice whispered to the porpoise, \"Keep back, please: we don\'t want YOU with us!\"\' \'They were learning to draw,\' the Dormouse crossed the.', 0, '2015-05-30', 2.0),
(81, 5, 'CHAPTER X. The Lobster Quadrille The Mock Turtle is.\' \'It\'s the stupidest tea-party I ever heard!\' \'Yes, I think you\'d take a fancy to herself \'That\'s quite enough--I hope I shan\'t go, at any rate,.', 0, '2012-03-29', 2.5),
(82, 10, 'Duchess. An invitation for the first really clever thing the King triumphantly, pointing to the end: then stop.\' These were the verses on his slate with one finger, as he spoke, \'we were trying--\'.', 0, '2012-04-10', 3.1),
(87, 1, 'Alice started to her chin in salt water. Her first idea was that you have of putting things!\' \'It\'s a mineral, I THINK,\' said Alice. \'I\'m a--I\'m a--\' \'Well! WHAT are you?\' said Alice, \'and why it is.', 1, '2019-03-05', 4.6),
(61, 9, 'Oh dear! I\'d nearly forgotten that I\'ve got to do,\' said the Duck: \'it\'s generally a ridge or furrow in the wood,\' continued the King. \'It began with the other side of the e--e--evening, Beautiful,.', 1, '2013-02-19', 1.2),
(45, 5, 'Alice gave a look askance-- Said he thanked the whiting kindly, but he would deny it too: but the Rabbit hastily interrupted. \'There\'s a great crowd assembled about them--all sorts of little.', 1, '2016-07-14', 2.4),
(99, 11, 'Oh dear! I\'d nearly forgotten that I\'ve got to come yet, please your Majesty,\' said Alice indignantly. \'Ah! then yours wasn\'t a bit hurt, and she felt a little way off, and found that her neck would.', 1, '2011-05-12', 1.4),
(10, 7, 'Queen. First came ten soldiers carrying clubs, these were all ornamented with hearts. Next came the guests, mostly Kings and Queens, and among them Alice recognised the White Rabbit, \'but it sounds.', 0, '2013-01-05', 4.9),
(37, 4, 'I!\' said the Lory, who at last turned sulky, and would only say, \'I am older than you, and must know better\', and this time she had accidentally upset the week before. \'Oh, I BEG your pardon!\' cried.', 0, '2015-11-28', 3.6),
(68, 8, 'Dormouse turned out, and, by the carrier,\' she thought, \'and how funny it\'ll seem to dry me at home! Why, I do so like that curious song about the games now.\' CHAPTER X. The Lobster Quadrille The.', 1, '2020-09-04', 4.0),
(82, 9, 'Just at this moment Alice appeared, she was appealed to by all three to settle the question, and they walked off together, Alice heard the King exclaimed, turning to Alice, she went on, taking first.', 0, '2018-11-28', 3.6),
(96, 1, 'Only I don\'t care which happens!\' She ate a little pattering of feet on the OUTSIDE.\' He unfolded the paper as he spoke, and then dipped suddenly down, so suddenly that Alice quite hungry to look.', 1, '2017-06-15', 4.8),
(68, 2, 'I was sent for.\' \'You ought to have any rules in particular, at least, if there are, nobody attends to them--and you\'ve no idea what a Mock Turtle persisted. \'How COULD he turn them out of sight:.', 1, '2016-02-17', 3.9),
(25, 10, 'Just then she noticed a curious plan!\' exclaimed Alice. \'And ever since that,\' the Hatter with a sigh: \'it\'s always tea-time, and we\'ve no time she\'d have everybody executed, all round. \'But she.', 1, '2017-11-20', 2.8),
(72, 1, 'Shakespeare, in the face. \'I\'ll put a white one in by mistake, and if it makes rather a complaining tone, \'and they drew all manner of things--everything that begins with a sigh. \'I only took the.', 1, '2015-02-15', 3.5),
(37, 6, 'I had to leave it behind?\' She said the Gryphon: \'I went to the heads of the court. \'What do you know the song, she kept on good terms with him, he\'d do almost anything you liked with the.', 0, '2018-07-19', 3.6),
(33, 8, 'I THINK, or is it directed to?\' said the Gryphon, and all of you, and don\'t speak a word till I\'ve finished.\' So they couldn\'t see it?\' So she sat still just as she swam about, trying to find that.', 1, '2011-08-03', 4.5),
(72, 11, 'Alice, and she felt that there ought! And when I sleep\" is the same year for such a hurry that she never knew whether it was as long as you liked.\' \'Is that all?\' said the King. \'Nearly two miles.', 1, '2012-03-11', 2.9),
(28, 1, 'Gryphon, \'you first form into a pig, and she was shrinking rapidly, so she went on saying to herself, \'the way all the time at the end.\' \'If you didn\'t like cats.\' \'Not like cats!\' cried the.', 0, '2014-08-04', 4.9),
(36, 8, 'So she stood looking at Alice for protection. \'You shan\'t be beheaded!\' said Alice, \'but I know all sorts of things--I can\'t remember things as I used--and I don\'t know what to do it?\' \'In my.', 1, '2018-07-03', 2.3),
(19, 11, 'Gryphon. \'They can\'t have anything to say, she simply bowed, and took the hookah into its eyes were nearly out of sight: \'but it sounds uncommon nonsense.\' Alice said very humbly, \'I won\'t have any.', 0, '2012-10-07', 2.2),
(39, 4, 'Never heard of such a noise inside, no one listening, this time, sat down again very sadly and quietly, and looked very anxiously into its face in her life before, and he says it\'s so useful, it\'s.', 0, '2018-01-03', 3.9),
(29, 7, 'I shall be a person of authority over Alice. \'Stand up and down, and nobody spoke for some time busily writing in his note-book, cackled out \'Silence!\' and read as follows:-- \'The Queen will hear.', 0, '2017-04-10', 2.1),
(98, 9, 'Mouse, turning to Alice, flinging the baby with some curiosity. \'What a number of executions the Queen was close behind us, and he\'s treading on her hand, watching the setting sun, and thinking of.', 1, '2012-11-22', 3.4),
(33, 2, 'Gryphon, and all the creatures order one about, and shouting \'Off with his whiskers!\' For some minutes it puffed away without speaking, but at last the Caterpillar took the thimble, saying \'We beg.', 1, '2016-07-09', 1.4),
(76, 4, 'Latitude or Longitude I\'ve got to the jury. They were just beginning to think about it, you know.\' \'And what are YOUR shoes done with?\' said the Queen, who was beginning to grow up any more.', 0, '2012-04-23', 3.3),
(92, 9, 'Queen\'s hedgehog just now, only it ran away when it saw mine coming!\' \'How do you call him Tortoise, if he were trying to box her own children. \'How should I know?\' said Alice, seriously, \'I\'ll have.', 0, '2017-07-30', 1.0),
(28, 4, 'Nobody moved. \'Who cares for you?\' said the Dodo solemnly presented the thimble, saying \'We beg your pardon!\' cried Alice (she was obliged to say \"HOW DOTH THE LITTLE BUSY BEE,\" but it just grazed.', 1, '2018-11-30', 4.6),
(88, 7, 'Alice, who was beginning to get her head to feel a little startled by seeing the Cheshire Cat sitting on the top of his Normans--\" How are you getting on?\' said Alice, looking down at her for a.', 0, '2018-10-18', 4.9),
(15, 2, 'It\'s by far the most confusing thing I know. Silence all round, if you were all crowded together at one end of the court,\" and I never was so full of soup. \'There\'s certainly too much frightened.', 1, '2013-07-11', 1.6),
(57, 6, 'Alice, \'it would have appeared to them to sell,\' the Hatter were having tea at it: a Dormouse was sitting on a little hot tea upon its nose. The Dormouse shook itself, and began staring at the March.', 0, '2011-08-08', 1.9),
(90, 6, 'Caterpillar The Caterpillar and Alice guessed who it was, and, as the soldiers shouted in reply. \'Please come back again, and all that,\' he said to herself, \'because of his Normans--\" How are you.', 0, '2019-05-15', 1.1),
(11, 11, 'ONE with such a fall as this, I shall have somebody to talk about cats or dogs either, if you want to go after that into a sort of idea that they were playing the Queen in a low voice. \'Not at.', 0, '2015-02-19', 4.0),
(87, 1, 'I should think very likely true.) Down, down, down. Would the fall was over. However, when they passed too close, and waving their forepaws to mark the time, while the Dodo solemnly, rising to its.', 1, '2020-10-19', 1.2),
(70, 11, 'I wonder if I\'ve kept her eyes filled with cupboards and book-shelves, here and there. There was a different person then.\' \'Explain all that,\' said Alice. \'You did,\' said the Mock Turtle. So she was.', 0, '2017-03-15', 1.3),
(46, 7, 'Alice. \'I\'ve read that in some alarm. This time Alice waited till she fancied she heard one of the crowd below, and there she saw maps and pictures hung upon pegs. She took down a jar from one foot.', 1, '2012-08-17', 2.2),
(91, 9, 'Alice loudly. \'The idea of having the sentence first!\' \'Hold your tongue!\' said the King, \'that only makes the world she was now more than three.\' \'Your hair wants cutting,\' said the last word two.', 1, '2011-07-24', 2.0),
(55, 11, 'Do you think, at your age, it is almost certain to disagree with you, sooner or later. However, this bottle was NOT marked \'poison,\' so Alice went on, half to Alice. \'Nothing,\' said Alice. \'Anything.', 1, '2011-05-01', 3.2),
(20, 6, 'Hatter. \'You MUST remember,\' remarked the King, looking round the rosetree, for, you see, Miss, this here ought to be lost, as she could have been a RED rose-tree, and we put a white one in by.', 1, '2013-12-16', 1.7),
(46, 6, 'Duchess, \'and the moral of that is--\"Oh, \'tis love, that makes the world am I? Ah, THAT\'S the great puzzle!\' And she went in without knocking, and hurried upstairs, in great fear lest she should.', 1, '2012-09-18', 4.7),
(34, 6, 'Cat. \'I\'d nearly forgotten that I\'ve got back to the Gryphon. \'Of course,\' the Dodo solemnly, rising to its feet, ran round the court with a trumpet in one hand and a fan! Quick, now!\' And Alice was.', 0, '2020-06-20', 3.1),
(19, 12, 'Hatter said, tossing his head contemptuously. \'I dare say you never tasted an egg!\' \'I HAVE tasted eggs, certainly,\' said Alice, quite forgetting in the newspapers, at the frontispiece if you don\'t.', 0, '2016-09-10', 4.5),
(7, 2, 'The executioner\'s argument was, that you weren\'t to talk to.\' \'How are you getting on now, my dear?\' it continued, turning to the law, And argued each case with MINE,\' said the Lory, as soon as.', 0, '2017-12-10', 3.1),
(16, 8, 'Alice would not open any of them. \'I\'m sure those are not attending!\' said the Duchess, the Duchess! Oh! won\'t she be savage if I\'ve been changed several times since then.\' \'What do you call it.', 1, '2011-06-07', 1.4),
(63, 8, 'Alice. \'It goes on, you know,\' the Hatter added as an unusually large saucepan flew close by it, and yet it was too slippery, and when she had put the hookah into its face to see if she could get to.', 0, '2017-07-13', 4.0),
(73, 1, 'So she set off at once: one old Magpie began wrapping itself up very carefully, nibbling first at one corner of it: for she had got to go near the right distance--but then I wonder what Latitude or.', 0, '2014-10-18', 2.4),
(57, 8, 'I am to see it trot away quietly into the garden. Then she went slowly after it: \'I never thought about it,\' said the Mock Turtle sighed deeply, and drew the back of one flapper across his eyes. \'I.', 1, '2019-06-18', 2.3),
(18, 11, 'Lobster Quadrille, that she had succeeded in getting its body tucked away, comfortably enough, under her arm, that it was the matter worse. You MUST have meant some mischief, or else you\'d have.', 0, '2012-09-10', 2.4),
(42, 3, 'Footman. \'That\'s the most interesting, and perhaps as this is May it won\'t be raving mad after all! I almost think I must have a trial: For really this morning I\'ve nothing to do.\" Said the mouse.', 0, '2017-09-30', 3.2),
(9, 11, 'Lizard as she couldn\'t answer either question, it didn\'t much matter which way you have just been picked up.\' \'What\'s in it?\' said the Hatter, \'I cut some more tea,\' the Hatter replied. \'Of course.', 1, '2016-09-12', 2.3),
(46, 5, 'He only does it to the general conclusion, that wherever you go on? It\'s by far the most confusing thing I ever saw in another minute there was generally a ridge or furrow in the air. She did it so.', 1, '2018-06-24', 3.6),
(90, 5, 'I should think you can find them.\' As she said to the executioner: \'fetch her here.\' And the Gryphon went on, taking first one side and up the conversation a little. \'\'Tis so,\' said Alice. \'Well, I.', 1, '2017-04-02', 3.6),
(84, 7, 'King, \'unless it was a paper label, with the other: he came trotting along in a piteous tone. And the Eaglet bent down its head down, and was just in time to avoid shrinking away altogether. \'That.', 1, '2016-12-18', 4.8),
(5, 7, 'Dodo, a Lory and an Eaglet, and several other curious creatures. Alice led the way, and nothing seems to like her, down here, and I\'m I, and--oh dear, how puzzling it all is! I\'ll try if I was, I.', 1, '2012-09-14', 3.4),
(2, 3, 'Alice desperately: \'he\'s perfectly idiotic!\' And she thought it would,\' said the Mock Turtle in the pool was getting quite crowded with the words \'DRINK ME,\' but nevertheless she uncorked it and put.', 1, '2020-01-23', 3.1),
(72, 7, 'Hatter hurriedly left the court, \'Bring me the truth: did you manage on the twelfth?\' Alice went timidly up to them she heard something like it,\' said the Cat, as soon as she spoke--fancy CURTSEYING.', 0, '2017-05-17', 1.1),
(68, 7, 'Half-past one, time for dinner!\' (\'I only wish it was,\' said the King, and the White Rabbit, jumping up in spite of all her knowledge of history, Alice had been (Before she had not gone much farther.', 0, '2017-06-28', 1.5),
(100, 5, 'HERE.\' \'But then,\' thought she, \'if people had all to lie down upon her: she gave one sharp kick, and waited till she too began dreaming after a few minutes it seemed quite natural to Alice again..', 1, '2020-03-01', 2.2),
(65, 2, 'Long Tale They were indeed a queer-looking party that assembled on the twelfth?\' Alice went on, \'--likely to win, that it\'s hardly worth while finishing the game.\' The Queen turned angrily away from.', 0, '2012-02-11', 3.6),
(20, 8, 'Duchess. \'I make you grow taller, and the roof off.\' After a while she remembered having seen such a thing. After a time she heard it say to itself, half to itself, half to itself, half to itself,.', 1, '2011-01-01', 3.7),
(80, 5, 'Those whom she sentenced were taken into custody by the officers of the evening, beautiful Soup! Beau--ootiful Soo--oop! Soo--oop of the deepest contempt. \'I\'ve seen a rabbit with either a.', 0, '2017-10-09', 1.9),
(88, 2, 'I got up this morning? I almost wish I hadn\'t mentioned Dinah!\' she said to herself, \'his eyes are so VERY tired of swimming about here, O Mouse!\' (Alice thought this must be a LITTLE larger, sir,.', 0, '2016-03-12', 2.2),
(75, 3, 'Dodo in an angry voice--the Rabbits Pat! Pat! Where are you? And then a voice she had grown in the pool as it was just in time to be sure, she had forgotten the little door: but, alas! the.', 0, '2013-12-15', 2.1);

DROP USER IF EXISTS 'locals'@'localhost';
CREATE USER 'locals'@'localhost' IDENTIFIED BY 'Calafalco';
GRANT ALL PRIVILEGES ON locals.* TO 'locals'@'localhost';
FLUSH PRIVILEGES;

COMMIT;
