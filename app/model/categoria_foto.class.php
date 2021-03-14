<?php

namespace App\Model;

use App\Lib\Database;
use App\Lib\Resposta;

class CategoriaFoto extends Table
{
    private $resposta;
    private $conn;


    public function __construct()
    {
        $tableName = 'categoriaFoto';
        $tablePK = "idCategoriaFoto";
        parent::__construct($tableName, $tablePK);
        $this->conn = Database::getInstance()->getConnection();
        $this->resposta = new Resposta();
    }
}