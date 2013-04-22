/**
 * Created with YNGLAY.
 * Author: Roman Zarichnyi
 * Date: 25.03.13
 * Time: 10:05
 */
package com.ynglay.games.events {
import starling.events.Event;

/*
 * The ScreenBase class dispatches ScreenEvent events when need to change the screen.
 * */
public class ScreenEvent extends Event
{
    /*
     * Defines the value of the type property of a AssetsLoadingEvent event object and dispatches when
     * need to change the screen.
     * */
    public static const CHANGE_SCREEN:String = "changeScreen";

    /*
    * Defines the value of the type property of a AssetsLoadingEvent event object and dispatches when
    * the screen changed.
    * */
    public static const CHANGED:String = "changed";

    /*
    * Defines the new game state.
    * */
    public var newState:String;

    /*
     * Defines the old game state.
     * */
    public var oldState:String;

    /*
    * Constructor.
    *
    * @param type The type of event.
    * @param newState The new game state. Use <code>GameState</code> class with different types of the game state.
    * @param oldState The old game state. Use <code>GameState</code> class with different types of the game state.
    * @param bubbles Indicates whether an event is a bubbling event.
    * @param data Additional data.
    * */
    public function ScreenEvent(type:String, newState:String = "", oldState:String = "", bubbles:Boolean = false, data:Object = null)
    {
        super(type, bubbles, data);

        this.newState = newState;
        this.oldState = oldState;
    }
}
}
