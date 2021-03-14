<?php

use App\Model\TipusCuina;

$app->group('/tipus-cuina/', function () {

    $this->get('', function ($req, $res, $args) {
        $this->logger->info("TipusCuina - GET - getAll");
        $obj = new TipusCuina();
        return $res->withJson($obj->getAll());
    });

    $this->get('{id}', function ($req, $res, $args) {
        $this->logger->info("TipusCuina - GET - getAll");
        $obj = new TipusCuina();
        return $res->withJson($obj->getById($args["id"]));
    });

    $this->post('', function ($req, $res, $args) {
        $this->logger->info("TipusCuina - POST - insert");
        $body = $req->getParsedBody();
        $obj = new TipusCuina();
        return $res->withJson($obj->insert($body));
    });
    $this->post('establiment/{id}', function ($req, $res, $args) {
        $this->logger->info("TipusCuina - POST - insert");
        $body = $req->getParsedBody();
        $obj = new TipusCuina();
        return $res->withJson($obj->insertTipusCuinaEstabliment($args["id"],$body));
    });

    $this->delete('{id}', function ($req, $res, $args) {
        $this->logger->info("TipusCuina - DELETE - delete");
        $obj = new TipusCuina();
        return $res->withJson($obj->delete($args["id"]));
    });

    $this->put('{id}', function ($req, $res, $args) {
        $this->logger->info("TipusCuina - PUT - update");
        $body = $req->getParsedBody();
        $obj = new TipusCuina();
        return $res->withJson($obj->update($args["id"], $body));
    });
});