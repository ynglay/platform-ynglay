/**
 * Copyright 2013 YNGLAY. All Rights Reserved..
 * Author: Roman Zarichnyi
 * Date: 05.04.13
 * Time: 17:44
 */
package com.ynglay.games.assets.loaders {
import flash.events.EventDispatcher;
import flash.utils.getTimer;

[Event(type="com.ynglay.games.events.AssetsLoadingEvent", name="complete")]
[Event(type="com.ynglay.games.events.AssetsLoadingEvent", name="progress")]
[Event(type="com.ynglay.games.events.AssetsLoadingEvent", name="error")]

/*
 * Base loader asset class.
 */
public class AssetLoaderBase extends EventDispatcher implements IAssetLoader
{
    protected var _id:String;
    protected var _path:String;
    protected var _loaded:Boolean;
    protected var _loadingPercentage:Number;

    /*
     * Start time of the loading.
     */
    protected var startTime:uint;

    /*
     * End time of the loading.
     */
    protected var endTime:uint;

    /*
     * Constructor.
     *
     * @param id Identifier of the asset.
     * @param path Relative path of the asset.
     */
    public function AssetLoaderBase(id:String, path:String)
    {
        super();

        this._id = id;
        this._path = path;
    }

    /*
     * Identifier of the asset.
     */
    public function get id():String
    {
        return _id;
    }

    /*
     * Relative path to the asset.
     */
    public function get path():String
    {
        return _path;
    }

    /*
     * Define of loading status.
     */
    public function get loaded():Boolean
    {
        return _loaded;
    }

    /*
     * Loading percentage of the asset. It could be between "0" and "1".
     */
    public function get loadingPercentage():Number
    {
        return _loadingPercentage;
    }

    /*
     * Load asset by the path.
     */
    public function load():void
    {
        // get start time
        startTime = getTimer();
        // reset values
        _loaded = false;
        _loadingPercentage = 0;
    }

    /*
     * @inheritDoc
     */
    public function getFromAsset():*
    {
        // TO OVERRIDE
    }

    /*
     * @inheritDoc
     */
    public function dispose():void
    {
        // TO OVERRIDE
    }
}
}
