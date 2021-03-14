<?php

use App\Model\Foto;

$app->group('/foto/', function () {

    $this->get('', function ($req, $res, $args) {
        $this->logger->info("Foto - GET - getAll");
        $obj = new Foto();
        return $res->withJson($obj->getAll());
    });

    $this->get('{id}', function ($req, $res, $args) {
        $this->logger->info("Foto - GET - getById");
        $obj = new Foto();
        return $res->withJson($obj->getById($args["id"]));
    });

    $this->post('', function ($req, $res, $args) {
        $this->logger->info("Foto - POST - insert");
        $body = $req->getParsedBody();
        $obj = new Foto();
        return $res->withJson($obj->insert($body));
    });

    $this->delete('{id}', function ($req, $res, $args) {
        $this->logger->info("Foto - DELETE - delete");
        $obj = new Foto();
        return $res->withJson($obj->delete($args["id"]));
    });

    $this->put('{id}', function ($req, $res, $args) {
        $this->logger->info("Foto - PUT - update");
        $body = $req->getParsedBody();
        $obj = new Foto();
        return $res->withJson($obj->update($args["id"], $body));
    });
});