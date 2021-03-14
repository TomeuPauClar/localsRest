<?php

namespace App\Model;

use App\Lib\Database;
use App\Lib\Resposta;
use Exception;

class TipusCuina extends Table
{
    private $resposta;
    private $conn;


    public function __construct()
    {
        $tableName = 'tipusCuina';
        $tablePK = "idTipusCuina";
        parent::__construct($tableName, $tablePK);
        $this->conn = Database::getInstance()->getConnection();
        $this->resposta = new Resposta();
    }

    public function getTipusCuinaEstabliment($id){
        try {
            $result = array();
            $stm = $this->conn->prepare("SELECT titol, descripcio FROM tipusCuina NATURAL JOIN tipusCuina_establiment where idEstabliment=:id");
            $stm->bindValue(':id', $id);
            $stm->execute();
            $tupla = $stm->fetchAll();
            $this->resposta->setDades($tupla);
            $this->resposta->setCorrecta(true);     
            return $this->resposta;
        } catch (Exception $e) {
            $this->resposta->setCorrecta(false, $e->getMessage());
            return $this->resposta;
        }
    }

    public function insertTipusCuinaEstabliment($id, $dades){
        
            try {
                $value="";
                foreach ($dades["tipusCuina"] as $key=>$valor) {
                    $idTipus=$valor["idTipusCuina"];
                    $value.="($id,$idTipus),";
                }
                $value = substr($value, 0, -1);
                $sql = "INSERT INTO `tipuscuina_establiment` VALUES $value";
                $stm = $this->conn->prepare($sql);
                $stm->execute();
            $this->resposta->setCorrecta(true, "Noves tuples insertades a tipuscuina_establiment.");
                return $this->resposta;
            } catch (Exception $e) {
                $this->resposta->setCorrecta(false, $e->getMessage());
                return $this->resposta;
            }
    }
}