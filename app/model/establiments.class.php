<?php

namespace App\Model;

use App\Lib\Database;
use App\Lib\Resposta;
use Exception;

class Establiments extends Table
{
    private $resposta;
    private $conn;


    public function __construct()
    {
        $tableName = 'establiment';
        $tablePK = "idEstabliment";
        parent::__construct($tableName, $tablePK);
        $this->conn = Database::getInstance()->getConnection();
        $this->resposta = new Resposta();
    }

    public function getById($id)
    {
        try {
            $respostaPare = parent::getById($id);
            if ($respostaPare->rowcount > 0) {
                $dades = $respostaPare->dades;
                $categoriaPreu = new CategoriaPreus();
                $dades["categoriaPreu"] = $categoriaPreu->getById($dades["idCategoriaPreu"])->dades;
                unset($dades["idCategoriaPreu"]);
                $this->resposta->setCorrecta(true, "Correcta.", $respostaPare->rowcount);
                $this->resposta->SetDades($dades);
            } else {
                $this->resposta->SetCorrecta(false, "Cap dada.", 0);
            }
            return $this->resposta;
        } catch (Exception $e) {
            $this->resposta->setCorrecta(false, $e->getMessage());
            return $this->resposta;
        }
    }
}
