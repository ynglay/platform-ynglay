/**
 * Copyright 2013 YNGLAY. All Rights Reserved..
 * Author: Roman Zarichnyi
 * Date: 20.03.13
 * Time: 15:10
 */
package com.ynglay.games.assets.loaders {

import com.ynglay.games.events.AssetsLoadingEvent;

import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.utils.getTimer;

import starling.textures.Texture;

import starling.textures.TextureAtlas;

/*
 * Loader class loads texture (image), xml file describes placing textures and create object from loaded assets.
 */
public class TextureAtlasLoader extends TextureLoader implements IAssetLoader
{
    protected var _xmlPath:String;
    protected var _xmlLoadingPercentage:Number;

    /*
     * Loader to load xml file.
     */
    protected var xmlLoader:URLLoader;

    /*
     * Constructor.
     *
     * @param id Identifier of the texture atlas.
     * @param path Relative path of the texture file.
     * @param xmlPath Relative path of the xml file.
     */
    public function TextureAtlasLoader(id:String, path:String, xmlPath:String)
    {
        super(id, path);

        this._xmlPath = xmlPath;
    }

    /*
     * Relative path to the xml asset.
     */
    public function get xmlPath():String
    {
        return _xmlPath;
    }

    /*
     * Loading percentage of the xml asset. It could be between "0" and "1".
     */
    public function get xmlLoadingPercentage():Number
    {
        return _xmlLoadingPercentage;
    }

    /*
     * @inheritDoc
     */
    override public function load():void
    {
        _xmlLoadingPercentage = 0;

        super.load();
    }

    /*
     * Create object from assets.
     */
    override public function getFromAsset():*
    {
        return getTextureAtlas();
    }

    /*
     * Create <code>TextureAtlas</code> object from the loaded image asset and xml file.
     *
     * @return Texture
     * */
    protected function getTextureAtlas():TextureAtlas
    {
        var texture:Texture = super.getFromAsset() as Texture;
        var xml:XML = new XML(xmlLoader.data);

        return new TextureAtlas(texture, xml);
    }

    /*
     * @inheritDoc
     */
    override public function dispose():void
    {
        super.dispose();

        xmlLoader.close()
        xmlLoader = null;
    }

    /*
     * @inheritDoc
     */
    override protected function removeListeners():void
    {
        super.removeListeners();

        xmlLoader.removeEventListener(Event.COMPLETE, onXmlLoadingCompleteHandler);
        xmlLoader.removeEventListener(ProgressEvent.PROGRESS, onXmlLoadingProgressHandler);
        xmlLoader.removeEventListener(IOErrorEvent.IO_ERROR, onXmlLoadingErrorHandler);
    }

    /*
     * @inheritDoc
     */
    override protected function onImageLoadingProgressHandler(event:ProgressEvent):void
    {
        _loadingPercentage = Math.round((event.bytesLoaded / event.bytesTotal) * 0.5);
        dispatchEvent(new AssetsLoadingEvent(AssetsLoadingEvent.PROGRESS, _loadingPercentage));
    }

    /*
     * @inheritDoc
     */
    override protected function onImageLoadingCompleteHandler(event:Event):void
    {
        _loadingPercentage = 0.5;

        xmlLoader = new URLLoader();
        // add listeners to track status of the loading
        xmlLoader.addEventListener(Event.COMPLETE, onXmlLoadingCompleteHandler);
        xmlLoader.addEventListener(ProgressEvent.PROGRESS, onXmlLoadingProgressHandler);
        xmlLoader.addEventListener(IOErrorEvent.IO_ERROR, onXmlLoadingErrorHandler);
        // start loading
        xmlLoader.load(new URLRequest(xmlPath));
    }

    /*
     * XML loading complete handler.
     */
    protected function onXmlLoadingCompleteHandler(event:Event):void
    {
        removeListeners();
        // get end time
        endTime = getTimer();
        // update status
        _loaded = true;
        _xmlLoadingPercentage = 0.5;
        // dispatch event assets are loaded
        dispatchEvent(new AssetsLoadingEvent(AssetsLoadingEvent.COMPLETE));
        trace("[YNGLAY] Asset loaded: name='" + id + ", path='" + path + "', xmlPath='" + xmlPath +
                "', loadingTime=" + (endTime - startTime).toString() + "ms.");
    }

    /*
     * XML loading progress handler.
     */
    protected function onXmlLoadingProgressHandler(event:ProgressEvent):void
    {
        _xmlLoadingPercentage = Math.round((event.bytesLoaded / event.bytesTotal) * 0.5);
        dispatchEvent(new AssetsLoadingEvent(AssetsLoadingEvent.PROGRESS, loadingPercentage +
                xmlLoadingPercentage));
    }

    /*
     * XML loading error handler.
     */
    protected function onXmlLoadingErrorHandler(event:IOErrorEvent):void
    {
        removeListeners();

        trace("[YNGLAY] Error during loading xml asset: name=" + id + ", path=" + xmlPath);
    }
}
}