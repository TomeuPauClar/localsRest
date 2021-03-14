<?php

namespace App\Model;

use App\Lib\Database;
use App\Lib\Resposta;
use Exception;
use PDO;

class Foto extends Table
{
    private $resposta;
    private $conn;


    public function __construct()
    {
        $tableName = 'foto';
        $tablePK = "idFoto";
        parent::__construct($tableName, $tablePK);
        $this->conn = Database::getInstance()->getConnection();
        $this->resposta = new Resposta();
    }

    public function getFotoDestacada($id)
    {
        try {
            $result = array();
            $stm = $this->conn->prepare("SELECT nomFoto FROM foto where idEstabliment=:id AND idCategoriaFoto=2 Limit 1");
            $stm->bindValue(':id', $id);
            $stm->execute();
            $tupla = $stm->fetch(PDO::FETCH_COLUMN,0);
            $this->resposta->setDades($tupla);
            $this->resposta->setCorrecta(true);     
            return $this->resposta;
        } catch (Exception $e) {
            $this->resposta->setCorrecta(false, $e->getMessage());
            return $this->resposta;
        }
    }

    public function getAllFotosEstabliment($id)
    {
        try {
            $result = array();
            $stm = $this->conn->prepare("SELECT idFoto, nomFoto, nomCategoria FROM foto NATURAL JOIN categoriaFoto where idEstabliment=:id");
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