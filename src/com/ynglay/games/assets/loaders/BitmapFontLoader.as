/**
 * Created by YNGLAY.
 * Author: Roman Zarichnyi
 * Date: 22.04.13
 * Time: 11:11
 */
package com.ynglay.games.assets.loaders {
import starling.text.BitmapFont;
import starling.textures.Texture;

/*
* Loader class loads bitmap font (image), xml file describes font chars and create object from loaded assets.
* */
public class BitmapFontLoader extends TextureAtlasLoader
{
    /*
    * Font name.
    * */
    public var fontName:String;

    /*
    * Constructor.
    *
    * @param id Identifier of the texture atlas.
    * @param path Relative path of the texture file.
    * @param xmlPath Relative path of the xml file.
    * @param fontName Name of the font.
    * */
    public function BitmapFontLoader(id:String, path:String, xmlPath:String, fontName:String)
    {
        super(id, path, xmlPath);

        this.fontName = fontName;
    }

    /*
     * Create object from asset.
     */
    override public function getFromAsset():*
    {
        return getBitmapFont();
    }

    /*
     * Create <code>BitmapFont</code> object from the loaded image asset and xml file.
     *
     * @return BitmapFont
     * */
    protected function getBitmapFont():BitmapFont
    {
        var texture:Texture = getTexture();
        var xml:XML = new XML(xmlLoader.data);

        return new BitmapFont(texture, xml);
    }
}
}
