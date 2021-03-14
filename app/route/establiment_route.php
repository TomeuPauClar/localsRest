<?php

use App\Model\Establiment;

$app->group('/establiment/', function () {

    $this->get('', function ($req, $res, $args) {
        $this->logger->info("Establiment - GET - getAll");
        $obj = new Establiment();
        return $res->withJson($obj->getAll());
    });

    $this->get('{id}', function ($req, $res, $args) {
        $this->logger->info("Establiment - GET - getById");
        $obj = new Establiment();
        return $res->withJson($obj->getById($args["id"]));
    });

    $this->get('slider/', function ($req, $res, $args) {
        $this->logger->info("Establiment - GET - getSlider");
        $obj = new Establiment();
        return $res->withJson($obj->getSlider());
    });

    $this->post('', function ($req, $res, $args) {
        $this->logger->info("Establiments - POST - insert");
        $body = $req->getParsedBody();
        $obj = new Establiment();
        return $res->withJson($obj->insert($body));
    });

    $this->delete('{id}', function ($req, $res, $args) {
        $this->logger->info("Establiment - DELETE - delete");
        $obj = new Establiment();
        return $res->withJson($obj->delete($args["id"]));
    });

    $this->put('{id}', function ($req, $res, $args) {
        $this->logger->info("Establiment - PUT - update");
        $body = $req->getParsedBody();
        $obj = new Establiment();
        return $res->withJson($obj->update($args["id"], $body));
    });
});
