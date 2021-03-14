<?php

$app->get('/[{name}]', function ($request, $response, $args) {
    $this->logger->info("Ruta per defecte");
    return $this->renderer->render($response, 'index.phtml', $args);
});
