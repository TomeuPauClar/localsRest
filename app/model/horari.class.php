<?php

namespace App\Model;

use App\Lib\Database;
use App\Lib\Resposta;

class Horari extends Table
{
    private $resposta;
    private $conn;


    public function __construct()
    {
        $tableName = 'horari';
        $tablePK = "idHorari";
        parent::__construct($tableName, $tablePK);
        $this->conn = Database::getInstance()->getConnection();
        $this->resposta = new Resposta();
    }
}