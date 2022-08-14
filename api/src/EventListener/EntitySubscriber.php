<?php

namespace App\EventListener;

use App\Helper\ReflectionHelper;
use Doctrine\Common\EventSubscriber;
use Doctrine\ORM\Events;
use Doctrine\Persistence\Event\LifecycleEventArgs;
use Symfony\Component\Uid\Uuid;

class EntitySubscriber implements EventSubscriber
{
    public function getSubscribedEvents(): array
    {
        return [Events::prePersist];
    }

    public function prePersist(LifecycleEventArgs $args)
    {
        $object = $args->getObject();
        if (!method_exists($object, 'getId')) {
            return;
        }

        if (null !== $object->getId()) {
            return;
        }

        ReflectionHelper::setProperty($object, 'id', Uuid::v4());
    }
}
