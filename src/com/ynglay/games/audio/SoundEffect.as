/**
 * Copyright 2013 YNGLAY. All Rights Reserved..
 * Author: Roman Zarichnyi
 * Date: 01.04.13
 * Time: 16:49
 */
package com.ynglay.games.audio {
import flash.events.Event;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.media.SoundTransform;

import starling.core.Starling;

/**
 * Sound effect class works with sound instance and sound channel of plying sound. It helps to work with
 * one seperate sound.
 */
public class SoundEffect
{
    /*
     * Sound channel of the playing sound.
     */
    private var channel:SoundChannel;

    /*
     * Sound transform of the playing sound.
     */
    private var soundTransform:SoundTransform;

    /*
    * Identifier of the sound effect.
    * */
    public var id:String;

    /*
     * Instance of the sound to play.
     */
    public var sound:Sound;

    /*
     * Type of the sound effect.
     */
    public var type:int;

    /*
     * Volume of the plying sound.
     */
    public var volume:Number;

    /*
    * Complete playing callback function.
    * */
    public var complete:Function;

    /*
     * Allow dispose the sound effect.
     * */
    public var proceedDispose:Boolean;

    /*
     * Constructor.
     *
     * @param sound Instance of the sound.
     * @param type Type of the sound.
     */
    public function SoundEffect(sound:Sound, type:int)
    {
        if (!sound)
            throw Error("Sound instance should be not null.");

        this.sound = sound;
        this.type = type;
    }

    /**
     * Play the sound effect.
     *
     * @param loops Loops to play the sound repeatedly.
     * @param volume Volume which will played the sound. Value can be from "0" to "1".
     * @param panning Panning between two speakers. Default value is "0" that mean two speakers have the same value.
     * Value can be from "-1" to "1".
     */
    public function play(loops:int = 1, volume:Number = 1, panning:Number = 0, complete:Function = null):void
    {
        this.volume = volume;
        this.complete = complete;

        // using sound transform class to change filters of the sound
        soundTransform = new SoundTransform(volume, panning);

        channel = sound.play(0, loops);
        channel.addEventListener(Event.SOUND_COMPLETE, onSoundCompleteHandler);
        channel.soundTransform = soundTransform;
    }

    /**
     * Stop playing the sound effect.
     */
    public function stop():void
    {
        if (channel)
            channel.stop();
    }

    /**
     * Apply new volume to the sound effect.
     *
     * @param volume New value of the volume.
     */
    public function setVolume(volume:Number):void
    {
        this.volume = volume;

        if (channel && soundTransform)
        {
            soundTransform.volume = volume;
            channel.soundTransform = soundTransform;
        }
    }

    /**
     * Mute or unmute the sound effects
     *
     * @param mute Define muting or unmuting the sound effect.
     */
    public function muteSound(mute:Boolean = true):void
    {
        if (channel && soundTransform)
        {
            soundTransform.volume = mute ? 0 : volume;
            channel.soundTransform = soundTransform;
        }
    }

    /**
     * Create fade effect for the sound effect.
     *
     * @param volume Value of the volume to fade.
     * @param duration Duration in seconds of the fading effect.
     * @param stop Stop playing sound effect after fading will be completed.
     */
    public function fade(volume:Number = 0, duration:Number = 2, stop:Boolean = false):void
    {
        if (stop)
        {
            Starling.juggler.tween(soundTransform, duration, {
                volume: volume,
                onUpdate: onUpdateVolume,
                onComplete: stop
            });
        }
        else
        {
            Starling.juggler.tween(soundTransform, duration, {
                volume: volume,
                onUpdate: onUpdateVolume
            });
        }
    }

    /**
     * Updating volume function during tweening between previous and next volume value.
     */
    private function onUpdateVolume():void
    {
        channel.soundTransform = soundTransform;
    }

    private function onSoundCompleteHandler(event:Event):void
    {
        channel.removeEventListener(Event.SOUND_COMPLETE, onSoundCompleteHandler);
        if (complete is Function)
            complete(id);
    }
}
}
