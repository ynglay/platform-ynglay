/**
 * Copyright 2013 YNGLAY. All Rights Reserved..
 * Author: Roman Zarichnyi
 * Date: 16.03.13
 * Time: 22:05
 */
package com.ynglay.games.core.screens {
import com.ynglay.games.assets.supportClasses.IAssetsCreator;
/*
* The IScreen interface defines methods for working with the game screen.
* */
public interface IScreen
{
    /*
    * Update the game screen function which calls each frame.
    * */
    function update(deltaTime:Number):void;

    /*
     * Initialize function for the game screen.
     * */
    function initialize():void;

    /*
     * Pause function for the game screen.
     * */
    function pause():void;

    /*
     * Resume function for the game screen.
     * */
    function resume():void;

    /*
     * Dispose function for the game screen.
     * */
    function dispose():void;

    /*
     * Register assets to the loading needed for the game screen.
     * */
    function registerAssets():void;

    /*
     * Prepare screen data (fonts, sounds, textures etc.) for the game screen.
     * */
    function prepareScreenData():void;

    /*
     * Instance of the assets creator working with assets.
     * */
    function get assetsCreator():IAssetsCreator;
    function set assetsCreator(value:IAssetsCreator):void;
}
}
