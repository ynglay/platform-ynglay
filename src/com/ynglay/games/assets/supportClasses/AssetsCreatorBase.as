/**
 * Copyright 2013 YNGLAY. All Rights Reserved..
 * Author: Roman Zarichnyi
 * Date: 21.03.13
 * Time: 10:45
 */
package com.ynglay.games.assets.supportClasses {
import com.ynglay.games.assets.AssetsManager;

/*
* Base assets creator class to manage assets for the game screen.
*/
public class AssetsCreatorBase implements IAssetsCreator
{
    /*
    * Instance of the assets manager.
    */
    protected var assetsManager:AssetsManager;

    /*
    * Constructor.
    *
    * @param assetsManager Manager which manages loaded assets.
    */
    public function AssetsCreatorBase(assetsManager:AssetsManager)
    {
        if (!assetsManager)
            throw new Error("Property 'assetsManager' should be not null.");

        this.assetsManager = assetsManager;
    }

    /*
     * Register asset loaders for the game screen.
     */
    public function registerLoaders():void
    {

    }

    /*
     * Prepare the game screen data.
     */
    public function prepareScreenData():void
    {

    }

    /*
     * Dispose the game screen assets.
     */
    public function disposeAssets():void
    {

    }

    /*
     * Dispose the game screen textures.
     */
    public function disposeTextures():void
    {

    }

    /*
     * Dispose the game screen sounds.
     */
    public function disposeSounds():void
    {

    }
}
}
