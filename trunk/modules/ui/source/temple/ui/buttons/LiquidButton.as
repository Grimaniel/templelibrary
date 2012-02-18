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
	import temple.ui.buttons.behaviors.ButtonBehavior;
	import temple.ui.buttons.behaviors.ButtonStateBehavior;
	import temple.ui.buttons.behaviors.ButtonTimelineBehavior;
	import temple.ui.layout.liquid.LiquidMovieClip;

	/**
	 * A button with built-in <code>LiquidBehavior</code>.
	 * 
	 * <p>The Temple knows different kinds of buttons. Check out the 
	 * <a href="http://templelibrary.googlecode.com/svn/trunk/modules/ui/readme.html" target="_blank">button schema</a>
	 * in the UI Module of the Temple for a list of all available buttons which their features. </p>
	 * 
	 * @see ../../../../readme.html
	 * @see temple.ui.layout.liquid.LiquidBehavior
	 * 
	 * @author Thijs Broerse
	 */
	public class LiquidButton extends LiquidMovieClip 
	{
		protected var _buttonBehavior:ButtonBehavior;
		protected var _timelineBehavior:ButtonTimelineBehavior;
		protected var _stateBehavior:ButtonStateBehavior;
		
		public function LiquidButton()
		{
			super();
			
			this.stop();
			
			this._buttonBehavior = new ButtonBehavior(this);
			if (this.totalFrames > 1) this._timelineBehavior = new ButtonTimelineBehavior(this);
			this._stateBehavior = new ButtonStateBehavior(this);
		}
		
		/**
		 * Returns a reference to the ButtonBehavior
		 */
		public function get buttonBehavior():ButtonBehavior
		{
			return this._buttonBehavior;
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
	}
}
