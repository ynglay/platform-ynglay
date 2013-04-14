/**
 * Copyright 2013 YNGLAY. All Rights Reserved..
 * Author: Roman Zarichnyi
 * Date: 01.04.13
 * Time: 15:22
 */
package com.ynglay.games.assets.loaders {
import com.ynglay.games.events.AssetsLoadingEvent;
import com.ynglay.games.audio.SoundEffect;

import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.media.Sound;
import flash.net.URLRequest;
import flash.utils.getTimer;

/*
* Loader class loads sound file (*.mp3 and *.ogg) and create object from the loaded asset.
*/
public class SoundLoader extends AssetLoaderBase implements IAssetLoader
{
    protected var _type:int;

    /*
    * Loader to load sound.
    */
    protected var loader:Sound;

    /*
    * Constructor.
    *
    * @param id Identifier of the sound file.
    * @param path Relative path of the sound file.
    * @param type Type of the loading sound file. Use <code>SoundEffectClass.SOUND</code> or
    * <code>SoundEffectClass.MUSIC</code> types.
    */
    public function SoundLoader(id:String, path:String, type:int)
    {
        super(id, path);

        this._type = type;
    }

    /*
     * Type of the loading sound file.
     */
    public function get type():int
    {
        return _type;
    }

    /*
    * Start loading sound file by the path.
    */
    override public function load():void
    {
        super.load();

        loader = new Sound();
        // add listeners to track status of the loading
        loader.addEventListener(Event.COMPLETE, onLoadingCompleteHandler);
        loader.addEventListener(ProgressEvent.PROGRESS, onLoadingProgressHandler);
        loader.addEventListener(IOErrorEvent.IO_ERROR, onLoadingErrorHandler);

        // start loading
        loader.load(new URLRequest(path));
    }

    /*
     * Create <code>SoundEffect</code> object from the loaded asset.
     *
     * @return SoundEffect
     */
    override public function getFromAsset():*
    {
        return new SoundEffect(loader, type);
    }

    /*
     * @inheritDoc
     */
    override public function dispose():void
    {
        loader = null;
    }

    /*
     * Remove event listeners from the loader.
     */
    protected function removeListeners():void
    {
        loader.removeEventListener(Event.COMPLETE, onLoadingCompleteHandler);
        loader.removeEventListener(ProgressEvent.PROGRESS, onLoadingProgressHandler);
        loader.removeEventListener(IOErrorEvent.IO_ERROR, onLoadingErrorHandler);
    }

    /*
    * Loading complete handler.
    */
    protected function onLoadingCompleteHandler(event:Event):void
    {
        removeListeners();

        // get end time
        endTime = getTimer();
        // update status
        _loaded = true;
        _loadingPercentage = 1;

        // dispatch event sound file is loaded
        dispatchEvent(new AssetsLoadingEvent(AssetsLoadingEvent.COMPLETE));

        trace("[SoundLoader] Loaded sound asset: name='" + id + ", path='" + path + "', loadingTime=" +
                (endTime - startTime).toString() + "ms.");
    }

    /*
     * Loading progress handler.
     */
    protected function onLoadingProgressHandler(event:ProgressEvent):void
    {
        // calculate loading percentage
        _loadingPercentage = Math.round(event.bytesLoaded / event.bytesTotal);

        dispatchEvent(new AssetsLoadingEvent(AssetsLoadingEvent.PROGRESS, loadingPercentage));
    }

    /*
     * Loading error handler.
     */
    protected function onLoadingErrorHandler(event:IOErrorEvent):void
    {
        trace("[SoundLoader] Error during loading sound asset: name='" + id + ", path='" + path + "'.");
        removeListeners();
    }
}
}
