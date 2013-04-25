/**
 * Created by YNGLAY.
 * Author: Roman Zarichnyi
 * Date: 24.04.13
 * Time: 17:24
 */
package com.ynglay.games.utils {
import flash.geom.Point;
import flash.geom.Rectangle;

import starling.display.DisplayObject;

public class GeometryUtil
{
    public static function detectCollisionBySphere(a:DisplayObject, b:DisplayObject):Boolean
    {
        var aPos:Point = new Point(a.x, a.y);
        var bPos:Point = new Point(b.x, b.y);
        var distance:Number = Point.distance(aPos, bPos);
        var aRadius:Number = Math.max(a.width, a.height) / 2;
        var bRadius:Number = Math.max(b.width, b.height) / 2;

        return distance < aRadius + bRadius;
    }

    public static function detectCollisionByBoundingBox(a:DisplayObject, b:DisplayObject):Boolean
    {
        return a.bounds.intersects(b.bounds);
    }
}
}
