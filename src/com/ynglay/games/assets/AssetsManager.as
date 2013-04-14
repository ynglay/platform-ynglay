/**
 * Copyright 2013 YNGLAY. All Rights Reserved.
 * Author: Roman Zarichnyi
 * Date: 20.03.13
 * Time: 13:19
 */
package com.ynglay.games.assets {
import com.ynglay.games.assets.loaders.IAssetLoader;
import com.ynglay.games.events.AssetsLoadingEvent;

import flash.events.EventDispatcher;

import flash.utils.Dictionary;
import flash.utils.getTimer;

[Event(type="com.ynglay.games.events.AssetsLoadingEvent", name="complete")]
[Event(type="com.ynglay.games.events.AssetsLoadingEvent", name="progress")]

/*
 * Manager which loads, stores, creates assets. Use classes which implement <code>IAssetLoader</code> classes
 * to load assets.
 */
public class AssetsManager extends EventDispatcher
{
    private var _loading:Boolean;
    private var _loaded:Boolean;

    /**
     * Storage only for one instance of the class.
     */
    private static var instance:AssetsManager;

    /*
     * Start time of the loading.
     */
    protected var startTime:uint;

    /*
     * End time of the loading.
     */
    protected var endTime:uint;

    /*
    * Array with assets to load.
    */
    private var queue:Vector.<IAssetLoader>;

    /*
     * Array with loaded assets.
     */
    private var loadedAssets:Dictionary;

    /*
     * Array with loaded assets.
     */
    private var currentLoader:IAssetLoader;

    /*
    * Count of loading assets.
    */
    private var loadingAssetsCount:int;

    /*
     * Count of loaded assets.
     */
    private var loadedAssetsCount:int;

    /*
    * Constructor.
    */
    public function AssetsManager(singelton:SingletonBlocker)
    {
        if (!singelton)
            throw new Error("Please use 'getInstance()' function to work with this class.");

        queue = new <IAssetLoader>[];
        loadedAssets = new Dictionary();
    }

    /*
     * Define status of loading assets (are they currently loading).
     */
    public function get loading():Boolean
    {
        return _loading;
    }

    /*
     * Define status of loading assets (are they loaded).
     */
    public function get loaded():Boolean
    {
        return _loaded;
    }

    /**
     * Return an instance of the <code>SoundManager</code> class.
     *
     * @return Instance of the class.
     */
    public static function getInstance():AssetsManager
    {
        if (!instance)
            instance = new AssetsManager(new SingletonBlocker());

        return instance;
    }

    /*
     * Add asset to loading queue.
     *
     * @param loader Loader to load the asset.
     */
    public function addToQueue(loader:IAssetLoader):void
    {
        queue.push(loader);
    }

    /*
     * Start loading assets.
     */
    public function load():void
    {
        // get start time
        startTime = getTimer();
        // update status
        _loading = true;
        _loaded = false;
        loadingAssetsCount = queue.length;
        loadedAssetsCount = 0;

        // load next asset
        if (loadingAssetsCount > 0)
            loadNextAsset();
    }

    /*
     * Get the object from the asset.
     *
     * @param id Identifier of the asset.
     * @return Created object from the asset.
     */
    public function getFromAsset(id:String):*
    {
        if (loadedAssets.hasOwnProperty(id))
            return loadedAssets[id].getFromAsset();
        else
            throw new Error("Asset '" + id + "' has not been loaded by the asset manager.");
    }

    /*
     * Remove the asset from the manager.
     *
     * @param id Identifier of the asset.
     */
    public function removeAsset(id:String):void
    {
        if (loadedAssets.hasOwnProperty(id))
        {
            loadedAssets[id].dispose();
            delete loadedAssets[id];
        }
    }

    /*
     * Remove assets the array of asset names.
     *
     * @param assets Array of asset names.
     */
    public function removeAssets(assets:Array):void
    {
        var length:int = assets.length;
        for (var i:int = 0; i < length; i++)
        {
            removeAsset(assets[i]);
        }
    }

    /*
     * Load next asset using loader from the queue.
     */
    private function loadNextAsset():void
    {
        currentLoader = queue.shift();

        if (currentLoader)
        {
            currentLoader.addEventListener(AssetsLoadingEvent.COMPLETE, onAssetLoadingCompleteHandler);
            currentLoader.addEventListener(AssetsLoadingEvent.ERROR, onAssetLoadingErrorHandler);
            currentLoader.load();
        }
    }

    /*
     * Remove assets listeners from the current loader.
     */
    private function removeAssetListeners():void
    {
        if (currentLoader)
        {
           currentLoader.removeEventListener(AssetsLoadingEvent.COMPLETE, onAssetLoadingCompleteHandler);
           currentLoader.removeEventListener(AssetsLoadingEvent.ERROR, onAssetLoadingErrorHandler);
        }
    }

    /*
     * Asset loading complete handler.
     */
    private function onAssetLoadingCompleteHandler(event:AssetsLoadingEvent):void
    {
        removeAssetListeners();

        loadedAssets[currentLoader.id] = currentLoader;
        loadedAssetsCount++;
        loadingAssetsCount--;

        dispatchEvent(new AssetsLoadingEvent(AssetsLoadingEvent.PROGRESS, loadedAssetsCount / loadingAssetsCount));

        // load next asset if are assets to load or stop loading
        if (loadingAssetsCount > 0)
        {
            loadNextAsset();
        }
        else
        {
            endTime = getTimer();
            _loaded = true;
            _loading = false;

            trace("[AssetsManager] Total time of loading set of assets: time=" + (endTime - startTime).toString() + "ms.");
            dispatchEvent(new AssetsLoadingEvent(AssetsLoadingEvent.COMPLETE));
        }
    }

    /*
     * Asset loading error handler.
     */
    private function onAssetLoadingErrorHandler(event:AssetsLoadingEvent):void
    {
        removeAssetListeners();
    }
}
}

internal class SingletonBlocker {}