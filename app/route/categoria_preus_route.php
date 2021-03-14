<?php

use App\Model\CategoriaPreu;

$app->group('/categoria-preu/', function () {

    $this->get('', function ($req, $res, $args) {
        $this->logger->info("Categoria Preu - GET - getAll");
        $obj = new CategoriaPreu();
        return $res->withJson($obj->getAll());
    });

    $this->get('{id}', function ($req, $res, $args) {
        $this->logger->info("Categoria Preu - GET - getById");
        $obj = new CategoriaPreu();
        return $res->withJson($obj->getById($args["id"]));
    });

    $this->post('', function ($req, $res, $args) {
        $this->logger->info("Categoria Preu - POST - insert");
        $body = $req->getParsedBody();
        $obj = new CategoriaPreu();
        return $res->withJson($obj->insert($body));
    });

    $this->delete('{id}', function ($req, $res, $args) {
        $this->logger->info("Categoria Preu - DELETE - delete");
        $obj = new CategoriaPreu();
        return $res->withJson($obj->delete($args["id"]));
    });

    $this->put('{id}', function ($req, $res, $args) {
        $this->logger->info("Categoria Preu - PUT - update");
        $body = $req->getParsedBody();
        $obj = new CategoriaPreu();
        return $res->withJson($obj->update($args["id"], $body));
    });
});
