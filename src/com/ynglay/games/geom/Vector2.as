/**
 * Created with IntelliJ IDEA.
 * Author: onygn
 * Date: 16.03.13
 * Time: 2:44
 * To change this template use File | Settings | File Templates.
 */
package com.ynglay.games.geom {

import starling.utils.deg2rad;
import starling.utils.rad2deg;

public class Vector2 {
    private var _x:Number;
    private var _y:Number;

    public function Vector2(x:Number, y:Number) {
        this._x = x;
        this._y = y;
    }

    public function get x():Number
    {
        return _x;
    }

    public function set x(value:Number):void
    {
        if (x != value)
            _x = value;
    }

    public function get y():Number
    {
        return _y;
    }

    public function set y(value:Number):void
    {
        if (y != value)
            _y = value;
    }

    public function get length():Number
    {
        return Math.sqrt(x * x + y * y)
    }

    public function get rotation():Number
    {
        var deg:Number = rad2deg(Math.atan2(y, x));
        if (deg < 0)
            deg += 360;

        return deg;
    }

    public function add(vector:Vector2):Vector2
    {
        this.x += vector.x;
        this.y += vector.y;

        return this;
    }

    public function subtract(vector:Vector2):Vector2
    {
        this.x -= vector.x;
        this.y -= vector.y;

        return this;
    }

    public function multiply(scalar:Number):Vector2
    {
        x *= scalar;
        y *= scalar;

        return this;
    }

    public function normalize():Vector2
    {
        var l:Number = length;
        if (l != 0)
        {
            x /= l;
            y /= l;
        }

        return this;
    }

    public function rotate(rotation:Number):Vector2
    {
        var rad:Number = deg2rad(rotation);

        x = x * Math.cos(rad) - y * Math.sin(rad);
        y = x * Math.sin(rad) + y * Math.cos(rad);

        return this;
    }

    public function distance(vector:Vector2):Number
    {
        var distX:Number = x - vector.x;
        var distY:Number = y - vector.y;

        return Math.sqrt(distX * distX + distY * distY);
    }
}
}
