<?php

namespace App\Model;
use App\Lib\Database; 
use App\Lib\Resposta;
use \PDO;
use \Exception;

class Establiments
{
    private $conn;       //connexió a la base de dades (PDO)
    private $resposta;   // resposta

    public function __CONSTRUCT()
    {
        $this->conn = Database::getInstance()->getConnection();
        $this->resposta = new Resposta();
    }

    public function getAll($orderby = "PK_ID_ESTABLIMENT")
    {
        try {
            $stm = $this->conn->prepare("SELECT PK_ID_ESTABLIMENT,NOM, DESTACAT,LATITUD,LONGITUDS,WEB,DESCRIPCIO,DIRECCIO,TELEFON,FK_ID_PREUS FROM establiments ORDER BY $orderby");
            $stm->execute();
            $tuples = $stm->fetchAll();
            $this->resposta->setDades($tuples);    // array de tuples
            $this->resposta->setCorrecta(true);       // La resposta es correcta        
            return $this->resposta;
        } catch (Exception $e) {   // hi ha un error posam la resposta a fals i tornam missatge d'error
            $this->resposta->setCorrecta(false, $e->getMessage());
            return $this->resposta;
        }
    }

    public function get($id)
    {
        try {
            $result = array();
            $stm = $this->conn->prepare("SELECT PK_ID_ESTABLIMENT,NOM, DESTACAT,LATITUD,LONGITUDS,WEB,DESCRIPCIO,DIRECCIO,TELEFON FROM establiments where PK_ID_ESTABLIMENT=:id");
            $stm->bindValue(':id', $id);
            $stm->execute();
            $tupla = $stm->fetch();
            $newQuery = $this->conn->prepare("SELECT PK_ID_PREUS,PREUS FROM establiments INNER JOIN categoria_preus on establiments.FK_ID_PREUS=categoria_preus.PK_ID_PREUS where PK_ID_ESTABLIMENT=:id");
            $newQuery->bindValue(':id', $id);
            $newQuery->execute();
            $tupla["CATEGORIA_PREUS"] = $newQuery->fetch();
            $newQuery = $this->conn->prepare("SELECT PK_ID_CUINA,TITOL,DESCRIPCIO FROM tipus_cuina INNER JOIN tipus_cuina_establiment on tipus_cuina_establiment.PK_FK_ID_CUINA=tipus_cuina.PK_ID_CUINA where PK_FK_ID_ESTABLIMENT=:id");
            $newQuery->bindValue(':id', $id);
            $newQuery->execute();
            $tupla["TIPUS_CUINA"] = $newQuery->fetchAll();
            $newQuery = $this->conn->prepare("SELECT PK_ID_HORARI,DIA,OBREN,TANQUEN FROM horaris where FK_ID_ESTABLIMENT=:id");
            $newQuery->bindValue(':id', $id);
            $newQuery->execute();
            $tupla["HORARI"] = $newQuery->fetchAll();
            $newQuery = $this->conn->prepare("SELECT PK_ID_FOTO,FK_ID_CATEGORIA,RUTA,CATEGORIA,DESCRIPCIO FROM fotos INNER JOIN categoria_foto on fotos.FK_ID_CATEGORIA=categoria_foto.PK_ID_CATEGORIA where FK_ID_ESTABLIMENT=:id");
            $newQuery->bindValue(':id', $id);
            $newQuery->execute();
            $tupla["FOTOS"] = $newQuery->fetchAll();
            $newQuery = $this->conn->prepare("SELECT PK_ID_VALIDACIO,COMENTARIO,VALIDAT,DATETIME,VALORACIO,FK_ID_USUARI,NOM FROM valoracio INNER JOIN usuaris on valoracio.FK_ID_USUARI=usuaris.PK_ID_USUARI where FK_ID_ESTABLIMENT=:id order by DATETIME desc Limit 5");
            $newQuery->bindValue(':id', $id);
            $newQuery->execute();
            $tupla["VALORACIONS"] = $newQuery->fetchAll();
            $this->resposta->setDades($tupla);    // array de tuples
            $this->resposta->setCorrecta(true);       // La resposta es correcta        
            return $this->resposta;
        } catch (Exception $e) {   // hi ha un error posam la resposta a fals i tornam missatge d'error
            $this->resposta->setCorrecta(false, $e->getMessage());
            return $this->resposta;
        }
    }
}