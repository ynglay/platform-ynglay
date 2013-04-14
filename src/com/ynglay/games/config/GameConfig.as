/**
 * Copyright 2013 YNGLAY. All Rights Reserved..
 * Author: Roman Zarichnyi
 * Date: 16.03.13
 * Time: 21:42
 */
package com.ynglay.games.config {

/*
* Configuration of the game.
*/
public class GameConfig
{
    /**
     * Storage only for one instance of the class.
     */
    private static var instance:GameConfig;

    /**
     * Constructor. Please use static <code>getInstance()</code> function
     * to get an instance of this class.
     *
     * @param singelton Internal class to block creation of this class by using constructor.
     */
    public function GameConfig(singelton:SingletonBlocker)
    {
        if (!singelton)
            throw Error("Please use 'getInstance()' function to work with this class.")
    }

    /**
     * Return an instance of the <code>GameConfig</code> class.
     *
     * @return Instance of the class.
     */
    public static function getInstance():GameConfig
    {                    1
        if (!instance)
            instance = new GameConfig(new SingletonBlocker());

        return instance;
    }

    /*
     * Initial (original) width of the game.
     */
    public var targetWidth:int = 1024;

    /*
     * Initial (original) height of the game.
     */
    public var targetHeight:int = 768;

    /*
     * Scale factor of the game.
     */
    public var contentScaleFactor:Number = 1;

    /*
     * Defines whether the sound is on.
     */
    public var soundOn:Boolean = true;

    /*
     * Defines whether the music is on.
     */
    public var musicOn:Boolean = true;
}
}

internal class SingletonBlocker {}