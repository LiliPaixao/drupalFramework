<?php

namespace Drupal\offer\Commands;

use Drush\Commands\DrushCommands;

class TestCommand extends DrushCommands {
  /**
   * Test command.
   *
   * @command offer:test
   */
  public function test() {
    $this->output()->writeln("Test command works");
  }
}