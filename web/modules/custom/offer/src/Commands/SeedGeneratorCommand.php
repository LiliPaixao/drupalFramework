<?php

namespace Drupal\offer\Commands;

use Drush\Commands\DrushCommands;
use Drupal\offer\SeedData\SeedDataGenerator;
use Drush\Drush;

/**
 * Class SeedGeneratorCommand.
 * @package Drupal\offer\Commands
 */
class SeedGeneratorCommand extends DrushCommands {
/**
* Runs the OfferCreateSeeds command. Will create all data for the Offer platform.
*
* @command offer:offer-create-seeds
* @aliases offercs
* @usage drush offer-create-seeds
* Display 'Seed data created'
*/
  public function offerCreateSeeds()  {
    $seed = new SeedDataGenerator();
    $count = $seed->Generate('user');
    $this->output()->writeln("$count user(s) created");
  }

}