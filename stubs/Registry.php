<?php
/**
 * Copyright    OXID eSales AG. All rights reserved.
 * See LICENSE file for license details.
 */
namespace OxidEsales\EshopCommunity\Core;
use OxidEsales\EshopCommunity\Core\Autoload\BackwardsCompatibilityClassMapProvider;
/**
 * Object registry design pattern implementation. Stores the instances of objects
 */
class Registry {
   /**
     * @template T
     * @param class-string<T> $className The class name from the Unified Namespace.
     * param mixed  ...$args   constructor arguments
     *
     * @static
     *
     * @return object
     * @return T
     */
    public static function get($className)
    {
    }

    /** @template T
     * @param class-string<T> $className A unified namespace class name
     * param mixed  ...$args   constructor arguments
     *
     * @static
     *
     * @return mixed
     * @return T
     */
    protected static function getObject($className)
    {
    }

}
