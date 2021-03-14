<?php

use App\Model\Comentari;

$app->group('/comentari/', function () {

    $this->get('', function ($req, $res, $args) {
        $this->logger->info("Comentari - GET - getAll");
        $obj = new Comentari();
        return $res->withJson($obj->getAll());
    });

    $this->get('{id}', function ($req, $res, $args) {
        $this->logger->info("Comentari - GET - getAll");
        $obj = new Comentari();
        return $res->withJson($obj->getById($args["id"]));
    });

    $this->post('', function ($req, $res, $args) {
        $this->logger->info("Comentari - POST - insert");
        $body = $req->getParsedBody();
        $obj = new Comentari();
        return $res->withJson($obj->insert($body));
    });

    $this->delete('{id}', function ($req, $res, $args) {
        $this->logger->info("Comentari - DELETE - delete");
        $obj = new Comentari();
        return $res->withJson($obj->delete($args["id"]));
    });

    $this->put('{id}', function ($req, $res, $args) {
        $this->logger->info("Comentari - PUT - update");
        $body = $req->getParsedBody();
        $obj = new Comentari();
        return $res->withJson($obj->update($args["id"], $body));
    });
});
