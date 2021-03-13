<?php

$app->get('/[{name}]', function ($request,$response,$args) {
    // Exemple us del sistema de logs (Monolog)
    $this->logger->info("Ruta per defecte");

    // Renderitzar la vista index.phtml
    return $this->renderer->render($response, 'index.phtml', $args);
});
