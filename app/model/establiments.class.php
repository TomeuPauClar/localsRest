<?php

namespace App\Model;

use App\Lib\Database;
use App\Lib\Resposta;

class Establiments extends Table
{
    private $resposta;
    private $conn;


    public function __construct()
    {
        $tableName = 'establiments';
        $tablePK = "PK_ID_ESTABLIMENT";
        $tableFields = ["PK_ID_ESTABLIMENT", "NOM", "DESCRIPCIO"];
        parent::__construct($tableName, $tablePK, $tableFields);
        $this->conn = Database::getInstance()->getConnection();
        $this->resposta = new Resposta();
    }
}