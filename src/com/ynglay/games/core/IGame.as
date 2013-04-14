/**
 * Copyright 2013 YNGLAY. All Rights Reserved..
 * Author: Roman Zarichnyi
 * Date: 16.03.13
 * Time: 22:00
 */
package com.ynglay.games.core {
import com.ynglay.games.core.screens.IScreen;

/*
 * The IGame interface defines methods for working with the game application.
 * */
public interface IGame
{
    /*
     * Initialize the game application.
     * */
    function initialize():void;

    /*
     * Dispose the game application.
     * */
    function dispose():void;
}
}
