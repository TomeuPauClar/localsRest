<?php

namespace App\Model;

use App\Lib\Database;
use App\Lib\Resposta;

class CategoriaPreus extends Table
{
    private $resposta;
    private $conn;


    public function __construct()
    {
        $tableName = 'categoria_preus';
        $tablePK = "PK_ID_PREUS";
        parent::__construct($tableName, $tablePK);
        $this->conn = Database::getInstance()->getConnection();
        $this->resposta = new Resposta();
    }
}
