<?php
use App\Model\Exemple;

$app->group('/exemple/', function () {

    $this->get('', function ($req, $res, $args) {
        return $res
           ->withHeader('Content-type', 'application/json')
           ->getBody()
           ->write(
             "Hola Mon"
           );
    });
    
    $this->get('json', function ($req, $res, $args) {
        $obj = new Exemple();   
        return $res
           ->withHeader('Content-type', 'application/json')
           ->getBody()
           ->write(
            json_encode(
                $obj->get()
            )
        );         
    });
        
});
