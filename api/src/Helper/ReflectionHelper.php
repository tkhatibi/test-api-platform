<?php

namespace App\Helper;

use Exception;
use ReflectionClass;
use ReflectionProperty;
use Throwable;

class ReflectionHelper
{
    public static function setProperty(
        object $object,
        string $name,
        $value,
        bool $catchError = false
    ) {
        try {
            $refProperty = static::getReflectionProperty(new ReflectionClass($object), $name);
            $refProperty->setAccessible(true);
            $refProperty->setValue($object, $value);
        } catch (Throwable $throwable) {
            if ($catchError) {
                throw $throwable;
            }
        }
    }

    public static function getReflectionProperty(
        ReflectionClass $refObject,
        string $name,
        ReflectionClass $firstRefObject = null,
    ): ReflectionProperty {
        $firstRefObject = $firstRefObject ?? $refObject;
        if ($refObject->hasProperty($name)) {
            return $refObject->getProperty($name);
        }

        $refParent = $refObject->getParentClass();
        if (!$refParent) {
            throw new Exception("property {$name} does not exist in {$firstRefObject->getName()}");
        }

        return static::getReflectionProperty($refParent, $name, $firstRefObject);
    }
}
