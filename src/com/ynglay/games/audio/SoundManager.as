/**
 * Copyright 2013 YNGLAY. All Rights Reserved..
 * Author: Roman Zarichnyi
 * Date: 01.04.13
 * Time: 15:45
 */
package com.ynglay.games.audio {

import com.ynglay.games.config.GameConfig;
import com.ynglay.games.consts.SoundEffectType;

import flash.utils.Dictionary;

import starling.core.Starling;

/**
 * Manager which helps to work with sounds. Add sounds to manager, play and stop them, change volume and fade
 * effect or cross-fade between two sounds.
 */
public class SoundManager
{
    private var _soundsLength:int;
    private var _playingSoundsLength:int;

    /**
     * Storage only for one instance of the class.
     */
    private static var instance:SoundManager;

    /**
     * Hashed array which contains all the sounds registered with the sound manager.
     */
    private var sounds:Dictionary;

    /**
     * Hashed array which contains all the sounds of the sound manager that are currently playing.
     */
    private var playingSounds:Dictionary;

    /**
     * Constructor. Please use static <code>getInstance()</code> function
     * to get an instance of this class.
     *
     * @param singelton Internal class to block creation of this class by using constructor.
     */
    public function SoundManager(singelton:SingletonBlocker)
    {
        if (!singelton)
            throw new Error("Please use 'getInstance()' function to work with this class.");

        sounds = new Dictionary();
        playingSounds = new Dictionary();
        _soundsLength = 0;
        _playingSoundsLength = 0;
    }

    /*
    * Length of sounds stored in the sound manager.
    * */
    public function get soundsLength():int
    {
        return _soundsLength;
    }

    /*
    * Length of the playing sounds.
    * */
    public function get playingSoundsLength():int
    {
        return _playingSoundsLength;
    }

    /**
     * Return an instance of the <code>SoundManager</code> class.
     *
     * @return Instance of the class.
     */
    public static function getInstance():SoundManager
    {
        if (!instance)
            instance = new SoundManager(new SingletonBlocker());

        return instance;
    }

    /**
     * Return sound effect from sounds by id.
     *
     * @param id Identifier of the sound effect.
     * @return Instance of the playing sound effect.
     */
    public function getSoundEffect(id:String):SoundEffect
    {
         return sounds[id] as SoundEffect;
    }

    /**
     * Add sound in the sound manager.
     *
     * @param id Identifier of the sound.
     * @param sound Instance of the sound to add in the sound manager.
     */
    public function add(id:String, sound:SoundEffect):void
    {
        if (!sounds.hasOwnProperty(id))
        {
            sound.id = id;
            sounds[id] = sound;
            _soundsLength++;
        }
    }

    /**
     * Remove sound from the sound manager.
     *
     * @param id Identifier of the sound to remove frome the sound manager.
     */
    public function remove(id:String):void
    {
        if (sounds.hasOwnProperty(id))
        {
            delete sounds[id];
            _soundsLength--;

            if (playingSounds.hasOwnProperty(id))
            {
                delete playingSounds[id];
                _playingSoundsLength--;
            }
        }
    }

    /**
     * Remove all playing and stored sounds from the sound manager.
     */
    public function removeAll():void
    {
        for (var id:String in playingSounds)
        {
            remove(id);
        }
    }

    /**
     * Check the sound effect is playing now.
     *
     * @param id Identifier of the sound.
     * @return Boolean value.
     */
    public function isPlaying(id:String):Boolean
    {
        return playingSounds.hasOwnProperty(id);
    }

    /**
     * Check is sounds or music on.
     *
     * @param type Type od sound effect. Use <code>SoundEffectType.SOUND</code> or
     * <code>SoundEffectType.MUSIC</code> types.
     * @return Boolean value.
     */
    public function isAudioOn(type:int):Boolean
    {
        if (type == SoundEffectType.SOUND)
            return GameConfig.getInstance().soundOn;
        else if (type == SoundEffectType.MUSIC)
            return GameConfig.getInstance().musicOn;
        else
            return false;
    }

    /**
     * Create the sound effect and start playing it.
     *
     * @param id Identifier of the sound to play.
     * @param loops Loops to play the sound repeatedly.
     * @param volume Volume which will played the sound. Value can be from "0" to "1".
     * @param panning Panning between two speakers. Default value is "0" that mean two speakers have the same value.
     * Value can be from "-1" to "1".
     */
    public function play(id:String, loops:int = 1, volume:Number = 1, panning:Number = 0):void
    {
        if (!sounds.hasOwnProperty(id))
            throw new Error("Sound '" + id + "' can't be played because it has not been added in the sound manager.");

        var sEffect:SoundEffect = sounds[id];
        if (sEffect && isAudioOn(sEffect.type))
        {
            sEffect.play(loops, volume, panning);

            if (sEffect.type == SoundEffectType.MUSIC && !isPlaying(id))
            {
                playingSounds[id] = sEffect;
                _playingSoundsLength++;
            }
        }
    }

    /**
     * Stop the sound effect which is playing.
     *
     * @param id Identifier of the sound to stop.
     */
    public function stop(id:String):void
    {
        if (playingSounds.hasOwnProperty(id))
        {
            (playingSounds[id] as SoundEffect).stop();
            delete playingSounds[id];
            _playingSoundsLength--;
        }
    }

    /**
     * Stop all sound effects which are playing.
     */
    public function stopAll():void
    {
        for (var id:String in playingSounds)
        {
            stop(id);
        }
    }

    /**
     * Apply new volume to the playing sound effect.
     *
     * @param id Identifier of the playing sound effect.
     * @param volume New value of the volume.
     */
    public function setVolume(id:String, volume:Number):void
    {
        var sEffect:SoundEffect = playingSounds[id];
        if (sEffect && isAudioOn(sEffect.type))
            sEffect.setVolume(volume);
    }

    /**
     * Mute or unmute all playing sound effects.
     *
     * @param mute Define muting or unmuting all sound effects.
     */
    public function muteAll(mute:Boolean = true):void
    {
        var sEffect:SoundEffect;
        for (var id:String in playingSounds)
        {
            sEffect = playingSounds[id];
            if (mute || (!mute && isAudioOn(sEffect.type)))
                sEffect.muteSound(mute);
        }
    }

    /**
     * Create fade effect for the playing sound effect.
     *
     * @param id Identifier of the playing sound effect to apply fade effect.
     * @param volume Value of the volume to fade.
     * @param duration Duration in seconds of the fading effect.
     * @param stop Stop playing sound effect after fading will be completed.
     */
    public function fade(id:String, volume:Number = 0, duration:Number = 2, stop:Boolean = false):void
    {
        if (!playingSounds.hasOwnProperty(id))
            throw new Error("Sound '" + id + "' can't be faded because it isn't playing.");

        var sEffect:SoundEffect = playingSounds[id];
        if (sEffect && isAudioOn(sEffect.type))
            sEffect.fade(volume, duration, stop);
    }

    /**
     * Create fade effect between two sounds.
     *
     * @param inputId Identifier of the input sound effect to apply fade effect.
     * @param outputId Identifier of the output sound effect to apply fade effect.
     * @param inputDuration Duration in seconds of the fade effect for the input sound effect.
     * @param outputDuration Duration in seconds of the fading effect for the output sound effect.
     * @param inputVolume Value of the volume to fade the input sound effect.
     * @param outputVolume Value of the volume to fade the output sound effect.
     */
    public function crossFade(inputId:String, outputId:String, inputDuration:int = 2, outputDuration:int = 2,
                              inputVolume:Number = 0, outputVolume:Number = 1):void
    {
        // if the first sound is not already playing, start playing it
        if (!isPlaying(inputId))
            play(inputId, 0);

        fade(inputId, inputVolume, inputDuration);
        fade(outputId, outputVolume, outputDuration);

        // stop the first sound after volume will be zero
        Starling.juggler.delayCall(stop, inputDuration, inputId);
    }
}
}

internal class SingletonBlocker {}