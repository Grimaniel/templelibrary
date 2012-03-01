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

package temple.ui.states 
{
	import temple.core.display.CoreMovieClip;
	import temple.core.errors.TempleError;
	import temple.core.errors.throwError;

	/**
	 * Abstract implementation of a state. This class must be extended
	 * 
	 * @author Thijs Broerse
	 */
	public class AbstractState extends CoreMovieClip implements IState 
	{
		protected var _shown:Boolean;
		
		public function AbstractState()
		{
			this.mouseEnabled = false;
			this.mouseChildren = false;
		}

		/**
		 * @inheritDoc
		 */
		public function show(instant:Boolean = false):void
		{
			throwError(new TempleError(this, "Abstract class, override this method"));
		}
		
		/**
		 * @inheritDoc
		 */
		public function hide(instant:Boolean = false):void
		{
			throwError(new TempleError(this, "Abstract class, override this method"));
		}
		
		/**
		 * @inheritDoc
		 */
		public function get shown():Boolean
		{
			return this._shown;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set shown(value:Boolean):void
		{
			if (value)
			{
				this.show();
			}
			else
			{
				this.hide();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function enable():void
		{
			this.enabled = true;
		}
		
		/**
		 * @inheritDoc
		 */
		public function disable():void
		{
			this.enabled = false;
		}
	}
}
