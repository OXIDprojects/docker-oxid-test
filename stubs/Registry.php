<?php
namespace OxidEsales\EshopCommunity\Core;
use OxidEsales\EshopCommunity\Core\Autoload\BackwardsCompatibilityClassMapProvider;
class Registry {
   /**
    * @template T
    * @param class-string<T> $className The class name from the Unified Namespace.
    *
    * @static
    *
    * @return T|null
    **/
    public static function get($className)
    {
    }

   /**
     * @template T
     * @param class-string<T> $className The class name from the Unified Namespace.
     * @param T|null $value
     *
     * @static
     *
     * @return void
    **/
    public static function set($className, $value)
    {
    }

    /** 
     * @template T
     * @param class-string<T> $className A unified namespace class name
     *
     * @static
     *
     * @return T
     **/
    protected static function getObject($className)
    {
    }

}
