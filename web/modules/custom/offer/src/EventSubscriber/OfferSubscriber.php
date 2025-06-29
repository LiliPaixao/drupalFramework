<?php

namespace Drupal\offer\EventSubscriber;

use Symfony\Component\EventDispatcher\EventSubscriberInterface;
use Symfony\Component\Httpkernel\KernelEvents;

class OfferSubscriber implements EventSubscriberInterface {

    /**
     * {@inheritdoc}
    **/
    public static function getSubscribedEvents() {
        $events[kernelEvents::REQUEST][] = ['printMessage'];
        return $events;
    }

    public function printMessage() {
        \Drupal::messenger()->addMessage('Teste');
    }

}