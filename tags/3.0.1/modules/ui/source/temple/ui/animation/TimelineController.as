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

package temple.ui.animation 
{
	import temple.core.behaviors.AbstractBehavior;
	import temple.core.debug.IDebuggable;
	import temple.core.debug.addToDebugManager;

	import flash.display.FrameLabel;
	import flash.display.MovieClip;


	/**
	 * Class for controlling the timeline of a <code>MovieClip</code>
	 * 
	 * @example
	 * <listing version="3.0">
	 * var timelineController:TimelineController = new TimelineController(this.mcClip);
	 * timelineController.addLableEventListener('fadeIn', handleFadeInClip);
	 * </listing>
	 * 
	 * @author Corstiaan[at]mediamonks.com
	 */
	public class TimelineController extends AbstractBehavior implements IDebuggable
	{
		protected var _labels:Object;
		protected var _listeners:Object;
		protected var _dispatchLabelEvents:Boolean;
		
		private var _debug:Boolean;

		public function TimelineController(target:MovieClip, dispatchLabelEvents:Boolean = false) 
		{
			this._dispatchLabelEvents = dispatchLabelEvents;
			this._labels = new Object();
			this._listeners = new Object();
			
			super(target);
			
			addToDebugManager(this);
			
			for each (var label:FrameLabel in this.movieClip.currentScene.labels)
			{
				this.movieClip.addFrameScript(label.frame - 1, this.onFrame);
				this._labels[label.frame] = this._labels[label.name] = label;
			}
		}
		
		/**
		 * Returns a reference to the MovieClip. Same value as target, but typed as MovieClip
		 */
		public function get movieClip():MovieClip
		{
			return this.target as MovieClip;
		}

		/**
		 * Add an event listener to a framelabel
		 * @param labelName name of the framelabel
		 * @param listener metod called when frame is reached, method must accept one TimelineControllerEvent parameter
		 * @param offset on which frame the listener is called relative to the label
		 * 			0 means on the same frame as the label
		 * 			-1 means the frame before the label
		 * 			1 means the frame after the label
		 * @return true on success, false on error
		 */
		public function addLabelEventListener(labelName:String, listener:Function, offset:int = 0):Boolean
		{
			if (this._labels.hasOwnProperty(labelName))
			{
				var frameNumber:int = FrameLabel(this._labels[labelName]).frame + offset - 1;
				
				if (frameNumber < 0)
				{
					this.logError("addLabelEventListener: invalid offset, label '" + labelName + "' is on frame " + (frameNumber - offset + 1) + ". Offset " + offset + " will result in a negative value");
					return false;
				}
				else if (!this._listeners.hasOwnProperty(frameNumber))
				{
					this.movieClip.addFrameScript(frameNumber, this.onFrame);
					this._listeners[frameNumber] = true;
				}
				this.addEventListener(TimelineControllerEvent.REACH_FRAME + '.' + (frameNumber + 1).toString(), listener);
				
				return true;
			}
			else
			{
				this.logError("addLabelEventListener: no frame with label '" + labelName + "' found");
			}
			return false;
		}
		
		/**
		 * Removes an event listener of a framelabel
		 * @param labelName name of the framelabel
		 * @param listener metod called when frame is reached, method must accept one TimelineControllerEvent parameter
		 * @param offset on which frame the listener is called relative to the label
		 * @return true on success, false on error
		 */
		public function removeLabelEventListener(labelName:String, listener:Function, offset:int = 0):Boolean
		{
			if (this._labels.hasOwnProperty(labelName))
			{
				var frameNumber:int = FrameLabel(this._labels[labelName]).frame + offset - 1;
				
				if (frameNumber < 0)
				{
					this.logError("removeLabelEventListener: invalid offset, label '" + labelName + "' is on frame " + (frameNumber - offset + 1) + ". Offset " + offset + " will result in a negative value");
					return false;
				}
				
				this.removeEventListener(TimelineControllerEvent.REACH_FRAME + '.' + (frameNumber+1).toString(), listener);
				
				return true;
			}
			else
			{
				this.logError("removeLabelEventListener: no frame with label '" + labelName + "' found");
			}
			return false;
		}

		/**
		 * Add an event listener to a frameNumber
		 * @param frameNumber number of the frame
		 * @param listener metod called when frame is reached, method must accept one TimelineControllerEvent parameter
		 * @return true on success, false on error
		 */
		public function addFrameEventListener(frameNumber:uint, listener:Function):Boolean
		{
			if (frameNumber < 1)
			{
				this.logError("addFrameEventListener: frameNumber (" + frameNumber + ") must be greater then 0");
				return false;
			}
			
			if (!this._listeners.hasOwnProperty(frameNumber - 1))
			{
				this.movieClip.addFrameScript(frameNumber - 1, this.onFrame);
				this._listeners[frameNumber - 1] = true;
			}
			this.addEventListener(TimelineControllerEvent.REACH_FRAME + '.' + frameNumber.toString(), listener);

			return true;
		}

		/**
		 * Removes an event listeren of a frameNumber
		 * @param frameNumber number of the frame
		 * @param listener metod called when frame is reached, method must accept one TimelineControllerEvent parameter
		 * @return true on success, false on error
		 */
		public function removeFrameEventListener(frameNumber:int, listener:Function):Boolean
		{
			if (frameNumber < 1)
			{
				this.logError("removeFrameEventListener: frameNumber (" + frameNumber + ") must be greater then 0");
				return false;
			}
			this.removeEventListener(TimelineControllerEvent.REACH_FRAME + '.' + frameNumber.toString(), listener);
			return true;
		}

		/**
		 * Indicates if an event is dispachted on every label
		 */
		public function get dispatchLabelEvents():Boolean
		{
			return this._dispatchLabelEvents;
		}
		
		/**
		 * @private
		 */
		public function set dispatchLabelEvents(value:Boolean):void
		{
			this._dispatchLabelEvents = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get debug():Boolean
		{
			return this._debug;
		}

		/**
		 * @inheritDoc
		 */
		public function set debug(value:Boolean):void
		{
			this._debug = value;
		}

		protected function onFrame():void
		{
			if (this._debug) this.logDebug("onFrame: frame=" + this.movieClip.currentFrame + ", label=" + this.movieClip.currentLabel + ", dispatchLabelEvents=" + this._dispatchLabelEvents);
			
			if (this._listeners.hasOwnProperty(this.movieClip.currentFrame-1))
			{
				if (this._debug) this.logDebug("onFrame: dispatch TimelineControllerEvent '" + (TimelineControllerEvent.REACH_FRAME + '.' + this.movieClip.currentFrame) + "'");
				this.dispatchEvent(new TimelineControllerEvent(TimelineControllerEvent.REACH_FRAME + '.' + this.movieClip.currentFrame, this, this.movieClip.currentFrame, this.movieClip.currentLabel));
			}
			if (this._dispatchLabelEvents)
			{
				this.dispatchEvent(new TimelineControllerEvent(TimelineControllerEvent.REACH_FRAME, this, this.movieClip.currentFrame, this.movieClip.currentLabel));
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			if (this.movieClip)
			{
				this.movieClip.stop();
				for each (var label:FrameLabel in this.movieClip.currentScene.labels)
				{
					this.movieClip.addFrameScript(label.frame - 1, null);
				}
			}
			this._listeners = null;
			this._labels = null;
			
			super.destruct();
		}
	}
}
