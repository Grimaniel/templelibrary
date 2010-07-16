/*
 *	 
 *	Temple Library for ActionScript 3.0
 *	Copyright © 2010 MediaMonks B.V.
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

package temple.ui.buttons.behaviors 
{
	import temple.data.collections.HashMap;
	import temple.debug.errors.TempleError;
	import temple.debug.errors.throwError;
	import temple.utils.RenderUtils;
	import temple.utils.types.ObjectUtils;

	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.Dictionary;

	/**
	 * 
	 * @includeExample ../MultiStateButtonFrameLabelsExample.as
	 * 
	 * @author Thijs Broerse
	 */
	public class ButtonTimelineBehavior extends AbstractButtonDesignBehavior
	{
		private static const _dictionary:Dictionary = new Dictionary(true);
		
		/**
		 * Returns the ButtonTimelineBehavior of a DisplayObject if the DisplayObject has ButtonTimelineBehavior. Otherwise null is returned 
		 */
		public static function getInstance(target:MovieClip):ButtonTimelineBehavior
		{
			return ButtonTimelineBehavior._dictionary[target] as ButtonTimelineBehavior;
		}
		
		private var _labels:HashMap;
		private var _currentLabel:String;
		private var _targetFrame:int;
		
		private var _playBackwardsBeforeOver:Boolean = true;
		private var _playBackwardsBeforeDown:Boolean = true;
		private var _playBackwardsBeforeSelected:Boolean = true;
		private var _playBackwardsBeforeDisabled:Boolean = true;
		
		/**
		 * Create a ButtonTimelineBehavior for a movieclip, based on timeline labels. See ButtonTimelineLabels for possible labels
		 * 
		 * @see temple.ui.buttons.behaviors.ButtonTimelineLabels
		 * 
		 * @param target the MovieClip that gets the ButtonTimelineBehavior
		 */
		public function ButtonTimelineBehavior(target:MovieClip, debug:Boolean = false)
		{
			super(target);
			
			if(ButtonTimelineBehavior._dictionary[target]) throwError(new TempleError(this, target + " already has ButtonTimelineBehavior"));
			
			ButtonTimelineBehavior._dictionary[target] = this;
			
			this.debug = debug;
			target.stop();
			this.initLabels();
			this.upState();
		}
		
		/**
		 * Returns a reference to the MovieClip. Same value as target, but typed as MovieClip
		 */
		public function get movieClip():MovieClip
		{
			return this.target as MovieClip;
		}

		/**
		 * @inheritDoc
		 */
		override public function set enabled(value:Boolean):void 
		{
			if (super.enabled != value)
			{
				super.enabled = value;
				
				if (value)
				{
					this.update(this);
				}
				else
				{
					this.movieClip.removeEventListener(Event.ENTER_FRAME, this.handleEnterFrame);
				}
			}
		}

		/**
		 * @inheritDoc
		 */
		override public function update(status:IButtonStatus):void
		{
			super.update(status);
			
			if (!this.enabled) return;
			
			if(this.debug) this.logDebug("update: selected=" + this.selected + ", disabled=" + this.disabled + ", over=" + this.over + ", down=" + this.down + ", focus=" + this.focus + ", currentLabel='" + this._currentLabel + "', currentFrame='" + this.movieClip.currentFrame + "'");
			
			switch (true)
			{
				case this.selected:
				{
					this.selectedState();
					break;
				}
				case this.disabled:
				{
					this.disabledState();
					break;
				}
				case this.down:
				{
					switch(this._currentLabel)
					{
						case ButtonTimelineLabels.UP:
						case ButtonTimelineLabels.IN:
						case ButtonTimelineLabels.OUT:
						{
							this.overState();
							break;
						}
						default:
						{
							this.downState();
							break;
						}
					}
					break;
				}
				case this.over:
				{
					switch(this._currentLabel)
					{
						case ButtonTimelineLabels.IN:
						case ButtonTimelineLabels.OVER:
						{
							// do nothing
							break;
						}
						case ButtonTimelineLabels.SELECT:
						case ButtonTimelineLabels.SELECTED:
						case ButtonTimelineLabels.DESELECT:
						{
							this.animateTo(ButtonTimelineLabels.SELECTED, ButtonTimelineLabels.DESELECT, ButtonTimelineLabels.OVER, ButtonTimelineLabels.SELECT, this._playBackwardsBeforeSelected);
							break;
						}
						case ButtonTimelineLabels.PRESS:
						case ButtonTimelineLabels.DOWN:
						case ButtonTimelineLabels.RELEASE:
						{
							if(this.debug) this.logDebug("update from a down state");
							this.animateTo(ButtonTimelineLabels.DOWN, ButtonTimelineLabels.RELEASE, ButtonTimelineLabels.OVER, ButtonTimelineLabels.PRESS, this._playBackwardsBeforeDown);
							break;
						}
						default:
						{
							this.overState();
							break;
						}
					}
					break;
				}
				case this.focus:
				{
					if (this._labels[ButtonTimelineLabels.FOCUSED] || this._labels[ButtonTimelineLabels.FOCUS])
					{
						switch(this._currentLabel)
						{
							case ButtonTimelineLabels.SELECT:
							case ButtonTimelineLabels.SELECTED:
							case ButtonTimelineLabels.DESELECT:
							{
								this.animateTo(ButtonTimelineLabels.SELECTED, ButtonTimelineLabels.DESELECT, ButtonTimelineLabels.FOCUSED, ButtonTimelineLabels.SELECT, this._playBackwardsBeforeSelected);
								break;
							}
							case ButtonTimelineLabels.PRESS:
							case ButtonTimelineLabels.DOWN:
							case ButtonTimelineLabels.RELEASE:
							{
								if(this.debug) this.logDebug("update from a down state");
								this.animateTo(ButtonTimelineLabels.DOWN, ButtonTimelineLabels.RELEASE, ButtonTimelineLabels.FOCUSED, ButtonTimelineLabels.PRESS, this._playBackwardsBeforeDown);
								break;
							}
							default:
							{
								this.focusState();
								break;
							}
						}
						break;
					}
					else
					{
						// no break
					}
				}
				
				default:
				{
					switch (this._currentLabel)
					{
						case ButtonTimelineLabels.PRESS:
						case ButtonTimelineLabels.DOWN:
						case ButtonTimelineLabels.RELEASE:
						{
							this.animateTo(ButtonTimelineLabels.DOWN, ButtonTimelineLabels.RELEASE, ButtonTimelineLabels.OVER, ButtonTimelineLabels.PRESS, this._playBackwardsBeforeDown);
							break;
						}
						case ButtonTimelineLabels.IN:
						case ButtonTimelineLabels.OVER:
						case ButtonTimelineLabels.OUT:
						{
							this.animateTo(ButtonTimelineLabels.OVER, ButtonTimelineLabels.OUT, ButtonTimelineLabels.UP, ButtonTimelineLabels.IN, this._playBackwardsBeforeOver);
							break;
						}
						case ButtonTimelineLabels.SELECT:
						case ButtonTimelineLabels.SELECTED:
						case ButtonTimelineLabels.DESELECT:
						{
							this.animateTo(ButtonTimelineLabels.SELECTED, ButtonTimelineLabels.DESELECT, ButtonTimelineLabels.UP, ButtonTimelineLabels.SELECT, this._playBackwardsBeforeSelected);
							break;
						}
						case ButtonTimelineLabels.DISABLE:
						case ButtonTimelineLabels.DISABLED:
						case ButtonTimelineLabels.ENABLE:
						{
							this.animateTo(ButtonTimelineLabels.DISABLED, ButtonTimelineLabels.ENABLE, ButtonTimelineLabels.UP, ButtonTimelineLabels.DISABLE, this._playBackwardsBeforeDisabled);
							break;
						}
						case ButtonTimelineLabels.FOCUS:
						case ButtonTimelineLabels.FOCUSED:
						case ButtonTimelineLabels.BLUR:
						{
							this.animateTo(ButtonTimelineLabels.FOCUSED, ButtonTimelineLabels.BLUR, ButtonTimelineLabels.UP, ButtonTimelineLabels.FOCUS, this._playBackwardsBeforeDisabled);
							break;
						}
						default:
						{
							this.upState();
							break;
						}
					}
					break;
				}
			}
		}

		/**
		 * Indicates if the animation should play the 'in' animation backwards (true) when the 'over' state is not reached.
		 * Otherwise (false) animation continues to 'over' state and than does 'out' state. Default: true.
		 */
		public function get playBackwardsBeforeOver():Boolean
		{
			return this._playBackwardsBeforeOver;
		}
		
		/**
		 * @private
		 */
		public function set playBackwardsBeforeOver(value:Boolean):void
		{
			this._playBackwardsBeforeOver = value;
		}
		
		/**
		 * Indicates if the animation should play the 'press' animation backwards (true) when the 'down' state is not reached.
		 * Otherwise (false) animation continues to 'down' state and than does 'release' state. Default: true.
		 */
		public function get playBackwardsBeforeDown():Boolean
		{
			return this._playBackwardsBeforeDown;
		}
		
		/**
		 * @private
		 */
		public function set playBackwardsBeforeDown(value:Boolean):void
		{
			this._playBackwardsBeforeDown = value;
		}

		/**
		 * Indicates if the animation should play the 'select' animation backwards (true) when the 'selected' state is not reached.
		 * Otherwise (false) animation continues to 'selected' state and than does 'deselect' state. Default: true.
		 */
		public function get playBackwardsBeforeSelected():Boolean
		{
			return this._playBackwardsBeforeSelected;
		}
		
		/**
		 * @private
		 */
		public function set playBackwardsBeforeSelected(value:Boolean):void
		{
			this._playBackwardsBeforeSelected = value;
		}

		/**
		 * Indicates if the animation should play the 'disable' animation backwards (true) when the 'disabled' state is not reached,
		 * otherwise (false) animation continues to 'disabled' state and than does 'enable' state. Default: true.
		 */
		public function get playBackwardsBeforeDisabled():Boolean
		{
			return this._playBackwardsBeforeDisabled;
		}
		
		/**
		 * @private
		 */
		public function set playBackwardsBeforeDisabled(value:Boolean):void
		{
			this._playBackwardsBeforeSelected = value;
		}
		
		/**
		 * Returns the HashMap with all labels. Usefull for debugging.
		 */
		public function get labels():HashMap
		{
			return this._labels;
		}
		
		/**
		 * Returns the name of the current (or last reached) frame
		 */
		public function get currentLabel():String
		{
			return this._currentLabel;
		}
		
		private function animateTo(start:String, enter:String, goal:String, exit:String, backwardsBeforeGoal:Boolean):void
		{
			if (this.debug) this.logDebug("animateTo: start='" + start + "', enter='" + enter + "', goal='" + goal + "', exit='" + exit + "', backwardsBeforeGoal=" + backwardsBeforeGoal);
			
			if(!this._labels[goal])
			{
				if (this.debug) this.logWarn("MovieClip has no label '" + goal + "'");
				return;
			}
			// check if we are already on our goal
			else if (FrameLabelData(this._labels[goal]).startframe == this.movieClip.currentFrame)
			{
				this._currentLabel = goal;
				if (this.debug) this.logDebug("animateTo: goal '" + goal + "' reached");
				this.movieClip.removeEventListener(Event.ENTER_FRAME, this.handleEnterFrame);
			}
			// check if we are currently in the exit state 
			else if(this._labels[exit] && FrameLabelData(this._labels[exit]).isActiveAt(this.movieClip.currentFrame))
			{
				// backwards?
				if (backwardsBeforeGoal)
				{
					// ok, play backwards
					this._currentLabel = goal;
					if (this.debug) this.logDebug("animateTo: play backwards");
					this.gotoFrame(FrameLabelData(this._labels[exit]).startframe);
				}
				else
				{
					// do nothing
				}
			}
			// check if there are no enter and exit states, but we have a start
			else if (!this._labels[enter] && !this._labels[exit] && start && this._labels[start])
			{
				// check if there are labels between the start and goal
				var found:Boolean;
				
				var frame:int = this.movieClip.currentFrame;
				var end:int = FrameLabelData(this._labels[goal]).startframe;
				
				do
				{
					if (frame < end)
					{
						frame++;
					}
					else
					{
						frame--;
					}
					found = this._labels.hasOwnProperty(frame) && frame != end;
				}
				while (!found && frame != end);
				
				if (this.debug) this.logDebug("animateTo: there are no labels '" + enter + "' and '" + exit + "', but we have '" + start + "', so animate between them");
				
				// check if we are currenlty between start and goal
				if (!found && !(this.movieClip.currentFrame < FrameLabelData(this._labels[start]).startframe && this.movieClip.currentFrame < FrameLabelData(this._labels[goal]).startframe) 
				&& !(this.movieClip.currentFrame > FrameLabelData(this._labels[start]).startframe && this.movieClip.currentFrame > FrameLabelData(this._labels[goal]).startframe))
				{
					this._currentLabel = enter;
					this.gotoFrame(FrameLabelData(this._labels[goal]).startframe);
				}
				else
				{
					this._currentLabel = goal;
					this.movieClip.removeEventListener(Event.ENTER_FRAME, this.handleEnterFrame);
					this.movieClip.gotoAndStop(FrameLabelData(this._labels[goal]).startframe);
				}
			}
			// check if we have an enter state
			else if(this._labels[enter])
			{
				this._currentLabel = enter;
				
				if (this.debug) this.logDebug("animateTo: currentLabel='" + enter + "', currentFrame=" + this.movieClip.currentFrame);
				
				// check if enter is currently active
				if (!FrameLabelData(this._labels[enter]).isActiveAt(this.movieClip.currentFrame))
				{
					if(this.debug) this.logDebug("animateTo: goto '" + enter + "'");
					this.movieClip.gotoAndStop(enter);
				}
				this.gotoFrame(FrameLabelData(this._labels[enter]).endframe);
			}
			else
			{
				// just go to our goal
				if(this.debug) this.logDebug("animateTo: just go to our goal '" + goal + "'");
				this._currentLabel = goal;
				this.movieClip.removeEventListener(Event.ENTER_FRAME, this.handleEnterFrame);
				this.movieClip.gotoAndStop(FrameLabelData(this._labels[goal]).startframe);
				
				if(goal == ButtonTimelineLabels.OVER && !this.over) this.update(this);
			}
			RenderUtils.update();
		}
		
		/**
		 * Shows the'up' state
		 */
		private function upState():void
		{
			if(this.debug) this.logDebug("upState");
			
			this._currentLabel = ButtonTimelineLabels.UP;
			this.movieClip.removeEventListener(Event.ENTER_FRAME, this.handleEnterFrame);
			this.movieClip.gotoAndStop(FrameLabelData(this._labels[ButtonTimelineLabels.UP]).startframe);
			RenderUtils.update();
		}
		

		private function overState():void
		{
			if(this.debug) this.logDebug("overState");
			this.animateTo(ButtonTimelineLabels.UP, ButtonTimelineLabels.IN, ButtonTimelineLabels.OVER, ButtonTimelineLabels.OUT, this._playBackwardsBeforeOver);
		}

		private function downState():void
		{
			if(this.debug) this.logDebug("downState");
			this.animateTo(ButtonTimelineLabels.OVER, ButtonTimelineLabels.PRESS, ButtonTimelineLabels.DOWN, ButtonTimelineLabels.RELEASE, this._playBackwardsBeforeDown);
		}

		private function selectedState():void
		{
			if (this.debug) this.logDebug("selectedState");
			this.animateTo(null, ButtonTimelineLabels.SELECT, ButtonTimelineLabels.SELECTED, ButtonTimelineLabels.DESELECT, this._playBackwardsBeforeSelected);
		}
		
		private function disabledState():void
		{
			if (this.debug) this.logDebug("disabledState");
			this.animateTo(null, ButtonTimelineLabels.DISABLE, ButtonTimelineLabels.DISABLED, ButtonTimelineLabels.ENABLE, this._playBackwardsBeforeDisabled);
		}
		
		private function focusState():void
		{
			if(this.debug) this.logDebug("focusState");
			this.animateTo(ButtonTimelineLabels.UP, ButtonTimelineLabels.FOCUS, ButtonTimelineLabels.FOCUSED, ButtonTimelineLabels.BLUR, this._playBackwardsBeforeOver);
		}
		
		private function initLabels():void
		{
			this._labels = new HashMap("ButtonTimelineBehavior labels");
			
			if (this.movieClip.totalFrames < 2)
			{
				this.logWarn("MovieClip has no frames, ButtonTimelineBehavior is useless");
				this._labels[1] = this._labels[ButtonTimelineLabels.UP] = new FrameLabelData(ButtonTimelineLabels.UP, 1);
				return;
			}
			
			// sort labels on frame
			this.movieClip.currentScene.labels.sortOn("frame");
			var frameLabelData:FrameLabelData;
			var next:FrameLabel;
			var j:int;
			var length:int = this.movieClip.currentScene.labels.length;
			if (length)
			{
				for (var i:int = 0; i < length ; i++)
				{
					frameLabelData = new FrameLabelData(FrameLabel(this.movieClip.currentScene.labels[i]).name, FrameLabel(this.movieClip.currentScene.labels[i]).frame);
					
					switch(frameLabelData.name)
					{
						// Animated states
						case ButtonTimelineLabels.IN:
						case ButtonTimelineLabels.OUT:
						case ButtonTimelineLabels.PRESS:
						case ButtonTimelineLabels.RELEASE:
						case ButtonTimelineLabels.SELECT:
						case ButtonTimelineLabels.DESELECT:
						case ButtonTimelineLabels.DISABLE:
						case ButtonTimelineLabels.ENABLE:
						case ButtonTimelineLabels.FOCUS:
						case ButtonTimelineLabels.BLUR:
						{
							j = 0;
							do
							{
								if(++j < length)
								{
									next = FrameLabel(this.movieClip.currentScene.labels[i + j]);
								}
								else
								{
									next = null;
								}
							}
							while (next && next.frame == frameLabelData.startframe);
							
							frameLabelData.endframe = next ? next.frame - 1 : this.movieClip.totalFrames;
								
							if (this.debug) this.logDebug("initLabels: found label '" + frameLabelData.name + "', frames " + frameLabelData.startframe + "-" + frameLabelData.endframe);
							break;
						}
						// Non animated states
						case ButtonTimelineLabels.UP:
						case ButtonTimelineLabels.OVER:
						case ButtonTimelineLabels.DOWN:
						case ButtonTimelineLabels.SELECTED:
						case ButtonTimelineLabels.DISABLED:
						case ButtonTimelineLabels.FOCUSED:
						{
							if (this.debug) this.logDebug("initLabels: found label '" + frameLabelData.name + "', frame " + frameLabelData.startframe);
							break;
						}	
						default:
						{
							this.logWarn("initLabels: found invalid label '" + frameLabelData.name + "' at frame " + frameLabelData.startframe);
							continue;
							break;
						}
					}
					this._labels[frameLabelData.startframe] = this._labels[frameLabelData.name] = frameLabelData;
				}
				// since 'up' is mandatory, check for it and use first frame if 'up' is not found
				if (!this._labels[ButtonTimelineLabels.UP])
				{
					this._labels[1] = this._labels[ButtonTimelineLabels.UP] = new FrameLabelData(ButtonTimelineLabels.UP, 1);
					if(this.debug) this.logDebug("initLabels: 'up' not found so first frame is used as 'up' state");
				}
				// since 'over' is mandatory, check for it and use 'up' if 'over' is not found
				if (!this._labels[ButtonTimelineLabels.OVER])
				{
					this._labels[ButtonTimelineLabels.OVER] = new FrameLabelData(ButtonTimelineLabels.OVER, FrameLabelData(this._labels[ButtonTimelineLabels.UP]).startframe);
				}
			}
			else
			{
				// no labels found. Use first frame as up and lastframe as 'over' and 'selected'
				this._labels[1] = this._labels[ButtonTimelineLabels.UP] = new FrameLabelData(ButtonTimelineLabels.UP, 1);
				this._labels[this.movieClip.totalFrames] = this._labels[ButtonTimelineLabels.OVER] = new FrameLabelData(ButtonTimelineLabels.OVER, this.movieClip.totalFrames);
				this._labels[ButtonTimelineLabels.SELECTED] = new FrameLabelData(ButtonTimelineLabels.SELECTED, this.movieClip.totalFrames);
			}
			
			if (this.debug) this.logInfo("Labels: " + ObjectUtils.traceObject(this._labels, 3, false));
		}
		
		private function gotoFrame(frame:int):void
		{
			if (this.debug) this.logDebug("gotoFrame: " + frame + ", currentFrame=" + this.movieClip.currentFrame);
			this._targetFrame = frame;
			if (this.movieClip.currentFrame != this._targetFrame)
			{
				this.movieClip.addEventListener(Event.ENTER_FRAME, this.handleEnterFrame);
			}
			else
			{
				this.onAnimationDone();
			}
		}
		
		private function handleEnterFrame(event:Event):void
		{
			if (this._targetFrame == this.movieClip.currentFrame)
			{
				this.movieClip.removeEventListener(Event.ENTER_FRAME, this.handleEnterFrame);
				this.onAnimationDone();
			}
			else
			{
				this.moveToTarget();
			}
		}
		
		private function moveToTarget():void
		{
			if (this.movieClip.currentFrame < this._targetFrame)
			{
				this.movieClip.nextFrame();
			}
			else if (this.movieClip.currentFrame > this._targetFrame)
			{
				this.movieClip.prevFrame();
			}
		}

		private function onAnimationDone():void
		{
			if(this.debug) this.logDebug("animation done: currentLabel='" + this._currentLabel + "'");
			
			switch(this._currentLabel)
			{
				case ButtonTimelineLabels.IN:
				{
					this._currentLabel = ButtonTimelineLabels.OVER;
					break;
				}
				case ButtonTimelineLabels.OUT:
				{
					this._currentLabel = ButtonTimelineLabels.UP;
					break;
				}
				case ButtonTimelineLabels.PRESS:
				{
					this._currentLabel = ButtonTimelineLabels.DOWN;
					break;
				}
				case ButtonTimelineLabels.SELECT:
				{
					this._currentLabel = ButtonTimelineLabels.SELECTED;
					break;
				}
				case ButtonTimelineLabels.DISABLE:
				{
					this._currentLabel = ButtonTimelineLabels.DISABLED;
					break;
				}
				case ButtonTimelineLabels.FOCUS:
				{
					this._currentLabel = ButtonTimelineLabels.FOCUSED;
					break;
				}
				case ButtonTimelineLabels.RELEASE:
				{
					this._currentLabel = ButtonTimelineLabels.OVER;
					break;
				}
				case ButtonTimelineLabels.DESELECT:
				case ButtonTimelineLabels.ENABLE:
				case ButtonTimelineLabels.BLUR:
				{
					this._currentLabel = this.over ? ButtonTimelineLabels.OVER : ButtonTimelineLabels.UP;
					break;
				}
			}
			this.movieClip.removeEventListener(Event.ENTER_FRAME, this.handleEnterFrame);
			this.movieClip.gotoAndStop(FrameLabelData(this._labels[this._currentLabel]).startframe);
			
			this.update(this);
			
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			if(this.target) delete ButtonTimelineBehavior._dictionary[this.target];
			
			if (this.movieClip)
			{
				this.movieClip.removeEventListener(Event.ENTER_FRAME, this.handleEnterFrame);
			}
			this._labels = null;
			
			super.destruct();
		}
	}
}

import temple.debug.getClassName;

class FrameLabelData
{
	internal var name:String;
	internal var startframe:int;
	internal var endframe:int;
	
	public function FrameLabelData(name:String, startframe:int) 
	{
		this.name = name;
		this.endframe = this.startframe = startframe;
	}

	/**
	 * Checks if this data is active at a certain frame
	 */
	public function isActiveAt(frame:int):Boolean
	{
		return this.startframe <= frame && frame <= this.endframe;
	}
	
	public function toString():String
	{
		return getClassName(this) + ", name: '" + this.name + "' frames: " + this.startframe + "-" + this.endframe;
	}
}