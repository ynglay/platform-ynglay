/**
 * Copyright 2013 YNGLAY. All Rights Reserved..
 * Author: Roman Zarichnyi
 * Date: 09.04.13
 * Time: 14:49
 */
package com.ynglay.games.components {
import com.ynglay.games.core.screens.ScreenBase;

/*
* Navigation item to store the screen class and create a new screen.
* */
public class ScreenNavigationItem
{
    /*
    * Screen class.
    * */
    public var screenClass:Class;

    /*
    * Define need loading assets before showing this game screen.
    * */
    public var requireLoadingAssets:Boolean;

    /*
    * Constructor.
    *
    * @param screenClass Screen class.
    * @param requireLoadingAssets Define need loading assets before showing this game screen.
    * */
    public function ScreenNavigationItem(screenClass:Class, requireLoadingAssets:Boolean = false)
    {
        this.screenClass = screenClass;
        this.requireLoadingAssets = requireLoadingAssets;
    }

    /*
    * Create a new screen.
    *
    * @return Instance of the created screen.
    * */
    public function createScreen():ScreenBase
    {
        var screenInstance:ScreenBase;
        try
        {
            var screenType:Class = Class(screenClass);
            screenInstance = new screenType(requireLoadingAssets);
        }
        catch (error:Error)
        {
            throw Error("Class \"screen\" should be ScreenBase or his child.");
        }

        return screenInstance;
    }
}
}
