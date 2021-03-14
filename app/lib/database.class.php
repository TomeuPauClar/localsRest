<?php

namespace App\Lib;

use PDO;

class Database
{

  private static $instance = null;
  private $pdo;
  private $host = BBDD_HOST;
  private $user = BBDD_USER;
  private $pass = BBDD_PASS;
  private $dbname = BBDD_NAME;

  private function __construct()
  {
    $this->pdo = new PDO(
      "mysql:host={$this->host}; dbname={$this->dbname}",
      $this->user,
      $this->pass,
      array(PDO::MYSQL_ATTR_INIT_COMMAND => "SET NAMES 'utf8'")
    );
    $this->pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $this->pdo->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC);
  }

  public static function getInstance()
  {
    if (!self::$instance) {
      self::$instance = new Database();
    }
    return self::$instance;
  }

  public function getConnection()
  {
    return $this->pdo;
  }
}
