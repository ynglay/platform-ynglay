/**
 * Copyright 2013 YNGLAY. All Rights Reserved..
 * Author: Roman Zarichnyi
 * Date: 20.03.13
 * Time: 14:51
 */
package com.ynglay.games.assets.loaders {
import flash.events.IEventDispatcher;

/*
* The IAssetLoader interface defines methods for working with asset loader.
*/
public interface IAssetLoader extends IEventDispatcher
{
    /*
    * Load the asset using the path.
    */
    function load():void;

    /*
     * Create the object from the loaded asset.
     */
    function getFromAsset():*;

    /*
     * Dispose the loaded data.
     */
    function dispose():void;

    /*
     * Asset id.
     */
    function get id():String;

    /*
     * Asset path.
     */
    function get path():String;

    /*
     * Define of loading status.
     */
    function get loaded():Boolean;

    /*
     * Loading percentage of the sound file.
     */
    function get loadingPercentage():Number;
}
}
