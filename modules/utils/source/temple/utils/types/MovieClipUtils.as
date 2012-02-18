/*
 *	 
 *	Temple Library for ActionScript 3.0
 *	Copyright © 2012 MediaMonks B.V.
 *	All rights reserved.
 *	
 *	http://code.google.com/p/templelibrary/
 *	
 *	Redistribution and use in source and binary forms, with or without
 *	modification, are permitted provided that the following conditions are met:
 *	
 *	- Redistributions of source code must retain the above copyright notice,
 *	this list of conditions and the following disclaimer.
 *	
 *	- Redistributions in binary form must reproduce the above copyright notice,
 *	this list of conditions and the following disclaimer in the documentation
 *	and/or other materials provided with the distribution.
 *	
 *	- Neither the name of the Temple Library nor the names of its contributors
 *	may be used to endorse or promote products derived from this software
 *	without specific prior written permission.
 *	
 *	
 *	Temple Library is free software: you can redistribute it and/or modify
 *	it under the terms of the GNU Lesser General Public License as published by
 *	the Free Software Foundation, either version 3 of the License, or
 *	(at your option) any later version.
 *	
 *	Temple Library is distributed in the hope that it will be useful,
 *	but WITHOUT ANY WARRANTY; without even the implied warranty of
 *	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *	GNU Lesser General Public License for more details.
 *	
 *	You should have received a copy of the GNU Lesser General Public License
 *	along with Temple Library.  If not, see <http://www.gnu.org/licenses/>.
 *	
 *	
 *	Note: This license does not apply to 3rd party classes inside the Temple
 *	repository with their own license!
 *	
 */

