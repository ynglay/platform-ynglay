/**
 * Created y YNGLAY.
 * Author: Roman Zarichnyi
 * Date: 16.03.13
 * Time: 2:19
 */
package com.ynglay.games.pool {
/*
* The Pool class that prevent removing object which are in the pool by garbage collector.
* */
public class Pool
{
    /*
    * Free objects in the pool.
    * */
    private var freeObjects:Vector.<IPoolObject>;

    /*
    * Factory to create pool object.
    * */
    private var factory:IPoolObjectFactory;

    /*
    * Max length of free objects in the pool.
    * */
    private var maxLength:int;

    /*
    * Constructor.
    *
    * @param factory The pool object factory to create objects.
    * @param maxLength The max length of free objects in the pool.
    * */
    public function Pool(factory:IPoolObjectFactory, maxLength:int)
    {
        this.factory = factory;
        this.maxLength = maxLength;
        this.freeObjects = new <IPoolObject>[];
    }

    /*
    * Length of the free objects in the pool.
    * */
    public function get length():int
    {
        return freeObjects.length;
    }

    /*
    * Get the free object from the pool.
    * */
    public function getFreeObject():IPoolObject
    {
        if (freeObjects.length == 0)
            return factory.create();
        else
            return freeObjects.pop();
    }

    /*
     * Release the object and add to pool.
     * */
    public function release(object:IPoolObject):void
    {
        if (freeObjects.length < maxLength)
        {
            freeObjects.push(object);
            object.release();
        }
    }

    /*
    * Clear pool of free objects.
    * */
    public function clearPool():void
    {
        freeObjects.splice(0, freeObjects.length);
    }
}
}
