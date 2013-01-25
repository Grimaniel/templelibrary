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

package temple.ui.buttons 
{
	import temple.common.interfaces.IEnableable;
	import temple.common.interfaces.IFocusable;
	import temple.common.interfaces.ISelectable;
	import temple.core.debug.IDebuggable;
	import temple.ui.buttons.behaviors.ButtonBehavior;
	import temple.ui.buttons.behaviors.ButtonStateBehavior;
	import temple.ui.buttons.behaviors.ButtonTimelineBehavior;
	import temple.ui.buttons.behaviors.ButtonTimelinePlayMode;
	import temple.ui.buttons.behaviors.INestableButton;
	import temple.ui.focus.FocusManager;

	import flash.events.Event;


	/**
	 * @eventType temple.ui.buttons.behaviors.ButtonEvent.UPDATE
	 */
	[Event(name = "ButtonEvent.update", type = "temple.ui.buttons.behaviors.ButtonEvent")]
	
	/**
	 * A MultiStateButton is a <code>MovieClip</code> which automatically set mouse-over and mouse-down  effects/animation,
	 * based on framelabels on the timeline or state clips on the display list.
	 * 
	 * <p>You can easily create up-states, over-states, down-states etc. by placing framelabels on the timeline.
	 * A MultiStateButton knows the following statuses:</p>
	 * 
	 * <ul>
	 * 	<li><strong><code>up</code></strong>: 
	 * 	This is the normal status, when a mouse doesn't run over the button and the mouse isn't clicked on. </li>
	 * 	
	 * 	<li><strong><code>over</code></strong>: 
	 * 	When a mouse runs over the button, but isn't clicked on. </li>
	 * 	
	 * 	<li><strong><code>down</code></strong>: 
	 * 	When a mouse presses the button. </li>
	 * 	
	 * 	<li><strong><code>selected</code></strong>: 
	 * 	This is when the button is selected. This state can only be set by code.</li>
	 * 	
	 * 	<li><strong><code>disabled</code></strong>:
	 * 	This is when a button is set to disabeled (not-working). Use code to disable the MultiStateButton.</li>
	 * 	
	 * 	<li><strong><code>focused</code></strong>:
	 * 	When you have clicked on the button, the button will get focus until you have click on something else.</li>
	 * 	</ul>
	 * 
	 * <p>All logic of the MultiStateButton is handled by behaviors. Therefor it's easy to add these logic to other
	 * class which doesn't extends the MultiStateButton, just by added these behaviors.
	 * The state (<code>over</code>, <code>down</code>, <code>selected</code> and <code>disabled</code>) is managed by
	 * the <code>ButtonBehavior</code>. The <code>ButtonBehavior</code> dispatches a
	 * <code>ButtonEvent</code> every time the state of the button is changed.
	 * The <code>ButtonTimelineBehavior</code> listens for these <code>ButtonEvents</code> and plays the timeline
	 * animation corresponding the this new state.
	 * The <code>ButtonStateBehavior</code> also listens for these <code>ButtonEvents</code> and searches the display
	 * list of the button for children with a specific <code>IState</code>. And shows or hides these children, based 
	 * on the state of the button.
	 * </p>
	 * 
	 * <p>The Temple knows different kinds of buttons. Check out the 
	 * <a href="http://templelibrary.googlecode.com/svn/trunk/modules/ui/readme.html" target="_blank">button schema</a>
	 * in the UI Module of the Temple for a list of all available buttons which their features. </p>
	 * 
	 * <p>This class is based on the MultiStateButton of Eric Paul Lecluse (http://epologee.com/)</p>
	 * 
	 * @see temple.ui.buttons.behaviors.ButtonTimelineLabels
	 * @see temple.ui.buttons.behaviors.ButtonBehavior
	 * @see temple.ui.buttons.behaviors.ButtonTimelineBehavior
	 * @see temple.ui.buttons.behaviors.ButtonStateBehavior
	 * @see ../../../../readme.html
	 * 
	 * @author Thijs Broerse
	 * 
	 * @includeExample MultiStateButtonFrameLabelsExample.as
	 * @includeExample behaviors/NestedMultiStateButtonsExample.as
	 */
	public class MultiStateButton extends BaseButton implements IDebuggable, IEnableable, IFocusable, INestableButton, ISelectable
	{
		private var _buttonBehavior:ButtonBehavior;
		private var _timelineBehavior:ButtonTimelineBehavior;
		private var _stateBehavior:ButtonStateBehavior;

		public function MultiStateButton()
		{
			super();
			
			stop();
			
			_buttonBehavior = new ButtonBehavior(this);
			if (totalFrames > 1) _timelineBehavior = new ButtonTimelineBehavior(this);
			_stateBehavior = new ButtonStateBehavior(this);
		}

		/**
		 * Returns a reference to the ButtonBehavior.
		 */
		public function get buttonBehavior():ButtonBehavior
		{
			return _buttonBehavior;
		}

		/**
		 * Returns a reference to the ButtonTimelineBehavior.
		 */
		public function get buttonTimelineBehavior():ButtonTimelineBehavior
		{
			return _timelineBehavior;
		}

		/**
		 * Returns a reference to the ButtonTimelineBehavior.
		 */
		public function get buttonStateBehavior():ButtonStateBehavior
		{
			return _stateBehavior;
		}

		/**
		 * @inheritDoc
		 */
		[Inspectable(name="Enabled", type="Boolean", defaultValue="true")]
		override public function set enabled(value:Boolean):void
		{
			mouseEnabled = super.enabled = value;
			if (_buttonBehavior) _buttonBehavior.disabled = !value;
		}
		
		/**
		 * Get or set the delay before mouse over is performed, in milliseconds.
		 */
		public function get inDelay():Number
		{
			return _buttonBehavior ? _buttonBehavior.inDelay : NaN;
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="In delay", type="Number", defaultValue="0")]
		public function set inDelay(value:Number):void
		{
			if (_buttonBehavior) _buttonBehavior.inDelay = value;
		}
		
		/**
		 * (Hysteresis) delay before mouse out action is performed, in milliseconds.
		 */
		public function get outDelay():Number
		{
			return _buttonBehavior ? _buttonBehavior.outDelay : NaN;
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="Out delay", type="Number", defaultValue="0")]
		public function set outDelay(value:Number):void
		{
			if (_buttonBehavior) _buttonBehavior.outDelay = value;
		}

		/**
		 * Indicates if button should go in out state (true) when dragging (mouse out while mouse down) out the target
		 * If set to false, buttons stays in down state when dragging out. Default: true.
		 */
		public function get outOnDragOut():Boolean
		{
			return _buttonBehavior ? _buttonBehavior.outOnDragOut : false;
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="Out On DragOut", type="Boolean", defaultValue="true")]
		public function set outOnDragOut(value:Boolean):void
		{
			if (_buttonBehavior) _buttonBehavior.outOnDragOut = value;
		}
		
		/**
		 * Indicates if the ButtonBehavior should go in down state (true) when dragging (mouse in while mouse down) in the target.
		 */
		public function get downOnDragIn():Boolean
		{
			return _buttonBehavior ? _buttonBehavior.downOnDragIn : false;
		}

		/**
		 * @private
		 */
		[Inspectable(name="Down On DragIn", type="Boolean", defaultValue="false")]
		public function set downOnDragIn(value:Boolean):void
		{
			if (_buttonBehavior) _buttonBehavior.downOnDragIn = value;
		}
		
		/**
		 * Define how the timeline should be played when the ButtonTimelineBehavior must go to an other label.
		 * More specific playModes for every state can be set on the buttonTimelineBehavior 
		 * 
		 * @see temple.ui.buttons.behaviors.ButtonTimelinePlayMode
		 * @see temple.ui.buttons.behaviors.ButtonTimelineBehavior
		 */
		public function get playMode():ButtonTimelinePlayMode
		{
			return _timelineBehavior ? _timelineBehavior.playMode : null;
		}

		/**
		 * @private
		 */
		[Inspectable(name="PlayMode", type="String", defaultValue="reversed", enumeration="reversed,continue,immediately")]
		public function set playMode(value:*):void
		{
			if (_timelineBehavior) _timelineBehavior.playMode = value;
		}

		/**
		 * Play the intro timeline animation of the button (if the button has one).
		 */
		public function playIntro():void 
		{
			if (_timelineBehavior) _timelineBehavior.playIntro();
		}

		/**
		 * Play the outro timeline animation of the button (if the button has one).
		 */
		public function playOutro():void 
		{
			if (_timelineBehavior) _timelineBehavior.playOutro();
		}

		/**
		 * @inheritDoc
		 */
		public function get focus():Boolean
		{
			return _buttonBehavior ? _buttonBehavior.focus : false;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set focus(value:Boolean):void
		{
			if (value == focus) return;
			
			if (value)
			{
				FocusManager.focus = this;
			}
			else if (focus)
			{
				FocusManager.focus = null;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function get updateByParent():Boolean
		{
			return _stateBehavior && _stateBehavior.updateByParent && _timelineBehavior && _timelineBehavior.updateByParent;
		}
		
		/**
		 * @inheritDoc
		 */
		[Inspectable(name="Update By Parent", type="Boolean", defaultValue="true")]
		public function set updateByParent(value:Boolean):void
		{
			if (_stateBehavior) _stateBehavior.updateByParent = value; 
			if (_timelineBehavior) _timelineBehavior.updateByParent = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get selected():Boolean
		{
			return _buttonBehavior ? _buttonBehavior.selected : false;
		}

		/**
		 * @inheritDoc
		 */
		public function set selected(value:Boolean):void
		{
			if (_buttonBehavior && _buttonBehavior.selected != value)
			{
				_buttonBehavior.selected = value;
				dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		/**
		 * Indicates if the target should dispatch a CLICK event when the target has focus and the spacebar is pressed. Default: true
		 */
		public function get clickOnSpacebar():Boolean
		{
			return _buttonBehavior.clickOnSpacebar;
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="Click on Spacebar", type="Boolean", defaultValue="false")]
		public function set clickOnSpacebar(value:Boolean):void
		{
			if (_buttonBehavior) _buttonBehavior.clickOnSpacebar = value;
		}
		
		/**
		 * Indicates if the target should dispatch a CLICK event when the target has focus and the spacebar is pressed. Default: true
		 */
		public function get clickOnEnter():Boolean
		{
			return _buttonBehavior ? _buttonBehavior.clickOnEnter : false;
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="Click on Enter", type="Boolean", defaultValue="false")]
		public function set clickOnEnter(value:Boolean):void
		{
			if (_buttonBehavior) _buttonBehavior.clickOnEnter = value;
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			_buttonBehavior = null;
			_timelineBehavior = null;
			_stateBehavior = null;
			
			super.destruct();
		}
	}
}
