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
			buttonMode = true;
			
			// set and hide hit area
			var hitArea:Sprite = getChildByName(BaseButton.hitAreaInstanceName) as Sprite;
			
			if (hitArea != null) 
			{
				hitArea = hitArea;
				hitArea.visible = false;
			}
			
			// don't handle mouse events on children
			mouseChildren = false;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set enabled(value:Boolean):void
		{
			mouseEnabled = super.enabled = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function enable():void
		{
			enabled = true;
		}
		
		/**
		 * @inheritDoc
		 */
		public function disable():void
		{
			enabled = false;
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			hitArea = null;
			
			super.destruct();
		}
	}
}
