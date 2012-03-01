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
	import temple.core.debug.IDebuggable;
	import temple.core.display.CoreMovieClip;
	import temple.ui.buttons.behaviors.ButtonStateBehavior;
	import temple.ui.buttons.behaviors.ButtonTimelineBehavior;
	import temple.ui.buttons.behaviors.ButtonTimelinePlayMode;

	/**
	 * A MultiStateElement can be used inside a <code>MultiStateButton</code>. Is will automatically respond to the
	 * state of the <code>MultiStateButton</code> and will show the same state.
	 * 
	 * <p>A MultiStateElement can be nested inside objects which has a <code>ButtonBehavior</code>. Nesting means that
	 * it is placed on the timeline of an object. But also on the timeline of a child or grand-child of the object.
	 * There can be an unlimited amount of sub-children between the object and the MultiStateElement.</p>
	 * 
	 * <p>The Temple knows different kinds of buttons. Check out the 
	 * <a href="http://templelibrary.googlecode.com/svn/trunk/modules/ui/readme.html" target="_blank">button schema</a>
	 * in the UI Module of the Temple for a list of all available buttons which their features. </p>
	 * 
	 * @see temple.ui.buttons.behaviors.ButtonBehavior
	 * @see ../../../../readme.html
	 * 
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
