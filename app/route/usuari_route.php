<?php

use App\Model\Usuari;

$app->group('/usuari/', function () {

    $this->get('', function ($req, $res, $args) {
        $this->logger->info("Usuaris - GET - getAll");
        $obj = new Usuari();
        return $res->withJson($obj->getAll());
    });

    $this->get('{id}', function ($req, $res, $args) {
        $this->logger->info("Usuaris - GET - getById");
        $obj = new Usuari();
        return $res->withJson($obj->getById($args["id"]));
    });

    $this->post('', function ($req, $res, $args) {
        $this->logger->info("Usuaris - POST - insert");
        $body = $req->getParsedBody();
        $obj = new Usuari();
        return $res->withJson($obj->insert($body));
    });

    $this->post('login/', function ($req, $res, $args) {
        $this->logger->info("Usuaris - POST - login");
        $body = $req->getParsedBody();
        $obj = new Usuari();
        return $res->withJson($obj->login($body));
    });

    $this->get('validar/{token}', function ($req, $res, $args) {
        $this->logger->info("Usuaris - GET - validaToken");
        $obj = new Usuari();
        return $res->withJson($obj->validaToken($args["token"]));
    });

    $this->delete('{id}', function ($req, $res, $args) {
        $this->logger->info("Usuaris - DELETE - delete");
        $obj = new Usuari();
        return $res->withJson($obj->delete($args["id"]));
    });

    $this->put('{id}', function ($req, $res, $args) {
        $this->logger->info("Usuaris - PUT - update");
        $body = $req->getParsedBody();
        $obj = new Usuari();
        return $res->withJson($obj->update($args["id"], $body));
    });
});