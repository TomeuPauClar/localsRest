<?php

namespace App\Model;

use App\Lib\Database;
use App\Lib\Resposta;
use \PDO;
use \Exception;

class Table
{
    private $resposta;
    private $conn;
    private $tableName;
    private $tablePK;
    private $tableFields;

    public function __construct($tableName, $tablePK, $tableFields = null)
    {
        $this->conn = Database::getInstance()->getConnection();
        $this->resposta = new Resposta();
        $this->tableName = $tableName;
        $this->tablePK = $tablePK;
        $this->tableFields = $tableFields;
    }

    public function getAll()
    {
        try {
            $tableFields = isset($this->tableFields) && !empty($this->tableFields) ? implode(",", $this->tableFields) : "*";
            $stm = $this->conn->prepare("SELECT $tableFields FROM $this->tableName ORDER BY $this->tablePK");
            $stm->execute();
            $rowCount = $stm->rowCount();
            if ($rowCount > 0) {
                $dades = $stm->fetchAll();
                $this->resposta->setCorrecta(true, "Correcta.", $rowCount);
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

    public function getById($id)
    {
        try {
            $tableFields = isset($this->tableFields) && !empty($this->tableFields) ? implode(",", $this->tableFields) : "*";
            $stm = $this->conn->prepare("SELECT $tableFields FROM $this->tableName WHERE $this->tablePK = $id");
            $stm->execute();
            $rowCount = $stm->rowCount();
            if ($rowCount > 0) {
                $dades = $stm->fetch();
                $this->resposta->setCorrecta(true, "Correcta.", $rowCount);
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

    public function insert(array $dades)
    {
        try {
            $sql = "SELECT max($this->tablePK) AS N FROM `$this->tableName`";
            $stm = $this->conn->prepare($sql);
            $stm->execute();
            $row = $stm->fetch();
            $id = $row["N"] + 1;

            unset($dades[$this->tablePK]);
            $fieldsString = implode("`,`", array_keys($dades));
            $valuesString = implode(",:", array_keys($dades));
            $sql = "INSERT INTO `$this->tableName` (`$this->tablePK`, `$fieldsString`) VALUES (:id, :$valuesString)";

            $stm = $this->conn->prepare($sql);
            $stm->bindValue(':id', $id);
            foreach ($dades as $key => $value) {
                $stm->bindValue($key, $value);
            }
            $stm->execute();
            $this->resposta->SetDades($this->getById($id)->dades);
            $this->resposta->setCorrecta(true, "Nova tupla insertada a " . $this->tableName . ".");
            return $this->resposta;
        } catch (Exception $e) {
            $this->resposta->setCorrecta(false, "Error insertant a " . $this->tableName . ": " . $e->getMessage());
            return $this->resposta;
        }
    }

    public function delete($id)
    {
        try {
            $stm = $this->conn->prepare("DELETE FROM `$this->tableName` WHERE `$this->tablePK`=:id");
            $stm->bindValue(':id', $id);
            $stm->execute();
            $this->resposta->setCorrecta(true, "Tupla eliminada a " . $this->tableName . ".");
            return $this->resposta;
        } catch (Exception $e) {
            $this->resposta->setCorrecta(false, "Error borrant a " . $this->tableName . ": " . $e->getMessage());
            return $this->resposta;
        }
    }

    public function update($id, $dades)
    {
        try {
            unset($dades[$this->tablePK]);
            $set = "`$this->tablePK`=:id";
            foreach ($dades as $key => $v) {
                $set .= ", `$key`=:$key";
            }

            $sql = "UPDATE `$this->tableName` SET $set WHERE `$this->tablePK`=:id";

            $stm = $this->conn->prepare($sql);
            $stm->bindValue(':id', $id);
            foreach ($dades as $key => $value) {
                $stm->bindValue($key, $value);
            }
            $stm->execute();
            $this->resposta->SetDades($this->getById($id)->dades);
            $this->resposta->setCorrecta(true, "Tupla modificada a " . $this->tableName . ".");
            return $this->resposta;
        } catch (Exception $e) {
            $this->resposta->setCorrecta(false, "Error insertant: " . $e->getMessage());
            return $this->resposta;
        }
    }
}
