<?php
use App\Model\Establiments;
$app->group('/establiments/', function () {

$this->get('', function ($req, $res, $args) {
$obj = new Establiments(); 
return $res
->withHeader('Content-type', 'application/json')
->getBody()
->write(
json_encode(
$obj->getall() 
)
);
});

$this->get('{id}', function ($req, $res, $args) {
$obj = new Establiments();
$pk_idestabliments=$args["id"];
return $res
->withHeader('Content-type', 'application/json')
->getBody()
->write(
json_encode(
$obj->get($pk_idestabliments)
)
);
});
});
