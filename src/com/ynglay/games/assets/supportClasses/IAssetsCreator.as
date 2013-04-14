/**
 * Copyright 2013 YNGLAY. All Rights Reserved..
 * Author: Roman Zarichnyi
 * Date: 21.03.13
 * Time: 10:47
 */
package com.ynglay.games.assets.supportClasses {
/*
 * The IAssetsCreator interface defines methods for registering assets loaders, creating game objects
 * and disposing assets need for the screen.
 */
public interface IAssetsCreator
{
    /*
     * Register assets loaders to load assets.
     */
    function registerLoaders():void;

    /*
     * Prepare screen data from loaded assets.
     */
    function prepareScreenData():void;

    /*
     * Dispose loaded assets.
     */
    function disposeAssets():void;

    /*
     * Dispose textures.
     */
    function disposeTextures():void;

    /*
     * Dispose sounds.
     */
    function disposeSounds():void;
}
}
