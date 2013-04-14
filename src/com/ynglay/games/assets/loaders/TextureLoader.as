/**
 * Copyright 2013 YNGLAY. All Rights Reserved..
 * Author: Roman Zarichnyi
 * Date: 20.03.13
 * Time: 15:08
 */
package com.ynglay.games.assets.loaders
{
import com.ynglay.games.events.AssetsLoadingEvent;

import flash.display.Bitmap;
import flash.display.Loader;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.net.URLRequest;
import flash.system.ImageDecodingPolicy;
import flash.system.LoaderContext;
import flash.utils.getTimer;

import starling.textures.Texture;

/*
 * Loader class loads texture (image) and create object from the loaded asset.
 */
public class TextureLoader extends AssetLoaderBase implements IAssetLoader
{
    /*
     * Loader to load texture.
     */
    protected var loader:Loader;

    /*
     * Constructor.
     *
     * @param id Identifier of the texture file.
     * @param path Relative path of the texture file.
     */
    public function TextureLoader(id:String, path:String)
    {
        super(id, path);
    }

    /*
     * Start loading texture file by the path.
     */
    override public function load():void
    {
        super.load();

        loader = new Loader();

        // Create loader context and set image decoding policy to "ImageDecodingPolicy.ON_LOAD" to decode image data
        // asynchronously during creating image textures.
        var context:LoaderContext = new LoaderContext();
        context.imageDecodingPolicy = ImageDecodingPolicy.ON_LOAD;
        // add listeners to track status of the loading
        loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageLoadingCompleteHandler);
        loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onImageLoadingProgressHandler);
        loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onImageLoadingErrorHandler);
        // start loading
        loader.load(new URLRequest(path), context);
    }

    /*
     * Create <code>Texture</code> object from the loaded asset.
     *
     * @return Texture
     */
    override public function getFromAsset():*
    {
        return Texture.fromBitmap(loader.content as Bitmap);
    }

    /*
     * @inheritDoc
     */
    override public function dispose():void
    {
        loader.unload();
        loader = null;
    }

    /*
     * Remove event listeners from the loader.
     */
    protected function removeListeners():void
    {
        loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onImageLoadingCompleteHandler);
        loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onImageLoadingProgressHandler);
        loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onImageLoadingErrorHandler);
    }

    /*
     * Image loading complete handler.
     */
    protected function onImageLoadingCompleteHandler(event:Event):void
    {
        removeListeners();
        // get end time
        endTime = getTimer();
        // update status
        _loaded = true;
        _loadingPercentage = 1;

        // dispatch event texture file is loaded
        dispatchEvent(new AssetsLoadingEvent(AssetsLoadingEvent.COMPLETE));
        trace("[TextureLoader] Loaded texture asset: name='" + id + ", path='" + path + "', loadingTime=" + (endTime - startTime).toString() + "ms.");
    }

    /*
     * Image loading progress handler.
     */
    protected function onImageLoadingProgressHandler(event:ProgressEvent):void
    {
        // calculate loading percentage
        _loadingPercentage = Math.round(event.bytesLoaded / event.bytesTotal);

        dispatchEvent(new AssetsLoadingEvent(AssetsLoadingEvent.PROGRESS, loadingPercentage));
    }

    /*
     * Loading error handler.
     */
    protected function onImageLoadingErrorHandler(event:IOErrorEvent):void
    {
        removeListeners();
        trace("[TextureLoader] Error during loading texture asset: id='" + id + ", path='" + path + ".");
    }
}
}
