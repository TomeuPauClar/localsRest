<?php

use App\Model\CategoriaFoto;

$app->group('/categoria-foto/', function () {

    $this->get('', function ($req, $res, $args) {
        $this->logger->info("Categoria Foto - GET - getAll");
        $obj = new CategoriaFoto();
        return $res->withJson($obj->getAll());
    });

    $this->get('{id}', function ($req, $res, $args) {
        $this->logger->info("Categoria Foto - GET - getAll");
        $obj = new CategoriaFoto();
        return $res->withJson($obj->getById($args["id"]));
    });

    $this->post('', function ($req, $res, $args) {
        $this->logger->info("Categoria Foto - POST - insert");
        $body = $req->getParsedBody();
        $obj = new CategoriaFoto();
        return $res->withJson($obj->insert($body));
    });

    $this->delete('{id}', function ($req, $res, $args) {
        $this->logger->info("Categoria Foto - DELETE - delete");
        $obj = new CategoriaFoto();
        return $res->withJson($obj->delete($args["id"]));
    });

    $this->put('{id}', function ($req, $res, $args) {
        $this->logger->info("Categoria Foto - PUT - update");
        $body = $req->getParsedBody();
        $obj = new CategoriaFoto();
        return $res->withJson($obj->update($args["id"], $body));
    });
});
