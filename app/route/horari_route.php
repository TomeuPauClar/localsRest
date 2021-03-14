<?php

use App\Model\Horari;

$app->group('/horari/', function () {

    $this->get('', function ($req, $res, $args) {
        $this->logger->info("Horari - GET - getAll");
        $obj = new Horari();
        return $res->withJson($obj->getAll());
    });

    $this->get('{id}', function ($req, $res, $args) {
        $this->logger->info("Horari - GET - getById");
        $obj = new Horari();
        return $res->withJson($obj->getById($args["id"]));
    });

    $this->post('', function ($req, $res, $args) {
        $this->logger->info("Horari - POST - insert");
        $body = $req->getParsedBody();
        $obj = new Horari();
        return $res->withJson($obj->insert($body));
    });

    $this->delete('{id}', function ($req, $res, $args) {
        $this->logger->info("Horari - DELETE - delete");
        $obj = new Horari();
        return $res->withJson($obj->delete($args["id"]));
    });

    $this->put('{id}', function ($req, $res, $args) {
        $this->logger->info("Horari - PUT - update");
        $body = $req->getParsedBody();
        $obj = new Horari();
        return $res->withJson($obj->update($args["id"], $body));
    });
});