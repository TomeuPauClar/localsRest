<?php

// Middleware GLOBAL

$app->add(function ($request, $response, $next) {
    //$response->getBody()->write('ABANS Global');
    $response = $next($request, $response);
    //$response->getBody()->write('DEPRES Global');

    return $response;
});
