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
			initLabels();
			if (_labels[ButtonTimelineLabels.INTRO])
			{
				preIntroState();
			}
			else
			{
				upState();
			}
		}
		
		/**
		 * Returns a reference to the MovieClip. Same value as target, but typed as MovieClip
		 */
		public function get movieClip():MovieClip
		{
			return target as MovieClip;
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
					update(this);
				}
				else
				{
					movieClip.removeEventListener(Event.ENTER_FRAME, handleEnterFrame);
				}
			}
		}

		/**
		 * @inheritDoc
		 */
		override public function update(status:IButtonStatus):void
		{
			super.update(status);
			
			if (!enabled) return;
			
			if (debug) logDebug("update: selected=" + selected + ", disabled=" + disabled + ", over=" + over + ", down=" + down + ", focus=" + focus + ", currentLabel='" + _currentLabel + "', currentFrame='" + movieClip.currentFrame + "'");
			
			switch (true)
			{
				case (selected && _labels.hasOwnProperty(ButtonTimelineLabels.SELECTED)):
				{
					selectedState();
					break;
				}
				case disabled && _labels.hasOwnProperty(ButtonTimelineLabels.DISABLED):
				{
					disabledState();
					break;
				}
				case down:
				{
					if (_pressPlayMode == ButtonTimelinePlayMode.IMMEDIATELY || !_pressPlayMode && _defaultPlayMode == ButtonTimelinePlayMode.IMMEDIATELY)
					{
						downState();
					}
					else
					{
						switch (_currentLabel)
						{
							case ButtonTimelineLabels.UP:
							case ButtonTimelineLabels.IN:
							case ButtonTimelineLabels.OUT:
							{
								overState();
								break;
							}
							default:
							{
								downState();
								break;
							}
						}
					}
					break;
				}
				case over:
				{
					switch (_currentLabel)
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
							animateTo(ButtonTimelineLabels.SELECTED, ButtonTimelineLabels.DESELECT, ButtonTimelineLabels.OVER, ButtonTimelineLabels.SELECT, _deselectPlayMode);
							break;
						}
						case ButtonTimelineLabels.PRESS:
						case ButtonTimelineLabels.DOWN:
						case ButtonTimelineLabels.RELEASE:
						{
							if (debug) logDebug("update from a down state");
							animateTo(ButtonTimelineLabels.DOWN, ButtonTimelineLabels.RELEASE, ButtonTimelineLabels.OVER, ButtonTimelineLabels.PRESS, _releasePlayMode);
							break;
						}
						default:
						{
							overState();
							break;
						}
					}
					break;
				}
				case focus:
				{
					if (_labels[ButtonTimelineLabels.FOCUSED] || _labels[ButtonTimelineLabels.FOCUS])
					{
						switch (_currentLabel)
						{
							case ButtonTimelineLabels.SELECT:
							case ButtonTimelineLabels.SELECTED:
							case ButtonTimelineLabels.DESELECT:
							{
								animateTo(ButtonTimelineLabels.SELECTED, ButtonTimelineLabels.DESELECT, ButtonTimelineLabels.FOCUSED, ButtonTimelineLabels.SELECT, _deselectPlayMode);
								break;
							}
							case ButtonTimelineLabels.PRESS:
							case ButtonTimelineLabels.DOWN:
							case ButtonTimelineLabels.RELEASE:
							{
								if (debug) logDebug("update from a down state");
								animateTo(ButtonTimelineLabels.DOWN, ButtonTimelineLabels.RELEASE, ButtonTimelineLabels.FOCUSED, ButtonTimelineLabels.PRESS, _releasePlayMode);
								break;
							}
							default:
							{
								focusState();
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
					switch (_currentLabel)
					{
						case ButtonTimelineLabels.PRESS:
						case ButtonTimelineLabels.DOWN:
						case ButtonTimelineLabels.RELEASE:
						{
							animateTo(ButtonTimelineLabels.DOWN, ButtonTimelineLabels.RELEASE, ButtonTimelineLabels.OVER, ButtonTimelineLabels.PRESS, _releasePlayMode);
							break;
						}
						case ButtonTimelineLabels.IN:
						case ButtonTimelineLabels.OVER:
						case ButtonTimelineLabels.OUT:
						{
							animateTo(ButtonTimelineLabels.OVER, ButtonTimelineLabels.OUT, ButtonTimelineLabels.UP, ButtonTimelineLabels.IN, _outPlayMode);
							break;
						}
						case ButtonTimelineLabels.SELECT:
						case ButtonTimelineLabels.SELECTED:
						case ButtonTimelineLabels.DESELECT:
						{
							animateTo(ButtonTimelineLabels.SELECTED, ButtonTimelineLabels.DESELECT, ButtonTimelineLabels.UP, ButtonTimelineLabels.SELECT, _deselectPlayMode);
							break;
						}
						case ButtonTimelineLabels.DISABLE:
						case ButtonTimelineLabels.DISABLED:
						case ButtonTimelineLabels.ENABLE:
						{
							animateTo(ButtonTimelineLabels.DISABLED, ButtonTimelineLabels.ENABLE, ButtonTimelineLabels.UP, ButtonTimelineLabels.DISABLE, _enablePlayMode);
							break;
						}
						case ButtonTimelineLabels.FOCUS:
						case ButtonTimelineLabels.FOCUSED:
						case ButtonTimelineLabels.BLUR:
						{
							animateTo(ButtonTimelineLabels.FOCUSED, ButtonTimelineLabels.BLUR, ButtonTimelineLabels.UP, ButtonTimelineLabels.FOCUS, _blurPlayMode);
							break;
						}
						default:
						{
							upState();
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
			return _defaultPlayMode;
		}

		/**
		 * @private
		 */
		public function set playMode(value:*):void
		{
			_defaultPlayMode = value as ButtonTimelinePlayMode || ButtonTimelinePlayMode.get(value);
		}
		
		/**
		 * Define how the out animation should be played when the ButtonTimelineBehavior must go to an other label.
		 * 
		 * @see temple.ui.buttons.behaviors.ButtonTimelinePlayMode
		 */
		public function get outPlayMode():ButtonTimelinePlayMode
		{
			return _outPlayMode;
		}

		/**
		 * @private
		 */
		public function set outPlayMode(value:*):void
		{
			_outPlayMode = value as ButtonTimelinePlayMode || ButtonTimelinePlayMode.get(value);
		}

		/**
		 * Define how the press animation should be played when the ButtonTimelineBehavior must go to an other label.
		 * 
		 * @see temple.ui.buttons.behaviors.ButtonTimelinePlayMode
		 */
		public function get pressPlayMode():ButtonTimelinePlayMode
		{
			return _pressPlayMode;
		}

		/**
		 * @private
		 */
		public function set pressPlayMode(value:*):void
		{
			_pressPlayMode = value as ButtonTimelinePlayMode || ButtonTimelinePlayMode.get(value);
		}

		/**
		 * Define how the release animation should be played when the ButtonTimelineBehavior must go to an other label.
		 * 
		 * @see temple.ui.buttons.behaviors.ButtonTimelinePlayMode
		 */
		public function get releasePlayMode():ButtonTimelinePlayMode
		{
			return _releasePlayMode;
		}

		/**
		 * @private
		 */
		public function set releasePlayMode(value:*):void
		{
			_releasePlayMode = value as ButtonTimelinePlayMode || ButtonTimelinePlayMode.get(value);
		}
		
		/**
		 * Define how the deselect animation should be played when the ButtonTimelineBehavior must go to an other label.
		 * 
		 * @see temple.ui.buttons.behaviors.ButtonTimelinePlayMode
		 */
		public function get deselectPlayMode():ButtonTimelinePlayMode
		{
			return _deselectPlayMode;
		}

		/**
		 * @private
		 */
		public function set deselectPlayMode(value:*):void
		{
			_deselectPlayMode = value as ButtonTimelinePlayMode || ButtonTimelinePlayMode.get(value);
		}

		/**
		 * Define how the enable animation should be played when the ButtonTimelineBehavior must go to an other label.
		 * 
		 * @see temple.ui.buttons.behaviors.ButtonTimelinePlayMode
		 */
		public function get enablePlayMode():ButtonTimelinePlayMode
		{
			return _enablePlayMode;
		}

		/**
		 * @private
		 */
		public function set enablePlayMode(value:*):void
		{
			_enablePlayMode = value as ButtonTimelinePlayMode || ButtonTimelinePlayMode.get(value);
		}

		/**
		 * Define how the blur animation should be played when the ButtonTimelineBehavior must go to an other label.
		 * 
		 * @see temple.ui.buttons.behaviors.ButtonTimelinePlayMode
		 */
		public function get blurPlayMode():ButtonTimelinePlayMode
		{
			return _blurPlayMode;
		}

		/**
		 * @private
		 */
		public function set blurPlayMode(value:*):void
		{
			_blurPlayMode = value as ButtonTimelinePlayMode || ButtonTimelinePlayMode.get(value);
		}


		/**
		 * Play the intro animation (if available).
		 */
		public function playIntro():void 
		{
			if (debug) logDebug("playIntro: ");
			
			if (_labels[ButtonTimelineLabels.INTRO] && _currentLabel == null)
			{
				preIntroState();
				_currentLabel = ButtonTimelineLabels.INTRO;
				gotoFrame(FrameLabelData(_labels[ButtonTimelineLabels.INTRO]).endframe);
			}
			else
			{
				logError("playIntro: no intro found");
			}
		}

		/**
		 * Play the outro animation (if available).
		 */
		public function playOutro():void 
		{
			if (debug) logDebug("playOutro: " + _currentLabel);
			
			// if we have an 'intro' frame stop at the beginning of the intro frame and disable the button
			if (_labels[ButtonTimelineLabels.OUTRO] && _currentLabel != null)
			{
				disable();
				_currentLabel = ButtonTimelineLabels.OUTRO;
				movieClip.gotoAndStop(ButtonTimelineLabels.OUTRO);
				gotoFrame(FrameLabelData(_labels[ButtonTimelineLabels.OUTRO]).endframe);
			}
		}

		/**
		 * Returns the HashMap with all labels. Useful for debugging.
		 */
		public function get labels():HashMap
		{
			return _labels;
		}
		
		/**
		 * Returns the name of the current (or last reached) frame
		 */
		public function get currentLabel():String
		{
			return _currentLabel;
		}
		
		private function animateTo(start:String, enter:String, goal:String, exit:String, playMode:ButtonTimelinePlayMode):void
		{
			playMode ||= _defaultPlayMode || ButtonTimelinePlayMode.REVERSED;
			
			if (debug) logDebug("animateTo: start='" + start + "', enter='" + enter + "', goal='" + goal + "', exit='" + exit + "', playMode=" + playMode + ", currentFrame=" + movieClip.currentFrame + ", currentLabel='" + _currentLabel + "'");
			
			if (!_labels[goal])
			{
				if (debug) logWarn("MovieClip has no label '" + goal + "'");
				return;
			}
			// check if we are already on our goal
			else if (FrameLabelData(_labels[goal]).startframe == movieClip.currentFrame)
			{
				_currentLabel = goal;
				if (debug) logDebug("animateTo: goal '" + goal + "' reached");
				movieClip.removeEventListener(Event.ENTER_FRAME, handleEnterFrame);
				if (_currentLabel == ButtonTimelineLabels.OVER && !over) update(this);
			}
			// check if we are currently in the exit state 
			else if (playMode != ButtonTimelinePlayMode.IMMEDIATELY && _labels[exit] && FrameLabelData(_labels[exit]).isActiveAt(movieClip.currentFrame))
			{
				// backwards?
				if (playMode == ButtonTimelinePlayMode.REVERSED)
				{
					// ok, play backwards
					_currentLabel = goal;
					if (debug) logDebug("animateTo: play backwards");
					gotoFrame(FrameLabelData(_labels[exit]).startframe);
				}
				else
				{
					// do nothing
				}
			}
			// check if there are no enter and exit states, but we have a start
			else if (!_labels[enter] && !_labels[exit] && start && _labels[start])
			{
				// check if there are labels between the start and goal
				var found:Boolean;
				
				var frame:int = movieClip.currentFrame;
				var end:int = FrameLabelData(_labels[goal]).startframe;
				
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
					found = _labels.hasOwnProperty(frame) && frame != end;
				}
				while (!found && frame != end);
				
				if (debug) logDebug("animateTo: there are no labels '" + enter + "' and '" + exit + "', but we have '" + start + "', so animate between them");
				
				// check if we are currenlty between start and goal
				if (!found && !(movieClip.currentFrame < FrameLabelData(_labels[start]).startframe && movieClip.currentFrame < FrameLabelData(_labels[goal]).startframe) 
				&& !(movieClip.currentFrame > FrameLabelData(_labels[start]).startframe && movieClip.currentFrame > FrameLabelData(_labels[goal]).startframe))
				{
					_currentLabel = enter;
					gotoFrame(FrameLabelData(_labels[goal]).startframe);
				}
				else
				{
					_currentLabel = goal;
					movieClip.removeEventListener(Event.ENTER_FRAME, handleEnterFrame);
					movieClip.gotoAndStop(FrameLabelData(_labels[goal]).startframe);
				}
			}
			// check if we have an enter state
			else if (_labels[enter])
			{
				_currentLabel = enter;
				
				if (debug) logDebug("animateTo: currentLabel='" + enter + "', currentFrame=" + movieClip.currentFrame);
				
				// check if enter is currently active
				if (!FrameLabelData(_labels[enter]).isActiveAt(movieClip.currentFrame))
				{
					if (debug) logDebug("animateTo: goto '" + enter + "'");
					movieClip.gotoAndStop(enter);
				}
				gotoFrame(FrameLabelData(_labels[enter]).endframe);
			}
			else
			{
				// just go to our goal
				if (debug) logDebug("animateTo: just go to our goal '" + goal + "'");
				_currentLabel = goal;
				movieClip.removeEventListener(Event.ENTER_FRAME, handleEnterFrame);
				movieClip.gotoAndStop(FrameLabelData(_labels[goal]).startframe);
				
				if (goal == ButtonTimelineLabels.OVER && !over) update(this);
			}
			// Force the stage to render
			new TimerEvent(TimerEvent.TIMER_COMPLETE).updateAfterEvent();
		}
		
		/**
		 * Shows the'up' state
		 */
		private function upState():void
		{
			if (debug) logDebug("upState");
			
			if (movieClip)
			{
				_currentLabel = ButtonTimelineLabels.UP;
				movieClip.removeEventListener(Event.ENTER_FRAME, handleEnterFrame);
				movieClip.gotoAndStop(FrameLabelData(_labels[ButtonTimelineLabels.UP]).startframe);
				new TimerEvent(TimerEvent.TIMER_COMPLETE).updateAfterEvent();
			}
		}

		private function overState():void
		{
			if (debug) logDebug("overState");
			animateTo(ButtonTimelineLabels.UP, ButtonTimelineLabels.IN, ButtonTimelineLabels.OVER, ButtonTimelineLabels.OUT, _outPlayMode);
		}

		private function downState():void
		{
			if (debug) logDebug("downState");
			animateTo(ButtonTimelineLabels.OVER, ButtonTimelineLabels.PRESS, ButtonTimelineLabels.DOWN, ButtonTimelineLabels.RELEASE, _pressPlayMode);
		}

		private function selectedState():void
		{
			if (debug) logDebug("selectedState");
			animateTo(ButtonTimelineLabels.UP, ButtonTimelineLabels.SELECT, ButtonTimelineLabels.SELECTED, ButtonTimelineLabels.DESELECT, _deselectPlayMode);
		}
		
		private function disabledState():void
		{
			if (debug) logDebug("disabledState");
			animateTo(ButtonTimelineLabels.UP, ButtonTimelineLabels.DISABLE, ButtonTimelineLabels.DISABLED, ButtonTimelineLabels.ENABLE, _enablePlayMode);
		}
		
		private function focusState():void
		{
			if (debug) logDebug("focusState");
			animateTo(ButtonTimelineLabels.UP, ButtonTimelineLabels.FOCUS, ButtonTimelineLabels.FOCUSED, ButtonTimelineLabels.BLUR, _blurPlayMode);
		}

		private function preIntroState():void 
		{
			if (debug) logDebug("preIntroState: ");
			
			// if we have an 'intro' frame stop at the beginning of the intro frame and disable the button
			if (_labels[ButtonTimelineLabels.INTRO])
			{
				disable();
				_currentLabel = null;
				movieClip.gotoAndStop(ButtonTimelineLabels.INTRO);
			}
		}

		private function initLabels():void
		{
			_labels = new HashMap();
			
			if (movieClip.totalFrames < 2)
			{
				logWarn("MovieClip has no frames, ButtonTimelineBehavior is useless");
				_labels[1] = _labels[ButtonTimelineLabels.UP] = new FrameLabelData(ButtonTimelineLabels.UP, 1);
				return;
			}
			
			// sort labels on frame
			movieClip.currentScene.labels.sortOn("frame");
			var frameLabelData:FrameLabelData;
			var next:FrameLabel;
			var j:int;
			var length:int = movieClip.currentScene.labels.length;
			if (length)
			{
				for (var i:int = 0; i < length ; i++)
				{
					frameLabelData = new FrameLabelData(FrameLabel(movieClip.currentScene.labels[i]).name, FrameLabel(movieClip.currentScene.labels[i]).frame);
					
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
									next = FrameLabel(movieClip.currentScene.labels[i + j]);
								}
								else
								{
									next = null;
								}
							}
							while (next && next.frame == frameLabelData.startframe);
							
							frameLabelData.endframe = next ? next.frame - 1 : movieClip.totalFrames;
								
							if (debug) logDebug("initLabels: found label '" + frameLabelData.name + "', frames " + frameLabelData.startframe + "-" + frameLabelData.endframe);
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
							if (debug) logDebug("initLabels: found label '" + frameLabelData.name + "', frame " + frameLabelData.startframe);
							break;
						}	
						default:
						{
							logWarn("initLabels: found invalid label '" + frameLabelData.name + "' at frame " + frameLabelData.startframe);
							continue;
						}
					}
					_labels[frameLabelData.startframe] = _labels[frameLabelData.name] = frameLabelData;
				}
				// since 'up' is mandatory, check for it and use first frame if 'up' is not found
				if (!_labels[ButtonTimelineLabels.UP])
				{
					_labels[1] = _labels[ButtonTimelineLabels.UP] = new FrameLabelData(ButtonTimelineLabels.UP, 1);
					if (debug) logDebug("initLabels: 'up' not found so first frame is used as 'up' state");
				}
				// since 'over' is mandatory, check for it and use 'up' if 'over' is not found
				if (!_labels[ButtonTimelineLabels.OVER])
				{
					_labels[ButtonTimelineLabels.OVER] = new FrameLabelData(ButtonTimelineLabels.OVER, FrameLabelData(_labels[ButtonTimelineLabels.UP]).startframe);
				}
			}
			else
			{
				// no labels found. Use first frame as up and lastframe as 'over'
				_labels[1] = _labels[ButtonTimelineLabels.UP] = new FrameLabelData(ButtonTimelineLabels.UP, 1);
				_labels[movieClip.totalFrames] = _labels[ButtonTimelineLabels.OVER] = new FrameLabelData(ButtonTimelineLabels.OVER, movieClip.totalFrames);
			}
			
			if (debug) logInfo("Labels: " + dump(_labels));
		}
		
		private function gotoFrame(frame:int):void
		{
			if (debug) logDebug("gotoFrame: " + frame + ", currentFrame=" + movieClip.currentFrame);
			_targetFrame = frame;
			if (movieClip.currentFrame != _targetFrame)
			{
				movieClip.addEventListener(Event.ENTER_FRAME, handleEnterFrame);
			}
			else
			{
				onAnimationDone();
			}
		}
		
		private function handleEnterFrame(event:Event):void
		{
			if (_targetFrame == movieClip.currentFrame)
			{
				movieClip.removeEventListener(Event.ENTER_FRAME, handleEnterFrame);
				onAnimationDone();
			}
			else
			{
				moveToTarget();
			}
		}
		
		private function moveToTarget():void
		{
			if (movieClip.currentFrame < _targetFrame)
			{
				movieClip.nextFrame();
			}
			else if (movieClip.currentFrame > _targetFrame)
			{
				movieClip.prevFrame();
			}
		}

		private function onAnimationDone():void
		{
			if (debug) logDebug("animation done: currentLabel='" + _currentLabel + "'");
			
			switch (_currentLabel)
			{
				case ButtonTimelineLabels.IN:
				{
					_currentLabel = ButtonTimelineLabels.OVER;
					break;
				}
				case ButtonTimelineLabels.OUT:
				{
					_currentLabel = ButtonTimelineLabels.UP;
					break;
				}
				case ButtonTimelineLabels.PRESS:
				{
					_currentLabel = ButtonTimelineLabels.DOWN;
					break;
				}
				case ButtonTimelineLabels.SELECT:
				{
					_currentLabel = ButtonTimelineLabels.SELECTED;
					break;
				}
				case ButtonTimelineLabels.DISABLE:
				{
					_currentLabel = ButtonTimelineLabels.DISABLED;
					break;
				}
				case ButtonTimelineLabels.FOCUS:
				{
					_currentLabel = ButtonTimelineLabels.FOCUSED;
					break;
				}
				case ButtonTimelineLabels.RELEASE:
				{
					_currentLabel = ButtonTimelineLabels.OVER;
					break;
				}
				case ButtonTimelineLabels.DESELECT:
				case ButtonTimelineLabels.ENABLE:
				case ButtonTimelineLabels.BLUR:
				{
					_currentLabel = over ? ButtonTimelineLabels.OVER : ButtonTimelineLabels.UP;
					break;
				}
				case ButtonTimelineLabels.INTRO:
				{
					enable();
					_currentLabel = ButtonTimelineLabels.UP;
					break;
				}
				case ButtonTimelineLabels.OUTRO:
				{
					_currentLabel = null;
					// break
				}
			}
			movieClip.removeEventListener(Event.ENTER_FRAME, handleEnterFrame);
			
			if (_currentLabel) movieClip.gotoAndStop(FrameLabelData(_labels[_currentLabel]).startframe);
				
			update(this);
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			if (target) delete ButtonTimelineBehavior._dictionary[target];
			
			if (movieClip)
			{
				movieClip.removeEventListener(Event.ENTER_FRAME, handleEnterFrame);
			}
			_labels = null;
			_defaultPlayMode = null;
			_outPlayMode = null;
			_pressPlayMode = null;
			_releasePlayMode = null;
			_deselectPlayMode = null;
			_enablePlayMode = null;
			_blurPlayMode = null;
			
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
		endframe = this.startframe = startframe;
	}

	/**
	 * Checks if this data is active at a certain frame
	 */
	public function isActiveAt(frame:int):Boolean
	{
		return startframe <= frame && frame <= endframe;
	}
	
	public function toString():String
	{
		return objectToString(this, _TO_STRING_PROPS);
	}
}