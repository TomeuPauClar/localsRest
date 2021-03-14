<?php

use App\Model\Establiments;

$app->group('/establiments/', function () {

    $this->get('', function ($req, $res, $args) {
        $this->logger->info("Establiments - GET - getAll");
        $obj = new Establiments();
        return $res->withJson($obj->getAll());
    });

    $this->get('{id}', function ($req, $res, $args) {
        $this->logger->info("Establiments - GET - getAll");
        $obj = new Establiments();
        return $res->withJson($obj->getById($args["id"]));
    });

    $this->post('', function ($req, $res, $args) {
        $this->logger->info("Establiments - POST - insert");
        $body = $req->getParsedBody();
        $obj = new Establiments();
        return $res->withJson($obj->insert($body));
    });

    $this->delete('{id}', function ($req, $res, $args) {
        $this->logger->info("Establiments - DELETE - delete");
        $obj = new Establiments();
        return $res->withJson($obj->delete($args["id"]));
    });

    $this->put('{id}', function ($req, $res, $args) {
        $this->logger->info("Establiments - PUT - update");
        $body = $req->getParsedBody();
        $obj = new Establiments();
        return $res->withJson($obj->update($args["id"], $body));
    });
});
