<?php

namespace App\Model;

use App\Lib\Database;
use App\Lib\Resposta;
use FFI\Exception;

class Comentari extends Table
{
    private $resposta;
    private $conn;


    public function __construct()
    {
        $tableName = 'comentari';
        $tablePK = "idComentari";
        parent::__construct($tableName, $tablePK);
        $this->conn = Database::getInstance()->getConnection();
        $this->resposta = new Resposta();
    }

    public function getDarrersComentarisEstabliment($id){
        try {
            $result = array();
            $stm = $this->conn->prepare("SELECT idComentari, nom, comentari, isValidat, data, valoracio FROM comentari NATURAL JOIN usuari where idEstabliment=:id ORDER BY data desc Limit 5");
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
}