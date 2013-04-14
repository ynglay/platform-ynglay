/**
 * Copyright 2013 YNGLAY. All Rights Reserved..
 * Author: Roman Zarichnyi
 * Date: 09.04.13
 * Time: 14:31
 */
package com.ynglay.games.components {

import com.ynglay.games.assets.AssetsManager;
import com.ynglay.games.consts.GameState;
import com.ynglay.games.core.screens.ScreenBase;
import com.ynglay.games.events.AssetsLoadingEvent;
import com.ynglay.games.events.ScreenEvent;
import flash.utils.Dictionary;
import starling.display.Sprite;
import starling.events.Event;

/*
* Navigation manager to handles switching between screens, back button (for Android), lost context,
* deactivation and activation the application etc.
* */
public class ScreenNavigator extends Sprite
{
    /*
     * Registered screens.
     * */
    private var screens:Dictionary;

    protected var _currentScreen:ScreenBase;
    protected var _currentScreenId:String;

    /*
    * From which screen switches.
    * */
    protected var fromScreen:ScreenBase;

    /*
    * To which screen need to switch.
    * */
    protected var toScreen:ScreenBase;

    /*
    * Constructor.
    * */
    public function ScreenNavigator()
    {
        super();

        screens = new Dictionary();
        addEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler);
    }

    /*
    * Current screen.
    * */
    public function get currentScreen():ScreenBase
    {
        return _currentScreen;
    }

    /*
    * Current screen identifier.
    * */
    public function get currentScreenId():String
    {
        return _currentScreenId;
    }

    /*
    * Register screen in the screen navigator.
    *
    * @param state Game state. Use <code>GameState</code> class with all game states.
    * @param item Screen navigation item to create registered screen.
    * */
    public function register(state:String, item:ScreenNavigationItem):void
    {
        if (screens.hasOwnProperty(state))
            throw new Error("Screen with state '" + state + "' already exists.");
        else
            screens[state] = item;
    }

    /*
    * Remove screen from the screen navigator.
    *
    * @param state Game state. Use <code>GameState</code> class with all game states.
    * */
    public function remove(state:String):void
    {
        if(!screens.hasOwnProperty(state))
        {
            throw new Error("Screen '" + state + "' can't be removed because it has not been registered.");
        }
        delete screens[state];
    }

    /*
    * Remove all game states.
    * */
    public function removeAll():void
    {
        for(var state:String in screens)
        {
            delete screens[state];
        }
    }

    /*
    * Get registered screen.
    *
    * @param state Game state. Use <code>GameState</code> class with all game states.
    * */
    public function getScreen(state:String):ScreenNavigationItem
    {
        if(screens.hasOwnProperty(state))
            return ScreenNavigationItem(screens[state]);

        return null;
    }

    /*
     * Show registered screen.
     *
     * @param state Game state. Use <code>GameState</code> class with all game states.
     * @return Showed the game screen.
     * */
    public function show(state:String):ScreenBase
    {
        if(!screens.hasOwnProperty(state))
        {
            // throw error screen has not been registered
            throw new Error("Screen '" + state + "' can't be shown because it has not been registered.");
        }
        else if (currentScreenId == state)
        {
            // return game screen when it is current screen
            return currentScreen;
        }

        // remove listener to free this object for garbadge collector
        if (currentScreen)
            currentScreen.removeEventListener(ScreenEvent.CHANGE_SCREEN, onScreenChangeHandler);

        // create screen
        var item:ScreenNavigationItem = ScreenNavigationItem(screens[state]);
        toScreen = item.createScreen();
        toScreen.state = state;
        fromScreen = currentScreen;

        // show loading screen if need to load assets
        if (toScreen.requireLoadingAssets)
        {
            // create loading screen
            item = ScreenNavigationItem(screens[GameState.LOADING]);
            _currentScreen = item.createScreen();
            _currentScreenId = GameState.LOADING;

            // show and initialize loading screen
            addChild(_currentScreen);
            currentScreen.initialize();

            // registers assets needed for the next screen
            toScreen.registerAssets();

            // start loading assets
            AssetsManager.getInstance().addEventListener(AssetsLoadingEvent.COMPLETE, onAssetsLoadingCompleteHandler);
            AssetsManager.getInstance().load();

            // remove prev screen
            removePrevScreen();

            dispatchEvent(new ScreenEvent(ScreenEvent.CHANGED, _currentScreenId));
        }
        else
        {
            // show next screen without assets loading
            showNextScreen();
        }

        return _currentScreen;
    }

    /*
    * Show the next screen after loading assets.
    * */
    private function showNextScreen():void
    {
        // change the screen
        _currentScreen = toScreen;
        _currentScreenId = toScreen.state;
        _currentScreen.addEventListener(ScreenEvent.CHANGE_SCREEN, onScreenChangeHandler);

        // show and initialize the screen
        addChild(_currentScreen);
        _currentScreen.prepareScreenData();
        _currentScreen.initialize();

        // remove the previous screen
        toScreen = null;
        removePrevScreen();

        dispatchEvent(new ScreenEvent(ScreenEvent.CHANGED, _currentScreenId));
    }

    /*
    * Remove the previous screen.
    * */
    private function removePrevScreen():void
    {
        if (fromScreen)
        {
            fromScreen.dispose();
            removeChild(fromScreen);
        }
    }

    /*
    * Assets loading complete handler. Show the next screen.
    * */
    private function onAssetsLoadingCompleteHandler(event:AssetsLoadingEvent):void
    {
        AssetsManager.getInstance().removeEventListener(AssetsLoadingEvent.COMPLETE, onAssetsLoadingCompleteHandler);

        fromScreen = _currentScreen;
        showNextScreen();
    }

    /*
    * Added to stage handler.
    * */
    private function onAddedToStageHandler(event:Event):void
    {
        removeEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler);
        width = stage.stageWidth;
        height = stage.stageHeight;
    }

    /*
    * Screen change handler. Invoke changing screen.
    * */
    private function onScreenChangeHandler(event:ScreenEvent):void
    {
        show(event.state);
    }
}
}
