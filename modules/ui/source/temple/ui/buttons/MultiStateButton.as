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
		private var _debug:Boolean;

		public function MultiStateButton()
		{
			super();
			
			this.stop();
			
			this._buttonBehavior = new ButtonBehavior(this);
			if (this.totalFrames > 1) this._timelineBehavior = new ButtonTimelineBehavior(this);
			this._stateBehavior = new ButtonStateBehavior(this);
		}

		/**
		 * Returns a reference to the ButtonBehavior.
		 */
		public function get buttonBehavior():ButtonBehavior
		{
			return this._buttonBehavior;
		}

		/**
		 * Returns a reference to the ButtonTimelineBehavior.
		 */
		public function get buttonTimelineBehavior():ButtonTimelineBehavior
		{
			return this._timelineBehavior;
		}

		/**
		 * Returns a reference to the ButtonTimelineBehavior.
		 */
		public function get buttonStateBehavior():ButtonStateBehavior
		{
			return this._stateBehavior;
		}

		/**
		 * @inheritDoc
		 */
		[Inspectable(name="Enabled", type="Boolean", defaultValue="true")]
		override public function set enabled(value:Boolean):void
		{
			this.mouseEnabled = super.enabled = value;
			if (this._buttonBehavior) this._buttonBehavior.disabled = !value;
		}
		
		/**
		 * Get or set the delay before mouse over is performed, in milliseconds.
		 */
		public function get inDelay():Number
		{
			return this._buttonBehavior ? this._buttonBehavior.inDelay : NaN;
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="In delay", type="Number", defaultValue="0")]
		public function set inDelay(value:Number):void
		{
			if (this._buttonBehavior) this._buttonBehavior.inDelay = value;
		}
		
		/**
		 * (Hysteresis) delay before mouse out action is performed, in milliseconds.
		 */
		public function get outDelay():Number
		{
			return this._buttonBehavior ? this._buttonBehavior.outDelay : NaN;
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="Out delay", type="Number", defaultValue="0")]
		public function set outDelay(value:Number):void
		{
			if (this._buttonBehavior) this._buttonBehavior.outDelay = value;
		}

		/**
		 * Indicates if button should go in out state (true) when dragging (mouse out while mouse down) out the target
		 * If set to false, buttons stays in down state when dragging out. Default: true.
		 */
		public function get outOnDragOut():Boolean
		{
			return this._buttonBehavior ? this._buttonBehavior.outOnDragOut : false;
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="Out On DragOut", type="Boolean", defaultValue="true")]
		public function set outOnDragOut(value:Boolean):void
		{
			if (this._buttonBehavior) this._buttonBehavior.outOnDragOut = value;
		}
		
		/**
		 * Indicates if the ButtonBehavior should go in down state (true) when dragging (mouse in while mouse down) in the target.
		 */
		public function get downOnDragIn():Boolean
		{
			return this._buttonBehavior ? this._buttonBehavior.downOnDragIn : false;
		}

		/**
		 * @private
		 */
		[Inspectable(name="Down On DragIn", type="Boolean", defaultValue="false")]
		public function set downOnDragIn(value:Boolean):void
		{
			if (this._buttonBehavior) this._buttonBehavior.downOnDragIn = value;
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
			return this._timelineBehavior ? this._timelineBehavior.playMode : null;
		}

		/**
		 * @private
		 */
		[Inspectable(name="PlayMode", type="String", defaultValue="reversed", enumeration="reversed,continue,immediately")]
		public function set playMode(value:*):void
		{
			if (this._timelineBehavior) this._timelineBehavior.playMode = value;
		}

		/**
		 * Play the intro timeline animation of the button (if the button has one).
		 */
		public function playIntro():void 
		{
			if (this._timelineBehavior) this._timelineBehavior.playIntro();
		}

		/**
		 * Play the outro timeline animation of the button (if the button has one).
		 */
		public function playOutro():void 
		{
			if (this._timelineBehavior) this._timelineBehavior.playOutro();
		}

		/**
		 * @inheritDoc
		 */
		public function get focus():Boolean
		{
			return this._buttonBehavior ? this._buttonBehavior.focus : false;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set focus(value:Boolean):void
		{
			if (value == this.focus) return;
			
			if (value)
			{
				FocusManager.focus = this;
			}
			else if (this.focus)
			{
				FocusManager.focus = null;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function get updateByParent():Boolean
		{
			return this._stateBehavior && this._stateBehavior.updateByParent && this._timelineBehavior && this._timelineBehavior.updateByParent;
		}
		
		/**
		 * @inheritDoc
		 */
		[Inspectable(name="Update By Parent", type="Boolean", defaultValue="true")]
		public function set updateByParent(value:Boolean):void
		{
			if (this._stateBehavior) this._stateBehavior.updateByParent = value; 
			if (this._timelineBehavior) this._timelineBehavior.updateByParent = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get selected():Boolean
		{
			return this._buttonBehavior ? this._buttonBehavior.selected : false;
		}

		/**
		 * @inheritDoc
		 */
		public function set selected(value:Boolean):void
		{
			if (this._buttonBehavior && this._buttonBehavior.selected != value)
			{
				this._buttonBehavior.selected = value;
				this.dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		/**
		 * Indicates if the target should dispatch a CLICK event when the target has focus and the spacebar is pressed. Default: true
		 */
		public function get clickOnSpacebar():Boolean
		{
			return this._buttonBehavior.clickOnSpacebar;
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="Click on Spacebar", type="Boolean", defaultValue="false")]
		public function set clickOnSpacebar(value:Boolean):void
		{
			if (this._buttonBehavior) this._buttonBehavior.clickOnSpacebar = value;
		}
		
		/**
		 * Indicates if the target should dispatch a CLICK event when the target has focus and the spacebar is pressed. Default: true
		 */
		public function get clickOnEnter():Boolean
		{
			return this._buttonBehavior ? this._buttonBehavior.clickOnEnter : false;
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="Click on Enter", type="Boolean", defaultValue="false")]
		public function set clickOnEnter(value:Boolean):void
		{
			if (this._buttonBehavior) this._buttonBehavior.clickOnEnter = value;
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
		[Inspectable(name="Debug", type="Boolean", defaultValue="false")]
		public function set debug(value:Boolean):void
		{
			this._debug = value;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			this._buttonBehavior = null;
			this._timelineBehavior = null;
			this._stateBehavior = null;
			
			super.destruct();
		}
	}
}
