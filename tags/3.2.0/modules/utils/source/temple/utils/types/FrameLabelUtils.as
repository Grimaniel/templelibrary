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

	import flash.display.FrameLabel;
	import flash.display.MovieClip;

	/**
	 * This class contains some functions for working with FrameLabels
	 * 
	 * @author Bart van der Schoor
	 */
	public final class FrameLabelUtils 
	{
		/**
		 * Returns the frame number for a specific label in a MovieClip
		 * @param clip the MovieClip which contains the label
		 * @param label the label to check
		 * 
		 * @return the frame number of the label
		 */
		public static function getFrameForLabel(clip:MovieClip, label:String):int
		{
			for each (var frameLabel:FrameLabel in clip.currentLabels)
			{
				if (frameLabel.name == label)
				{
					return frameLabel.frame;	
				}	
			}	
			return 1;
		}

		/**
		 * Add a script on a specific label on a MovieClip.
		 */
		public static function addLabelScript(clip:MovieClip, label:String, frameScript:Function):Boolean
		{
			for each(var frameLabel:FrameLabel in clip.currentLabels)
			{
				if(frameLabel.name == label)
				{
					clip.addFrameScript(frameLabel.frame - 1, frameScript);
					return true;	
				}	
			}
			return false;
		}

		/**
		 * Add a script at the last frame of specific label of a MovieClip.
		 */
		public static function addLabelScriptEnd(clip:MovieClip, label:String, frameScript:Function):void
		{
			clip.addFrameScript(FrameLabelUtils.getLastFrameOfSection(clip, label) - 1, frameScript);
		}
		
		/**
		 * Checks if a MovieClip has a specific label.
		 */
		public static function hasLabel(clip:MovieClip, label:String):Boolean
		{
			for each (var frameLabel:FrameLabel in clip.currentLabels)
			{
				if (frameLabel.name == label)
				{
					return true;	
				}	
			}	
			return false;
		}

		/**
		 * Checks if a MovieClip has all of the provided labels.
		 */
		public static function hasLabels(clip:MovieClip, ...labels):Boolean
		{
			if ((labels as Array).length == 0) throwError(new ArgumentError('zero labels'));
			
			for each (var frameLabel:FrameLabel in clip.currentLabels)
			{
				var ind:int = (labels as Array).indexOf(frameLabel.name);
				if (ind > -1)
				{
					(labels as Array).splice(ind, 1);
					if ((labels as Array).length == 0)
					{
						return true;
					}
				}
			}
			return false;
		}

		public static function getLabel(clip:MovieClip, label:String):FrameLabel
		{
			for each (var frameLabel:FrameLabel in clip.currentLabels)
			{
				if (frameLabel.name == label)
				{
					return frameLabel;	
				}	
			}	
			throwError(new TempleArgumentError(FrameLabelUtils, 'unknown label ' + label));
			return null;
		}
		/**
		 * Get the last frame of a section of timeline started by label
		 */
		public static function getLastFrameOfSection(clip:MovieClip, label:String):int
		{
			var start:FrameLabel = FrameLabelUtils.getLabel(clip, label);
			var closest:int = clip.totalFrames;
			if (closest == start.frame)
			{
				//label is on last frame
				return closest;
			}
			
			for each (var frameLabel:FrameLabel in clip.currentLabels)
			{
				if (frameLabel.frame > start.frame && frameLabel.frame < closest)
				{
					closest = frameLabel.frame;	
				}	
			}
			return closest != clip.totalFrames ? closest -1 : clip.totalFrames;
		}

		public static function dumpLabels(clip:MovieClip):String
		{
			var str:String = '';
			for each (var frameLabel:FrameLabel in clip.currentLabels)
			{
				str += frameLabel.frame + ':' + frameLabel.name + '\n';
			}	
			return str;
		}
		
		/**
		 * @private
		 */
		public static function toString():String
		{
			return objectToString(FrameLabelUtils);
		}
	}
}
