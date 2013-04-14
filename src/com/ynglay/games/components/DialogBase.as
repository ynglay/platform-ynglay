/**
 * Copyright 2013 YNGLAY. All Rights Reserved..
 * Author: Roman Zarichnyi
 * Date: 08.04.13
 * Time: 15:24
 */
package com.ynglay.games.components {
import starling.display.Quad;
import starling.display.Sprite;
import starling.events.Event;

/*
* Dialog base class with colored background.
* */
public class DialogBase extends Sprite
{
    private var _backgroundAlpha:Number;
    private var _backgroundColor:uint;

    /*
    * Colored background around the dialog content.
    * */
    private var background:Quad;

    /*
    * Constructor.
    *
    * @param backgroundAlpha Alpha value of the background.
    * @param backgroundColor Color of the background.
    * */
    public function DialogBase(backgroundAlpha:Number = 0.5, backgroundColor:uint = 0xcccccc)
    {
        super();

        this.backgroundAlpha = backgroundAlpha;
        this.backgroundColor = backgroundColor;

        addEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler);
    }

    /*
    * Alpha value of the background.
    * */
    public function get backgroundAlpha():Number
    {
        return _backgroundAlpha;
    }

    /*
    * @private
    * */
    public function set backgroundAlpha(value:Number):void
    {
        if (_backgroundAlpha != value)
        {
            _backgroundAlpha = value;
            if (background)
                background.alpha = backgroundAlpha;
        }
    }

    /*
    * Color of the background.
    * */
    public function get backgroundColor():uint
    {
        return _backgroundColor;
    }

    /*
     * @private
     * */
    public function set backgroundColor(value:uint):void
    {
        if (_backgroundColor != value)
        {
            _backgroundColor = value;
            if (background)
                background.color = backgroundColor;
        }
    }

    /*
    * Initialize dialog.
    * */
    protected function initialize():void
    {
        background = new Quad(stage.stageWidth, stage.stageHeight, backgroundColor);
        background.alpha = backgroundAlpha;
        addChild(background);
    }

    /*
    * Dispose dialog.
    * */
    override public function dispose():void
    {
        background.dispose();
        removeChild(background);

        super.dispose();
    }

    /*
    * Added to stage handler. Initialize dialog.
    * */
    private function onAddedToStageHandler(event:Event):void
    {
        removeEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler);
        initialize();
    }
}
}