package temple.utils.types 
{
	import temple.core.debug.objectToString;
	import temple.core.errors.TempleArgumentError;
	import temple.core.errors.throwError;
	import temple.utils.FrameDelay;
	import temple.utils.TimeOut;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.Dictionary;

	/**
	 * This class contains some functions for MovieClips.
	 * 
	 * @author Arjan van Wijk
	 */
	public final class MovieClipUtils 
	{
		/**
		 * Stores all playing movieclip as [movieclip] = speed
		 */
		private static var _playInfoDictionary:Dictionary;

		/**
		 * Delays a MovieClip from playing for an amount of frames/milliseconds
		 * 
		 * @param clip MovieClip
		 * @param delay Delay in frames (or milliseconds when useFrames is set to false)
		 * @param useFrames	Use frames or milliseconds
		 */
		public static function wait(movieclip:MovieClip, delay:uint, frameBased:Boolean = true):void
		{
			movieclip.stop();
			
			if (frameBased)
			{
				new FrameDelay(movieclip.play, delay);
			}
			else
			{
				new TimeOut(movieclip.play, delay);
			}
		}

		/**
		 * Play a MovieClip at a given speed (forwards or backwards)
		 * 
		 * @param movieclip the MovieClip that must be played.
		 * @param speed indication (negative for backwards playing)
		 * @param loop the movieclip if reached the end or beginning
		 */
		public static function play(movieclip:MovieClip, speed:Number = 1, loop:Boolean = false):void
		{
			MovieClipUtils.stop(movieclip);
			
			if (speed != 0)
			{
				if (MovieClipUtils._playInfoDictionary == null) MovieClipUtils._playInfoDictionary = new Dictionary(true);
				
				movieclip.addEventListener(Event.ENTER_FRAME, MovieClipUtils.handleEnterFrame, false, 0, true);
				MovieClipUtils._playInfoDictionary[movieclip] = new PlayInfo(speed, loop, movieclip.currentFrame);
			}
		}
		
		/**
		 * Plays a movieclip backwards
		 */
		public static function playBackwards(movieclip:MovieClip):void
		{
			MovieClipUtils.play(movieclip, -1);
		}
		
		private static function handleEnterFrame(event:Event):void
		{
			var movieclip:MovieClip = MovieClip(event.target);
			var playInfo:PlayInfo = MovieClipUtils._playInfoDictionary[movieclip];
			
			if (playInfo)
			{
				playInfo.frame += playInfo.speed;
				
				if (playInfo.frame < 1 || playInfo.frame > movieclip.totalFrames)
				{
					if (playInfo.loop)
					{
						if (playInfo.frame < 1)
						{
							playInfo.frame += movieclip.totalFrames;
						}
						else
						{
							playInfo.frame -= movieclip.totalFrames;
						}
					}
					else
					{
						playInfo.frame = playInfo.frame < 1 ? 1 : movieclip.totalFrames;
						MovieClipUtils.stop(movieclip);
					}
				}
				movieclip.gotoAndStop(Math.round(playInfo.frame));
			}
		}

		/**
		 * Stops a MovieClip and removes the play-enterFrame
		 * 
		 * @param movieclip the MovieClip to stop
		 * @param callStop if set to true (default) the 'stop()' method will also be called on the MovieClip.
		 */
		public static function stop(movieclip:MovieClip, callStop:Boolean = true):void
		{
			if (callStop) movieclip.stop();
			if (MovieClipUtils._playInfoDictionary != null && MovieClipUtils._playInfoDictionary[movieclip] != null) movieclip.removeEventListener(Event.ENTER_FRAME, handleEnterFrame);
		}
		
		/**
		 * Recursively stop() all nested MovieClips through all clip's DisplayObjectContianers)
		 * 
		 * Note: Does not affect argument
		 */
		public static function deepStop(clip:DisplayObjectContainer):void
		{
			if (clip == null) throwError(new TempleArgumentError(MovieClipUtils, 'null clip'));
			
			var num:int = clip.numChildren;
			for (var i:int=0;i<num;i++)
			{
				var child:DisplayObject;
				try
				{
					child = clip.getChildAt(i);
				}
				catch (error:Error) {}
				
				if (child && child is DisplayObjectContainer)
				{
					MovieClipUtils.deepStop(DisplayObjectContainer(child));
					if (child is MovieClip)
					{
						MovieClip(child).stop();
					}
				}
			}
		}
		
		/**
		 * Recursively play() all nested MovieClips through all clip's DisplayObjectContianers)
		 * 
		 * Note: Does not affect argument
		 */
		public static function deepPlay(clip:DisplayObjectContainer):void
		{
			if (clip == null) throwError(new TempleArgumentError(MovieClipUtils, 'null clip'));
			
			var num:int = clip.numChildren;
			for (var i:int=0;i<num;i++)
			{
				var child:DisplayObject;
				try
				{
					child = clip.getChildAt(i);
				}
				catch (error:Error) {}
				
				if (child && child is DisplayObjectContainer)
				{
					if (child is MovieClip)
					{
						MovieClip(child).play();
					}
					MovieClipUtils.deepPlay(DisplayObjectContainer(child));
				}
			}
		}
		
		/**
		 * Recursively nextFrames all nested MovieClips through all children DisplayObjectContianers), with option for looping
		 * 
		 * Useful in a enterFrame if a gotoAndStop on parent timeline stops nested anims
		 * 
		 * Last-resort util: may screw up synced nested anims
		 * 
		 * Note: Does not affect argument
		 */
		public static function deepNextFrame(clip:DisplayObjectContainer, loop:Boolean=false):void
		{
			if (clip == null) throwError(new TempleArgumentError(MovieClipUtils, 'Clip cannot be null'));
			
			var num:int = clip.numChildren;
			for (var i:int=0;i<num;i++)
			{
				var child:DisplayObject;
				try
				{
					child = clip.getChildAt(i);
				}
				catch (error:Error) {}
				
				if (child && child is DisplayObjectContainer)
				{
					if (child is MovieClip)
					{
						var mc:MovieClip = MovieClip(child);
						if (mc.currentFrame == mc.totalFrames)
						{
							if (loop)
							{
								mc.gotoAndStop(1);
							}
						}
						else
						{
							mc.nextFrame();
						}
					}
					MovieClipUtils.deepNextFrame(DisplayObjectContainer(child), loop);
				}
			}
		}

		public static function deepGotoAndStop(clip:DisplayObjectContainer, frame:*):void 
		{
			if (clip == null) throwError(new TempleArgumentError(MovieClipUtils, 'null clip'));
			
			var num:int = clip.numChildren;
			for (var i:int=0;i<num;i++)
			{
				var child:DisplayObject;
				try
				{
					child = clip.getChildAt(i);
				}
				catch (error:Error) {}
				
				if (child && child is DisplayObjectContainer)
				{
					MovieClipUtils.deepGotoAndStop(DisplayObjectContainer(child), frame);
					if (child is MovieClip)
					{
						MovieClip(child).gotoAndStop(frame);
					}
				}
			}
		}

		public static function deepGotoAndPlay(clip:DisplayObjectContainer, frame:*):void 
		{
			if (clip == null) throwError(new TempleArgumentError(MovieClipUtils, 'null clip'));
			
			var num:int = clip.numChildren;
			for (var i:int=0;i<num;i++)
			{
				var child:DisplayObject;
				try
				{
					child = clip.getChildAt(i);
				}
				catch (error:Error) {}
				
				if (child && child is DisplayObjectContainer)
				{
					MovieClipUtils.deepGotoAndPlay(DisplayObjectContainer(child), frame);
					if (child is MovieClip)
					{
						MovieClip(child).gotoAndPlay(frame);
					}
				}
			}
		}
		
		/**
		 * @private
		 */
		public static function toString():String
		{
			return objectToString(MovieClipUtils);
		}
	}
}

class PlayInfo
{
	public var speed:Number;
	public var loop:Boolean;
	public var frame:int;

	public function PlayInfo(speed:Number, loop:Boolean, frame:int)
	{
		this.speed = speed;
		this.loop = loop;
		this.frame = frame;
	}
}
