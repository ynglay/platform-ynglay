/**
 * Copyright 2013 YNGLAY. All Rights Reserved..
 * Author: Roman Zarichnyi
 * Date: 16.03.13
 * Time: 21:50
 */
package com.ynglay.games.core
{
import com.ynglay.games.components.ScreenNavigator;
import flash.utils.getTimer;
import starling.display.Sprite;
import starling.events.Event;

/*
* The game base application class which has initial functionality for the game application.
* */
public class GameBase extends Sprite implements IGame
{
    private var _state:int;
    private var _screenNavigator:ScreenNavigator;

    /*
    * Time of the previous updating the frame.
    * */
    private var previousTime:uint = 0;

    /*
     * Time of the current updating the frame.
     * */
    private var currentTime:uint = 0;

    /*
    * Constructor.
    * */
    public function GameBase()
    {
        super();

        addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
    }

    /*
    * Current game state.
    * */
    public function get state():int
    {
        return _state;
    }

    /*
    * Navigation manager to navigate between game screens.
    * */
    public function get screenNavigator():ScreenNavigator
    {
        return _screenNavigator;
    }

    /*
    * @private
    * */
    public function set screenNavigator(value:ScreenNavigator):void
    {
        if (value != _screenNavigator)
            _screenNavigator = value;
    }

    /*
    * Initialize the game application.
    * */
    public function initialize():void
    {
        currentTime = getTimer();

        screenNavigator = new ScreenNavigator();
        addChild(screenNavigator);

        addEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
    }

    /*
    * Dispose the game application.
    * */
    override public function dispose():void
    {
        super.dispose();

        screenNavigator.dispose();
        removeChild(screenNavigator);

        removeEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
    }

    /*
     * Update the game application.
     * */
    protected function update():void
    {
        previousTime = currentTime;
        currentTime = getTimer();
        // call updating current game screen in the application
        if (screenNavigator.currentScreen)
            screenNavigator.currentScreen.update((currentTime - previousTime) * 0.001);
    }

    /*
    * Added to stage handler. Call initialize function.
    * */
    private function onAddedToStage(event:Event):void
    {
        removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        initialize();
    }

    /*
    * Enter frame handler. Call update function to update the game application.
    * */
    private function onEnterFrameHandler(event:Event):void
    {
        update();
    }
}
}
