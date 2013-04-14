/**
 * Copyright 2013 YNGLAY. All Rights Reserved..
 * Author: Roman Zarichnyi
 * Date: 16.03.13
 * Time: 22:07
 */
package com.ynglay.games.core.screens {
import com.ynglay.games.assets.supportClasses.IAssetsCreator;

import starling.display.Sprite;

public class ScreenBase extends Sprite implements IScreen
{
    private var _assetsCreator:IAssetsCreator;
    private var _requireLoadingAssets:Boolean;

    /*
    * Define is screen initialized.
    * */
    public var initialized:Boolean;

    /*
    * Define is the game screen pausing or playing.
    * */
    public var isPause:Boolean;

    /*
    * Game state for which is created this screen.
    * */
    public var state:String;

    /*
     * Constructor.
     *
     * @param requireLoadingAssets Define need loading assets before showing this game screen.
     * */
    public function ScreenBase(requireLoadingAssets:Boolean = false)
    {
        super();

        this.requireLoadingAssets = requireLoadingAssets;
    }

    /*
     * Instance of the assets creator working with assets.
     * */
    public function get assetsCreator():IAssetsCreator
    {
        return _assetsCreator;
    }

    /*
    * @private
    * */
    public function set assetsCreator(value:IAssetsCreator):void
    {
        if (_assetsCreator != value)
            _assetsCreator = value;
    }

    /*
    * Define need loading assets before showing this game screen.
    * */
    public function get requireLoadingAssets():Boolean
    {
        return _requireLoadingAssets;
    }

    /*
     * @private
     * */
    public function set requireLoadingAssets(value:Boolean):void
    {
        _requireLoadingAssets = value;
    }

    /*
     * Register assets to the loading needed for the game screen.
     * */
    public function registerAssets():void
    {
        if (assetsCreator)
            assetsCreator.registerLoaders();
    }

    /*
     * Prepare screen data (fonts, sounds, textures etc.) for the game screen.
     * */
    public function prepareScreenData():void
    {
        if (assetsCreator)
            assetsCreator.prepareScreenData();
    }

    /*
    * Function to initialize the game screen.
    * */
    public function initialize():void
    {
        initialized = true;
        isPause = false;
    }

    /*
     * Update the game screen each frame.
     *
     * @param deltaTime The delta time between two frames.
     * */
    public function update(deltaTime:Number):void
    {
        // to override
    }

    /*
    * Pause the game screen, save screen state, show dialogs etc.
    * */
    public function pause():void
    {
        isPause = true;
    }

    /*
     * Resume the game screen to be playing.
     * */
    public function resume():void
    {
        isPause = false;
    }

    /*
     * Dispose the game screen data from the GPU and RAM.
     * */
    override public function dispose():void
    {
        super.dispose();

        initialized = false;
        isPause = false;

        // dispose different types of the screen data
        if (assetsCreator)
        {
            assetsCreator.disposeTextures();
            assetsCreator.disposeSounds();
        }
    }
}
}
