/**
 * Copyright 2013 YNGLAY. All Rights Reserved..
 * Author: Roman Zarichnyi
 * Date: 20.03.13
 * Time: 16:00
 */
package com.ynglay.games.events {
import flash.events.Event;

/*
* The AssetLoaderBase class dispatches AssetsLoadingEvent events when asset is loading.
* */
public class AssetsLoadingEvent extends Event
{
    /*
    * Defines the value of the type property of a AssetsLoadingEvent event object and dispatches when
    * the asset loading is completed.
    * */
    public static const COMPLETE:String = "complete";

    /*
     * Defines the value of the type property of a AssetsLoadingEvent event object and dispatches when
     * when the asset loading is in the progress.
     * */
    public static const PROGRESS:String = "progress";

    /*
     * Defines the value of the type property of a AssetsLoadingEvent event object and dispatches when
     * is error during the asset loading.
     * */
    public static const ERROR:String = "error";

    /*
    * The percentage of the loading asset.
    * */
    public var loadingPercentage:Number;

    /*
    * Constructor.
    *
    * @param type The type of event.
    * @param loadingPercentage The percentage of the loading asset.
    * @param bubbles Indicates whether an event is a bubbling event.
    * @param cancelable Indicates whether the behavior associated with the event can be prevented.
    * */
    public function AssetsLoadingEvent(type:String, loadingPercentage:Number = NaN,
                                       bubbles:Boolean = false, cancelable:Boolean = false)
    {
        super(type, bubbles, cancelable);

        this.loadingPercentage = loadingPercentage;
    }

    /*
    * @inheritDoc
    * */
    override public function clone():Event
    {
        return new AssetsLoadingEvent(type, loadingPercentage, bubbles, cancelable);
    }
}
}
