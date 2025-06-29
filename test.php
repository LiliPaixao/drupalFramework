<?php

use Drupal\offer\Commands\SeedGeneratorCommand;

require 'web/autoload.php';

// Inicializa o kernel do Drupal.
$kernel = \Drupal\Core\DrupalKernel::createFromRequest(
  \Symfony\Component\HttpFoundation\Request::createFromGlobals(),
  'prod',
  false
);
$kernel->boot();

$command = new SeedGeneratorCommand();
echo "Classe carregada\n";