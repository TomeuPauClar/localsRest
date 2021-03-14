<?php

use App\Model\CategoriaPreus;

$app->group('/categoria-preus/', function () {

    $this->get('', function ($req, $res, $args) {
        $this->logger->info("Categoria Preus - GET - getAll");
        $obj = new CategoriaPreus();
        return $res->withJson($obj->getAll());
    });

    $this->get('{id}', function ($req, $res, $args) {
        $this->logger->info("Categoria Preus - GET - getAll");
        $obj = new CategoriaPreus();
        return $res->withJson($obj->getById($args["id"]));
    });

    $this->post('', function ($req, $res, $args) {
        $this->logger->info("Categoria Preus - POST - insert");
        $body = $req->getParsedBody();
        $obj = new CategoriaPreus();
        return $res->withJson($obj->insert($body));
    });

    $this->delete('{id}', function ($req, $res, $args) {
        $this->logger->info("Categoria Preus - DELETE - delete");
        $obj = new CategoriaPreus();
        return $res->withJson($obj->delete($args["id"]));
    });

    $this->put('{id}', function ($req, $res, $args) {
        $this->logger->info("Categoria Preus - PUT - update");
        $body = $req->getParsedBody();
        $obj = new CategoriaPreus();
        return $res->withJson($obj->update($args["id"], $body));
    });
});
