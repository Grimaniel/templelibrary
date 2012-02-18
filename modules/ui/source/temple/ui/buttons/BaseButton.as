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
	import temple.core.display.CoreMovieClip;

	import flash.display.Sprite;


	/**
	 * Simple implementation of a button. Will give a <code>MovieClip</code> a hand cursor on mouse over.
	 * 
	 * <p>The Temple knows different kinds of buttons. Check out the 
	 * <a href="http://templelibrary.googlecode.com/svn/trunk/modules/ui/readme.html" target="_blank">button schema</a>
	 * in the UI Module of the Temple for a list of all available buttons which their features. </p>
	 * 
	 * @see ../../../../readme.html
	 * 
	 * @author Thijs Broerse
	 */
	public class BaseButton extends CoreMovieClip implements IEnableable
	{
		/**
		 * Instance name of a child which acts as hitArea for the button.
		 */
		public static var hitAreaInstanceName:String = "mcHitArea";
		
		public function BaseButton() 
		{
			// act as button
			this.buttonMode = true;
			
			// set and hide hit area
			var hitArea:Sprite = this.getChildByName(BaseButton.hitAreaInstanceName) as Sprite;
			
			if (hitArea != null) 
			{
				this.hitArea = hitArea;
				hitArea.visible = false;
			}
			
			// don't handle mouse events on children
			this.mouseChildren = false;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set enabled(value:Boolean):void
		{
			this.mouseEnabled = super.enabled = value;
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

		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			this.hitArea = null;
			
			super.destruct();
		}
	}
}
