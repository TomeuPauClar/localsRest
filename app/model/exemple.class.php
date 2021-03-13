<?php
namespace App\Model;

use App\Lib\Database;  // Clase per conectar a la base de dades
use App\Lib\Resposta;  // Clase per generar una resposta
use PDO;
use Exception;

class Exemple {

    private $conn;       //connexió a la base de dades (PDO)
    private $resposta;   // resposta

    public function __CONSTRUCT() {
        // $this->conn = Database::getInstance()->getConnection();  //Conectam
        $this->resposta = new Resposta();                       // Cream objecte resposta
    }

    public function get() {
        try {
            // Feim una consulta a la base de dades que ens retorna un array de tuples.
            $tuples = array();
            $tuples[] = array("codi"=>1,"descripcio"=>"tupla 1 codi 1");
            $tuples[] = array("codi"=>2,"descripcio"=>"tupla 2 codi 2");
            $this->resposta->setDades($tuples);    // array de tuples
            $this->resposta->setCorrecta(true, 2);       // La resposta es correcta        
            return $this->resposta;
        } catch (\Exception $e) {   // hi ha un error posam la resposta a fals i tornam missatge d'error
            $this->resposta->setCorrecta(false, 0, $e->getMessage());
            return $this->resposta;
        }
    }
}
