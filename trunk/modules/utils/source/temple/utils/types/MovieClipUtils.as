/*
 *	Temple Library for ActionScript 3.0
 *	Copyright © MediaMonks B.V.
 *	All rights reserved.
 *	
 *	Redistribution and use in source and binary forms, with or without
 *	modification, are permitted provided that the following conditions are met:
 *	1. Redistributions of source code must retain the above copyright
 *	   notice, this list of conditions and the following disclaimer.
 *	2. Redistributions in binary form must reproduce the above copyright
 *	   notice, this list of conditions and the following disclaimer in the
 *	   documentation and/or other materials provided with the distribution.
 *	3. All advertising materials mentioning features or use of this software
 *	   must display the following acknowledgement:
 *	   This product includes software developed by MediaMonks B.V.
 *	4. Neither the name of MediaMonks B.V. nor the
 *	   names of its contributors may be used to endorse or promote products
 *	   derived from this software without specific prior written permission.
 *	
 *	THIS SOFTWARE IS PROVIDED BY MEDIAMONKS B.V. ''AS IS'' AND ANY
 *	EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 *	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 *	DISCLAIMED. IN NO EVENT SHALL MEDIAMONKS B.V. BE LIABLE FOR ANY
 *	DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 *	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 *	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 *	ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 *	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 *	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *	
 *	
 *	Note: This license does not apply to 3rd party classes inside the Temple
 *	repository with their own license!
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
		public static function play(movieclip:MovieClip, speed:Number = 1, loop:Boolean = false, to:int = 0):void
		{
			MovieClipUtils.stop(movieclip);
			
			if (speed != 0)
			{
				if (MovieClipUtils._playInfoDictionary == null) MovieClipUtils._playInfoDictionary = new Dictionary(true);
				
				movieclip.addEventListener(Event.ENTER_FRAME, MovieClipUtils.handleEnterFrame, false, 0, true);
				MovieClipUtils._playInfoDictionary[movieclip] = new PlayInfo(speed, loop, movieclip.currentFrame, to);
			}
		}
		
		/**
		 * Plays a movieclip backwards
		 */
		public static function playBackwards(movieclip:MovieClip, to:int = 0):void
		{
			MovieClipUtils.play(movieclip, -1, false, to);
		}
		
		private static function handleEnterFrame(event:Event):void
		{
			var movieclip:MovieClip = MovieClip(event.target);
			var playInfo:PlayInfo = MovieClipUtils._playInfoDictionary[movieclip];
			
			if (playInfo)
			{
				playInfo.frame += playInfo.speed;
				
				if (playInfo.to && (playInfo.frame >= playInfo.to && playInfo.speed > 0 || playInfo.frame <= playInfo.to && playInfo.speed < 0))
				{
					playInfo.frame = playInfo.to;
					MovieClipUtils.stop(movieclip);
				}
				else if (playInfo.frame < 1 || playInfo.frame > movieclip.totalFrames)
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
					if (child is MovieClip)
					{
						MovieClip(child).stop();
					}
					MovieClipUtils.deepStop(DisplayObjectContainer(child));
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
					if (child is MovieClip)
					{
						if (frame is String)
						{
							if (FrameLabelUtils.hasLabel(MovieClip(child), frame)) MovieClip(child).gotoAndStop(frame);
						}
						else
						{
							MovieClip(child).gotoAndStop(frame);
						}
					}
					MovieClipUtils.deepGotoAndStop(DisplayObjectContainer(child), frame);
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
					if (child is MovieClip)
					{
						if (frame is String)
						{
							if (FrameLabelUtils.hasLabel(MovieClip(child), frame)) MovieClip(child).gotoAndPlay(frame);
						}
						else
						{
							MovieClip(child).gotoAndPlay(frame);
						}
					}
					MovieClipUtils.deepGotoAndPlay(DisplayObjectContainer(child), frame);
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
	public var to:int;

	public function PlayInfo(speed:Number, loop:Boolean, frame:int, to:int)
	{
		this.speed = speed;
		this.loop = loop;
		this.frame = frame;
		this.to = to;
	}
}
