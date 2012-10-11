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

package temple.ui.buttons.behaviors 
{
	import temple.core.errors.TempleError;
	import temple.core.errors.throwError;
	import temple.data.collections.HashMap;

	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;

	/**
	 * @eventType flash.events.Event.COMPLETE
	 */
	[Event(name = "complete", type = "flash.events.Event")]

	/**
	 * The ButtonTimelineBehavior usses the timeline of the button to display the state of the button.
	 * 
	 * <p>The ButtonTimelineBehavior does not manage the state of a button, this done by a <code>ButtonBehavior</code>.
	 * The <code>ButtonBehavior</code> dispatches a <code>ButtonEvent</code> every time the state of the button is
	 * changed. The <code>ButtonTimelineBehavior</code> listens for these event and show the timeline animation or frame
	 * based on the state of the button.</p>
	 * 
	 * <p>Use framelabels to define the specific states on the timeline. See <code>ButtonTimelineLabels</code> class for
	 * all possible labels. Every state has a 'show' label and and 'hide' label. Like 'in' is the show label for over
	 * and 'out' is the hide label. If you don't use a show and/or hide label for a state the timeline will be played
	 * forward (show) and backwards (hide).</p>
	 * 
	 * <p>If you do not use framelabels, the first frame of the timeline will be set as 'up' state, the last frame will
	 * be the 'over' state. The timeline will be player forward and backwords to toggle between these states.</p>
	 * 
	 * <p>It's possible to put multiple labels on a single frame. You need create a different layer for each label.</p>
	 * 
	 * @see temple.ui.buttons.behaviors.ButtonTimelineLabels
	 * @see temple.ui.buttons.behaviors.ButtonBehavior
	 * @see temple.ui.buttons.MultiStateButton
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
		
		private var _defaultPlayMode:ButtonTimelinePlayMode;
		private var _outPlayMode:ButtonTimelinePlayMode;
		private var _pressPlayMode:ButtonTimelinePlayMode;
		private var _releasePlayMode:ButtonTimelinePlayMode;
		private var _deselectPlayMode:ButtonTimelinePlayMode;
		private var _enablePlayMode:ButtonTimelinePlayMode;
		private var _blurPlayMode:ButtonTimelinePlayMode;
		
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
			
			if (ButtonTimelineBehavior._dictionary[target]) throwError(new TempleError(this, target + " already has ButtonTimelineBehavior"));
			
			ButtonTimelineBehavior._dictionary[target] = this;
			
			this.debug = debug;
			target.stop();
			this.initLabels();
			if (this._labels[ButtonTimelineLabels.INTRO])
			{
				this.preIntroState();
			}
			else
			{
				this.upState();
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
			
			if (this.debug) this.logDebug("update: selected=" + this.selected + ", disabled=" + this.disabled + ", over=" + this.over + ", down=" + this.down + ", focus=" + this.focus + ", currentLabel='" + this._currentLabel + "', currentFrame='" + this.movieClip.currentFrame + "'");
			
			switch (true)
			{
				case (this.selected && this._labels.hasOwnProperty(ButtonTimelineLabels.SELECTED)):
				{
					this.selectedState();
					break;
				}
				case this.disabled && this._labels.hasOwnProperty(ButtonTimelineLabels.DISABLED):
				{
					this.disabledState();
					break;
				}
				case this.down:
				{
					if (this._pressPlayMode == ButtonTimelinePlayMode.IMMEDIATELY || !this._pressPlayMode && this._defaultPlayMode == ButtonTimelinePlayMode.IMMEDIATELY)
					{
						this.downState();
					}
					else
					{
						switch (this._currentLabel)
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
					}
					break;
				}
				case this.over:
				{
					switch (this._currentLabel)
					{
						case ButtonTimelineLabels.IN:
						case ButtonTimelineLabels.OVER:
						{
							// do nothing
							break;
						}
						case ButtonTimelineLabels.SELECT:
						case ButtonTimelineLabels.SELECTED:
						{
							this.animateTo(ButtonTimelineLabels.SELECTED, ButtonTimelineLabels.DESELECT, ButtonTimelineLabels.OVER, ButtonTimelineLabels.SELECT, this._deselectPlayMode);
							break;
						}
						case ButtonTimelineLabels.PRESS:
						case ButtonTimelineLabels.DOWN:
						case ButtonTimelineLabels.RELEASE:
						{
							if (this.debug) this.logDebug("update from a down state");
							this.animateTo(ButtonTimelineLabels.DOWN, ButtonTimelineLabels.RELEASE, ButtonTimelineLabels.OVER, ButtonTimelineLabels.PRESS, this._releasePlayMode);
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
						switch (this._currentLabel)
						{
							case ButtonTimelineLabels.SELECT:
							case ButtonTimelineLabels.SELECTED:
							case ButtonTimelineLabels.DESELECT:
							{
								this.animateTo(ButtonTimelineLabels.SELECTED, ButtonTimelineLabels.DESELECT, ButtonTimelineLabels.FOCUSED, ButtonTimelineLabels.SELECT, this._deselectPlayMode);
								break;
							}
							case ButtonTimelineLabels.PRESS:
							case ButtonTimelineLabels.DOWN:
							case ButtonTimelineLabels.RELEASE:
							{
								if (this.debug) this.logDebug("update from a down state");
								this.animateTo(ButtonTimelineLabels.DOWN, ButtonTimelineLabels.RELEASE, ButtonTimelineLabels.FOCUSED, ButtonTimelineLabels.PRESS, this._releasePlayMode);
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
							this.animateTo(ButtonTimelineLabels.DOWN, ButtonTimelineLabels.RELEASE, ButtonTimelineLabels.OVER, ButtonTimelineLabels.PRESS, this._releasePlayMode);
							break;
						}
						case ButtonTimelineLabels.IN:
						case ButtonTimelineLabels.OVER:
						case ButtonTimelineLabels.OUT:
						{
							this.animateTo(ButtonTimelineLabels.OVER, ButtonTimelineLabels.OUT, ButtonTimelineLabels.UP, ButtonTimelineLabels.IN, this._outPlayMode);
							break;
						}
						case ButtonTimelineLabels.SELECT:
						case ButtonTimelineLabels.SELECTED:
						case ButtonTimelineLabels.DESELECT:
						{
							this.animateTo(ButtonTimelineLabels.SELECTED, ButtonTimelineLabels.DESELECT, ButtonTimelineLabels.UP, ButtonTimelineLabels.SELECT, this._deselectPlayMode);
							break;
						}
						case ButtonTimelineLabels.DISABLE:
						case ButtonTimelineLabels.DISABLED:
						case ButtonTimelineLabels.ENABLE:
						{
							this.animateTo(ButtonTimelineLabels.DISABLED, ButtonTimelineLabels.ENABLE, ButtonTimelineLabels.UP, ButtonTimelineLabels.DISABLE, this._enablePlayMode);
							break;
						}
						case ButtonTimelineLabels.FOCUS:
						case ButtonTimelineLabels.FOCUSED:
						case ButtonTimelineLabels.BLUR:
						{
							this.animateTo(ButtonTimelineLabels.FOCUSED, ButtonTimelineLabels.BLUR, ButtonTimelineLabels.UP, ButtonTimelineLabels.FOCUS, this._blurPlayMode);
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
		 * Define how the timeline should be played when the ButtonTimelineBehavior must go to an other label.
		 * 
		 * @see temple.ui.buttons.behaviors.ButtonTimelinePlayMode
		 */
		public function get playMode():ButtonTimelinePlayMode
		{
			return this._defaultPlayMode;
		}

		/**
		 * @private
		 */
		public function set playMode(value:*):void
		{
			this._defaultPlayMode = value as ButtonTimelinePlayMode || ButtonTimelinePlayMode.get(value);
		}
		
		/**
		 * Define how the out animation should be played when the ButtonTimelineBehavior must go to an other label.
		 * 
		 * @see temple.ui.buttons.behaviors.ButtonTimelinePlayMode
		 */
		public function get outPlayMode():ButtonTimelinePlayMode
		{
			return this._outPlayMode;
		}

		/**
		 * @private
		 */
		public function set outPlayMode(value:*):void
		{
			this._outPlayMode = value as ButtonTimelinePlayMode || ButtonTimelinePlayMode.get(value);
		}

		/**
		 * Define how the press animation should be played when the ButtonTimelineBehavior must go to an other label.
		 * 
		 * @see temple.ui.buttons.behaviors.ButtonTimelinePlayMode
		 */
		public function get pressPlayMode():ButtonTimelinePlayMode
		{
			return this._pressPlayMode;
		}

		/**
		 * @private
		 */
		public function set pressPlayMode(value:*):void
		{
			this._pressPlayMode = value as ButtonTimelinePlayMode || ButtonTimelinePlayMode.get(value);
		}

		/**
		 * Define how the release animation should be played when the ButtonTimelineBehavior must go to an other label.
		 * 
		 * @see temple.ui.buttons.behaviors.ButtonTimelinePlayMode
		 */
		public function get releasePlayMode():ButtonTimelinePlayMode
		{
			return this._releasePlayMode;
		}

		/**
		 * @private
		 */
		public function set releasePlayMode(value:*):void
		{
			this._releasePlayMode = value as ButtonTimelinePlayMode || ButtonTimelinePlayMode.get(value);
		}
		
		/**
		 * Define how the deselect animation should be played when the ButtonTimelineBehavior must go to an other label.
		 * 
		 * @see temple.ui.buttons.behaviors.ButtonTimelinePlayMode
		 */
		public function get deselectPlayMode():ButtonTimelinePlayMode
		{
			return this._deselectPlayMode;
		}

		/**
		 * @private
		 */
		public function set deselectPlayMode(value:*):void
		{
			this._deselectPlayMode = value as ButtonTimelinePlayMode || ButtonTimelinePlayMode.get(value);
		}

		/**
		 * Define how the enable animation should be played when the ButtonTimelineBehavior must go to an other label.
		 * 
		 * @see temple.ui.buttons.behaviors.ButtonTimelinePlayMode
		 */
		public function get enablePlayMode():ButtonTimelinePlayMode
		{
			return this._enablePlayMode;
		}

		/**
		 * @private
		 */
		public function set enablePlayMode(value:*):void
		{
			this._enablePlayMode = value as ButtonTimelinePlayMode || ButtonTimelinePlayMode.get(value);
		}

		/**
		 * Define how the blur animation should be played when the ButtonTimelineBehavior must go to an other label.
		 * 
		 * @see temple.ui.buttons.behaviors.ButtonTimelinePlayMode
		 */
		public function get blurPlayMode():ButtonTimelinePlayMode
		{
			return this._blurPlayMode;
		}

		/**
		 * @private
		 */
		public function set blurPlayMode(value:*):void
		{
			this._blurPlayMode = value as ButtonTimelinePlayMode || ButtonTimelinePlayMode.get(value);
		}


		/**
		 * Play the intro animation (if available).
		 */
		public function playIntro():void 
		{
			if (this.debug) this.logDebug("playIntro: ");
			
			if (this._labels[ButtonTimelineLabels.INTRO] && this._currentLabel == null)
			{
				this.preIntroState();
				this._currentLabel = ButtonTimelineLabels.INTRO;
				this.gotoFrame(FrameLabelData(this._labels[ButtonTimelineLabels.INTRO]).endframe);
			}
			else
			{
				this.logError("playIntro: no intro found");
			}
		}

		/**
		 * Play the outro animation (if available).
		 */
		public function playOutro():void 
		{
			if (this.debug) this.logDebug("playOutro: " + this._currentLabel);
			
			// if we have an 'intro' frame stop at the beginning of the intro frame and disable the button
			if (this._labels[ButtonTimelineLabels.OUTRO] && this._currentLabel != null)
			{
				this.disable();
				this._currentLabel = ButtonTimelineLabels.OUTRO;
				this.movieClip.gotoAndStop(ButtonTimelineLabels.OUTRO);
				this.gotoFrame(FrameLabelData(this._labels[ButtonTimelineLabels.OUTRO]).endframe);
			}
		}

		/**
		 * Returns the HashMap with all labels. Useful for debugging.
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
		
		private function animateTo(start:String, enter:String, goal:String, exit:String, playMode:ButtonTimelinePlayMode):void
		{
			playMode ||= this._defaultPlayMode || ButtonTimelinePlayMode.REVERSED;
			
			if (this.debug) this.logDebug("animateTo: start='" + start + "', enter='" + enter + "', goal='" + goal + "', exit='" + exit + "', playMode=" + playMode + ", currentFrame=" + this.movieClip.currentFrame + ", currentLabel='" + this._currentLabel + "'");
			
			if (!this._labels[goal])
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
				if (this._currentLabel == ButtonTimelineLabels.OVER && !this.over) this.update(this);
			}
			// check if we are currently in the exit state 
			else if (playMode != ButtonTimelinePlayMode.IMMEDIATELY && this._labels[exit] && FrameLabelData(this._labels[exit]).isActiveAt(this.movieClip.currentFrame))
			{
				// backwards?
				if (playMode == ButtonTimelinePlayMode.REVERSED)
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
			else if (this._labels[enter])
			{
				this._currentLabel = enter;
				
				if (this.debug) this.logDebug("animateTo: currentLabel='" + enter + "', currentFrame=" + this.movieClip.currentFrame);
				
				// check if enter is currently active
				if (!FrameLabelData(this._labels[enter]).isActiveAt(this.movieClip.currentFrame))
				{
					if (this.debug) this.logDebug("animateTo: goto '" + enter + "'");
					this.movieClip.gotoAndStop(enter);
				}
				this.gotoFrame(FrameLabelData(this._labels[enter]).endframe);
			}
			else
			{
				// just go to our goal
				if (this.debug) this.logDebug("animateTo: just go to our goal '" + goal + "'");
				this._currentLabel = goal;
				this.movieClip.removeEventListener(Event.ENTER_FRAME, this.handleEnterFrame);
				this.movieClip.gotoAndStop(FrameLabelData(this._labels[goal]).startframe);
				
				if (goal == ButtonTimelineLabels.OVER && !this.over) this.update(this);
			}
			// Force the stage to render
			new TimerEvent(TimerEvent.TIMER_COMPLETE).updateAfterEvent();
		}
		
		/**
		 * Shows the'up' state
		 */
		private function upState():void
		{
			if (this.debug) this.logDebug("upState");
			
			if (this.movieClip)
			{
				this._currentLabel = ButtonTimelineLabels.UP;
				this.movieClip.removeEventListener(Event.ENTER_FRAME, this.handleEnterFrame);
				this.movieClip.gotoAndStop(FrameLabelData(this._labels[ButtonTimelineLabels.UP]).startframe);
				new TimerEvent(TimerEvent.TIMER_COMPLETE).updateAfterEvent();
			}
		}

		private function overState():void
		{
			if (this.debug) this.logDebug("overState");
			this.animateTo(ButtonTimelineLabels.UP, ButtonTimelineLabels.IN, ButtonTimelineLabels.OVER, ButtonTimelineLabels.OUT, this._outPlayMode);
		}

		private function downState():void
		{
			if (this.debug) this.logDebug("downState");
			this.animateTo(ButtonTimelineLabels.OVER, ButtonTimelineLabels.PRESS, ButtonTimelineLabels.DOWN, ButtonTimelineLabels.RELEASE, this._pressPlayMode);
		}

		private function selectedState():void
		{
			if (this.debug) this.logDebug("selectedState");
			this.animateTo(ButtonTimelineLabels.UP, ButtonTimelineLabels.SELECT, ButtonTimelineLabels.SELECTED, ButtonTimelineLabels.DESELECT, this._deselectPlayMode);
		}
		
		private function disabledState():void
		{
			if (this.debug) this.logDebug("disabledState");
			this.animateTo(ButtonTimelineLabels.UP, ButtonTimelineLabels.DISABLE, ButtonTimelineLabels.DISABLED, ButtonTimelineLabels.ENABLE, this._enablePlayMode);
		}
		
		private function focusState():void
		{
			if (this.debug) this.logDebug("focusState");
			this.animateTo(ButtonTimelineLabels.UP, ButtonTimelineLabels.FOCUS, ButtonTimelineLabels.FOCUSED, ButtonTimelineLabels.BLUR, this._blurPlayMode);
		}

		private function preIntroState():void 
		{
			if (this.debug) this.logDebug("preIntroState: ");
			
			// if we have an 'intro' frame stop at the beginning of the intro frame and disable the button
			if (this._labels[ButtonTimelineLabels.INTRO])
			{
				this.disable();
				this._currentLabel = null;
				this.movieClip.gotoAndStop(ButtonTimelineLabels.INTRO);
			}
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
					
					switch (frameLabelData.name)
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
						case ButtonTimelineLabels.INTRO:
						case ButtonTimelineLabels.OUTRO:
						{
							j = 0;
							do
							{
								if (++j < length)
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
					if (this.debug) this.logDebug("initLabels: 'up' not found so first frame is used as 'up' state");
				}
				// since 'over' is mandatory, check for it and use 'up' if 'over' is not found
				if (!this._labels[ButtonTimelineLabels.OVER])
				{
					this._labels[ButtonTimelineLabels.OVER] = new FrameLabelData(ButtonTimelineLabels.OVER, FrameLabelData(this._labels[ButtonTimelineLabels.UP]).startframe);
				}
			}
			else
			{
				// no labels found. Use first frame as up and lastframe as 'over'
				this._labels[1] = this._labels[ButtonTimelineLabels.UP] = new FrameLabelData(ButtonTimelineLabels.UP, 1);
				this._labels[this.movieClip.totalFrames] = this._labels[ButtonTimelineLabels.OVER] = new FrameLabelData(ButtonTimelineLabels.OVER, this.movieClip.totalFrames);
			}
			
			if (this.debug) this.logInfo("Labels: " + dump(this._labels));
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
			if (this.debug) this.logDebug("animation done: currentLabel='" + this._currentLabel + "'");
			
			switch (this._currentLabel)
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
				case ButtonTimelineLabels.INTRO:
				{
					this.enable();
					this._currentLabel = ButtonTimelineLabels.UP;
					break;
				}
				case ButtonTimelineLabels.OUTRO:
				{
					this._currentLabel = null;
					// break
				}
			}
			this.movieClip.removeEventListener(Event.ENTER_FRAME, this.handleEnterFrame);
			
			if (this._currentLabel) this.movieClip.gotoAndStop(FrameLabelData(this._labels[this._currentLabel]).startframe);
				
			this.update(this);
			
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			if (this.target) delete ButtonTimelineBehavior._dictionary[this.target];
			
			if (this.movieClip)
			{
				this.movieClip.removeEventListener(Event.ENTER_FRAME, this.handleEnterFrame);
			}
			this._labels = null;
			this._defaultPlayMode = null;
			this._outPlayMode = null;
			this._pressPlayMode = null;
			this._releasePlayMode = null;
			this._deselectPlayMode = null;
			this._enablePlayMode = null;
			this._blurPlayMode = null;
			
			super.destruct();
		}
	}
}
import temple.core.debug.objectToString;

final class FrameLabelData
{
	private static const _TO_STRING_PROPS:Vector.<String> = Vector.<String>(['name', 'startframe', 'endframe']);
	
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
		return objectToString(this, _TO_STRING_PROPS);
	}
}