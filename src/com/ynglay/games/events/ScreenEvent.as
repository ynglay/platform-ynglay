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
    * Defines the game state.
    * */
    public var state:String;

    /*
    * Constructor.
    *
    * @param type The type of event.
    * @param state The game state. Use <code>GameState</code> class with different types of the game state.
    * @param bubbles Indicates whether an event is a bubbling event.
    * @param cancelable Indicates whether the behavior associated with the event can be prevented.
    * */
    public function ScreenEvent(type:String, state:String = "", bubbles:Boolean = false, data:Object = null)
    {
        super(type, bubbles, data);

        this.state = state;
    }
}
}
