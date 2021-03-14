<?php

namespace App\Model;

use App\Lib\Database;
use App\Lib\Resposta;
use Exception;

class Usuari extends Table
{
    private $resposta;
    private $conn;


    public function __construct()
    {
        $tableName = 'usuari';
        $tablePK = "idUsuari";
        $tableFields=["idUsuari","email","nom","avatar","createdAt","token","isAdmin"];
        parent::__construct($tableName, $tablePK,$tableFields);
        $this->conn = Database::getInstance()->getConnection();
        $this->resposta = new Resposta();
    }

    public function insert($dades)
    {
        try {
            $email = $dades['email'];
            $nom = $dades['nom'];
            $password = $dades['password'];
            $passwordConfirmation = $dades['passwordConfirmation'];

            if ($password !== $passwordConfirmation) {
                $this->resposta->setCorrecta(false, "BadPasswordConfirmation");
                return $this->resposta;
            }

            if (strlen($email) < 8 || strlen($email) > 100) {
                $this->resposta->setCorrecta(false, "BadEmailFormat");
                return $this->resposta;
            }

            if (strlen($nom) < 1 || strlen($nom) > 50) {
                $this->resposta->setCorrecta(false, "BadNomFormat");
                return $this->resposta;
            }

            if (!preg_match("/^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z]).{8,}$/", $password)) {
                $this->resposta->setCorrecta(false, "BadPassword");
                return $this->resposta;
            }

            if (!$this->comprovarUsuari("", $email)) {
                $this->resposta->setCorrecta(false, "EmailDuplicat");
                return $this->resposta;
            }
            if (!$this->comprovarUsuari($nom, "")) {
                $this->resposta->setCorrecta(false, "NomDuplicat");
                return $this->resposta;
            }
            $sql = "INSERT INTO `usuari` (`nom`,`password`,`email`) VALUES ( :nom, :password, :email)";
            $stm = $this->conn->prepare($sql);
            $stm->bindValue(':nom', $nom);
            $stm->bindValue(':password', password_hash($password, PASSWORD_DEFAULT));
            $stm->bindValue(':email', $email);
            $stm->execute();
            $sql = "SELECT max(idUsuari) AS N FROM usuari";
            $stm = $this->conn->prepare($sql);
            $stm->execute();
            $row = $stm->fetch();
            $id = $row["N"];
            $this->resposta->setCorrecta(true, "S'ha iniciat sessió correctament.");
            $this->renovarToken($id);
            return $this->resposta;
        } catch (Exception $e) {
            $this->resposta->setCorrecta(false, "Error insertant un usuari: " . $e->getMessage());
            return $this->resposta;
        }
    }

    public function login($dades)
    {
        try {
            $nom = $dades['nom'];
            $password = $dades['password'];

            $stm = $this->conn->prepare("SELECT `idUsuari`,`nom`,`password` FROM `usuari` WHERE `nom` = :nom OR `email` = :nom");
            $stm->bindValue(':nom', $nom);
            $stm->execute();
            $count = $stm->rowCount();
            if ($count == 1) {
                $tupla = $stm->fetch();
                
                    $hashedPassword = $tupla["password"];
                    if (password_verify($password, $hashedPassword)) {
                        $this->renovarToken($tupla["idUsuari"]);
                        $newUserData = $this->getById($tupla["idUsuari"]);
                        $this->resposta->setDades($newUserData->dades);
                        $this->resposta->setCorrecta(true, "Usuari correcte.");
                    } else {
                        $this->resposta->setCorrecta(false, "BadPassword");
                    }
              
            } else {
                $this->resposta->setCorrecta(false, "No existeix ninguna conta amb aquest correu electronic o usuari.");
            }
            return $this->resposta;
        } catch (Exception $e) {
            $this->resposta->setCorrecta(false, $e->getMessage());
            return $this->resposta;
        }
    }

    public function renovarToken($idUsuari){
        $token = bin2hex(openssl_random_pseudo_bytes(16));
                        $tokenLimit = date('Y-m-d H:i:s', strtotime('+1 week'));
                        $sql = "UPDATE `usuari` SET `token` = :token, tokenLimit= :tokenLimit WHERE `idUsuari` = :idUsuari";
                        $stm = $this->conn->prepare($sql);
                        $stm->bindValue(':token', $token);
                        $stm->bindValue(':tokenLimit', $tokenLimit);
                        $stm->bindValue(':idUsuari', $idUsuari);
                        $stm->execute();
    }

    public function validaToken($token)
    {
        try {
            $sql = "SELECT idUsuari, tokenLimit, isAdmin FROM `usuari` WHERE token= ?";
            $stm = $this->conn->prepare($sql);
            $stm->execute(array($token));
            if ($tupla = $stm->fetch()) {
                if ($tupla['tokenLimit'] > date('Y-m-d H:i:s')) {
                    $tokenLimit = date('Y-m-d H:i:s', strtotime('+1 week'));
                    $sql = "UPDATE `usuari` SET 
                             tokenLimit= ?
                              WHERE idUsuari = ?";
                    $this->conn->prepare($sql)->execute(array($tokenLimit, $tupla["idUsuari"]));
                    $newUserData = $this->getById($tupla["idUsuari"]);
                    $this->resposta->setDades($newUserData->dades);
                    $this->resposta->setCorrecta(true, "Token OK!");
                } else {
                    $this->resposta->setCorrecta(false, "Temps expirat");
                }
            } else {
                $this->resposta->setCorrecta(false, "Token incorrecte.");
            }

            return $this->resposta;
        } catch (Exception $e) {
            $this->resposta->setCorrecta(false, "Error " . $e->getMessage(), 0);
            return $this->resposta;
        }
    }

    private function comprovarUsuari($nom, $email, $idUsuari = 0)
    {
        try {
            $stm = $this->conn->prepare("SELECT `idUsuari` FROM `usuari` WHERE `idUsuari` != :idUsuari AND (`nom` = :nom OR `email` = :email)");
            $stm->bindValue(':idUsuari', $idUsuari);
            $stm->bindValue(':nom', $nom);
            $stm->bindValue(':email', $email);
            $stm->execute();
            $count = $stm->rowCount();
            if ($count == 1) {
                return false;
            }
            return true;
        } catch (Exception $e) {
            return $e;
        }
    }

    
}