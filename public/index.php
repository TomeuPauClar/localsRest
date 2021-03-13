<?php
// Carregar Llibreries Slim
require __DIR__ . '/../vendor/autoload.php';

// Iniciar l'aplicació
$settings = require __DIR__ . '/../src/settings.php';  // opcions de configuració
$app = new \Slim\App($settings);

// Carregar dependències
require __DIR__ . '/../src/dependencies.php';

// Carregam el nostre codi
require __DIR__ . '/../app/app_loader.php';

// Executar
$app->run();
