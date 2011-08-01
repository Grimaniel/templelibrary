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
	import temple.core.CoreMovieClip;
	import temple.debug.IDebuggable;
	import temple.ui.buttons.behaviors.ButtonStateBehavior;
	import temple.ui.buttons.behaviors.ButtonTimelineBehavior;

	/**
	 * @author Thijs Broerse
	 */
	public class MultiStateElement extends CoreMovieClip implements IDebuggable
	{
		private var _timelineBehavior:ButtonTimelineBehavior;
		private var _stateBehavior:ButtonStateBehavior;
		private var _debug:Boolean;

		public function MultiStateElement()
		{
			super();
			
			this.stop();
			
			if (this.totalFrames > 1) this._timelineBehavior = new ButtonTimelineBehavior(this);
			this._stateBehavior = new ButtonStateBehavior(this);
		}
		
		/**
		 * Returns a reference to the ButtonTimelineBehavior
		 */
		public function get buttonTimelineBehavior():ButtonTimelineBehavior
		{
			return this._timelineBehavior;
		}

		/**
		 * Returns a reference to the ButtonTimelineBehavior
		 */
		public function get buttonStateBehavior():ButtonStateBehavior
		{
			return this._stateBehavior;
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
			if (this._timelineBehavior) this._timelineBehavior.playBackwardsBeforeOver = value;
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
			if (this._timelineBehavior) this._timelineBehavior.playBackwardsBeforeDown = value;
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
			if (this._timelineBehavior) this._timelineBehavior.playBackwardsBeforeSelected = value;
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
			if (this._timelineBehavior) this._timelineBehavior.playBackwardsBeforeSelected = value;
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
			if (this._timelineBehavior) this._timelineBehavior.debug = value;
			if (this._stateBehavior) this._stateBehavior.debug = value;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			this._timelineBehavior = null;
			this._stateBehavior = null;
			
			super.destruct();
		}
	}
}
