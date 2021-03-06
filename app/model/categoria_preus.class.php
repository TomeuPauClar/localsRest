<?php

namespace App\Model;

use App\Lib\Database;
use App\Lib\Resposta;

class CategoriaPreu extends Table
{
    private $resposta;
    private $conn;


    public function __construct()
    {
        $tableName = 'categoriaPreu';
        $tablePK = "idCategoriaPreu";
        parent::__construct($tableName, $tablePK);
        $this->conn = Database::getInstance()->getConnection();
        $this->resposta = new Resposta();
    }
}
