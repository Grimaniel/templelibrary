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

package temple.ui.buttons 
{
	import temple.ui.buttons.behaviors.INestableButton;
	import temple.debug.IDebuggable;
	import temple.ui.IEnableable;
	import temple.ui.buttons.BaseButton;
	import temple.ui.buttons.behaviors.ButtonBehavior;
	import temple.ui.buttons.behaviors.ButtonStateBehavior;
	import temple.ui.buttons.behaviors.ButtonTimelineBehavior;
	import temple.ui.focus.FocusManager;
	import temple.ui.focus.IFocusable;

	/**
	 * @eventType temple.ui.buttons.behaviors.ButtonEvent.UPDATE
	 */
	[Event(name = "ButtonEvent.update", type = "temple.ui.buttons.behaviors.ButtonEvent")]
	
	/**
	 * A MultiStateButton is a MovieClip which automaticly set mouse-over and mouse-down  effects/animation, based on framelabels on the timeline, or state clips on the display list.
	 * 
	 * <p>You can easily create up-states, over-states, down-states etc. by placing framelabels on the timeline.</p>
	 * 
	 * @see temple.ui.buttons.behaviors.ButtonTimelineLabels
	 * @see temple.ui.buttons.behaviors.ButtonTimelineBehavior
	 * @see temple.ui.buttons.behaviors.ButtonStateBehavior
	 * 
	 * @author Thijs Broerse
	 * 
	 * @includeExample MultiStateButtonFrameLabelsExample.as
	 * @includeExample behaviors/NestedMultiStateButtonsExample.as
	 */
	public class MultiStateButton extends BaseButton implements IDebuggable, IEnableable, IFocusable, INestableButton
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
			if(this.totalFrames > 1) this._timelineBehavior = new ButtonTimelineBehavior(this);
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
			this._buttonBehavior.disabled = !value;
		}
		
		/**
		 * Get or set the delay before mouse over is performed, in miliseconds.
		 */
		public function get inDelay():Number
		{
			return this._buttonBehavior.inDelay;
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="In delay", type="Number", defaultValue="0")]
		public function set inDelay(value:Number):void
		{
			this._buttonBehavior.inDelay = value;
		}
		
		/**
		 * (Hysteresis) delay before mouse out action is performed, in miliseconds.
		 */
		public function get outDelay():Number
		{
			return this._buttonBehavior.outDelay;
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="Out delay", type="Number", defaultValue="0")]
		public function set outDelay(value:Number):void
		{
			this._buttonBehavior.outDelay = value;
		}

		/**
		 * Indicates if button should go in out state (true) when dragging (mouse out while mouse down) out the target
		 * If set to false, buttons stays in down state when dragging out. Default: true.
		 */
		public function get outOnDragOut():Boolean
		{
			return this._buttonBehavior.outOnDragOut;
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="Out On DragOut", type="Boolean", defaultValue="true")]
		public function set outOnDragOut(value:Boolean):void
		{
			this._buttonBehavior.outOnDragOut = value;
		}
		
		/**
		 * Indicates if the animation should play the 'in' animation backwards (true) when the 'over' state is not reached.
		 * Otherwise (false) animation continues to 'over' state and that does 'out' state. Default: true.
		 */
		public function get playBackwardsBeforeOver():Boolean
		{
			return this._timelineBehavior ? this._timelineBehavior.playBackwardsBeforeOver : false;
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="Play Backwards Before Over", type="Boolean", defaultValue="true")]
		public function set playBackwardsBeforeOver(value:Boolean):void
		{
			if(this._timelineBehavior) this._timelineBehavior.playBackwardsBeforeOver = value;
		}
		
		/**
		 * Indicates if the animation should play the 'press' animation backwards (true) when the 'down' state is not reached.
		 * Otherwise (false) animation continues to 'down' state and that does 'release' state. Default: true.
		 */
		public function get playBackwardsBeforeDown():Boolean
		{
			return this._timelineBehavior ? this._timelineBehavior.playBackwardsBeforeDown : false;
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="Play Backwards Before Down", type="Boolean", defaultValue="true")]
		public function set playBackwardsBeforeDown(value:Boolean):void
		{
			if(this._timelineBehavior) this._timelineBehavior.playBackwardsBeforeDown = value;
		}

		/**
		 * Indicates if the animation should play the 'select' animation backwards (true) when the 'selected' state is not reached.
		 * Otherwise (false) animation continues to 'selected' state and that does 'deselect' state. Default: true.
		 */
		public function get playBackwardsBeforeSelected():Boolean
		{
			return this._timelineBehavior ? this._timelineBehavior.playBackwardsBeforeSelected : false;
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="Play Backwards Before Selected", type="Boolean", defaultValue="true")]
		public function set playBackwardsBeforeSelected(value:Boolean):void
		{
			if(this._timelineBehavior) this._timelineBehavior.playBackwardsBeforeSelected = value;
		}

		/**
		 * Indicates if the animation should play the 'disable' animation backwards (true) when the 'disabled' state is not reached,
		 * otherwise (false) animation continues to 'disabled' state and that does 'enable' state. Default: true.
		 */
		public function get playBackwardsBeforeDisabled():Boolean
		{
			return this._timelineBehavior ? this._timelineBehavior.playBackwardsBeforeDisabled : false;
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="Play Backwards Before Disabled", type="Boolean", defaultValue="true")]
		public function set playBackwardsBeforeDisabled(value:Boolean):void
		{
			if(this._timelineBehavior) this._timelineBehavior.playBackwardsBeforeSelected = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get focus():Boolean
		{
			return this._buttonBehavior.focus;
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
			return this._stateBehavior.updateByParent && this._timelineBehavior.updateByParent;
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
