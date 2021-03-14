<?php

namespace App\Model;

use App\Lib\Database;
use App\Lib\Resposta;
use Exception;

class Establiment extends Table
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
                $categoriaPreu = new CategoriaPreu();
                $dades["categoriaPreu"] = $categoriaPreu->getById($dades["idCategoriaPreu"])->dades;
                unset($dades["idCategoriaPreu"]);
                $fotos = new Foto();
                $dades["fotos"] = $fotos->getAllFotosEstabliment($id)->dades;
                $tipusCuina = new TipusCuina();
                $dades["tipusCuina"]=$tipusCuina->getTipusCuinaEstabliment($id)->dades;
                $comentaris = new Comentari();
                $dades["comentaris"]=$comentaris->getDarrersComentarisEstabliment($id)->dades;
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

    public function getSlider(){
        try {
            $stm = $this->conn->prepare("SELECT idEstabliment, nom, telefon, nota FROM establiment where destacat=1");
            $stm->execute();
            $tuples = $stm->fetchAll();
            foreach ($tuples as $key=>$valor) {
                $foto = new Foto();
                $tuples[$key]["foto"]= $foto->getFotoDestacada($valor["idEstabliment"])->dades;
            }
            $this->resposta->setDades($tuples);
            return $this->resposta;
        } catch (Exception $e) {
            $this->resposta->setCorrecta(false, $e->getMessage());
            return $this->resposta;
        }
    }
}
