/**
 * Copyright 2013 YNGLAY. All Rights Reserved..
 * Author: Roman Zarichnyi
 * Date: 19.03.13
 * Time: 10:35
 */
package com.ynglay.games.textures {
import flash.utils.Dictionary;

import starling.textures.Texture;
import starling.textures.TextureAtlas;

/*
* Manager which works with textures, texture atlases and animations.
* */
public class TextureManager
{
    /**
     * Storage only for one instance of the class.
     */
    private static var instance:TextureManager;

    /*
    * Created textures.
    * */
    private var textures:Dictionary;

    /*
    * Created texture atlases.
    * */
    private var textureAtlases:Dictionary;

    /**
     * Constructor. Please use static <code>getInstance()</code> function
     * to get an instance of this class.
     *
     * @param singelton Internal class to block creation of this class by using constructor.
     */
    public function TextureManager(singelton:SingletonBlocker)
    {
        if (!singelton)
            throw new Error("Please use 'getInstance()' function to work with this class.")

        textures = new Dictionary();
        textureAtlases = new Dictionary();
    }

    /**
     * Return an instance of the <code>TextureManager</code> class.
     *
     * @return Instance of the class.
     */
    public static function getInstance():TextureManager
    {
        if (!instance)
            instance = new TextureManager(new SingletonBlocker());

        return instance;
    }

    /*
    * Add the texture to the manager.
    *
    * @param id Identifier of the texture.
    * @param texture Instance of the texture.
    * */
    public function addTexture(id:String, texture:Texture):void
    {
        if (textures.hasOwnProperty(id))
            return;

        textures[id] = texture;
    }

    /*
     * Remove the texture from the manager.
     *
     * @param id Identifier of the texture.
     * */
    public function removeTexture(id:String):void
    {
        if (textures.hasOwnProperty(id))
        {
            textures[id].dispose();
            delete textures[id];
        }
    }

    /*
     * Get the texture.
     *
     * @param id Identifier of the texture.
     * */
    public function getTexture(id:String):Texture
    {
        return textures[id];
    }

    /*
     * Add the texture atlas to the manager.
     *
     * @param id Identifier of the texture.
     * @param textureAtlas Instance of the texture atlas.
     * */
    public function addTextureAtlas(id:String, textureAtlas:TextureAtlas):void
    {
        if (textureAtlases.hasOwnProperty(id))
            return;

        textureAtlases[id] = textureAtlas;
    }

    /*
     * Remove the texture atlas from the manager.
     *
     * @param id Identifier of the texture atlas.
     * */
    public function removeTextureAtlas(id:String):void
    {
        if (textureAtlases.hasOwnProperty(id))
        {
            textureAtlases[id].dispose();
            delete textureAtlases[id];
        }
        else
        {
            throw new Error("Texture atlas '" + id + "' can't be removed because it has not been added in the texture manager.");
        }
    }

    /*
     * Get the texture atlas.
     *
     * @param id Identifier of the texture atlas.
     * */
    public function getTextureAtlas(id:String):TextureAtlas
    {
        return textureAtlases[id];
    }

    /*
     * Remove textures and texture atlases from the manager.
     *
     * @param textureNames Array of texture identifiers.
     * */
    public function removeTextures(textureNames:Array):void
    {
        var length:int = textureNames.length;
        var id:String;
        for (var i:int = 0; i < length; i++)
        {
            id = textureNames[i];
            if (textures.hasOwnProperty(id))
                removeTexture(id);
            else if (textureAtlases.hasOwnProperty(id))
                removeTextureAtlas(id);
            else
                trace("[TextureManager] Texture with '" + id + "' isn't created and added to texture manager.");
        }
    }
}
}

internal class SingletonBlocker {}