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

package temple.ui.scroll 
{
	import flash.events.Event;

	/**
	 * @author Thijs Broerse
	 */
	public class ScrollEvent extends Event 
	{
		/**
		 * Dispatched when the scrollable object is scrolled
		 */
		public static var SCROLL:String = "ScrollEvent.scroll";
		
		/**
		 * Dispatched by the scroll bar to scroll up one step
		 */
		public static var SCROLL_UP:String = "ScrollEvent.scrollUp";
		
		/**
		 * Dispatched by the scroll bar to scroll down one step
		 */
		public static var SCROLL_DOWN:String = "ScrollEvent.scrollDown";
		
		private var _scrollH:Number;
		private var _scrollV:Number;
		private var _maxScrollH:Number;
		private var _maxScrollV:Number;

		function ScrollEvent(type:String, scrollH:Number, scrollV:Number, maxScrollH:Number, maxScrollV:Number) 
		{
			super(type);
			
			_scrollH = scrollH;
			_scrollV = scrollV;
			_maxScrollH = maxScrollH;
			_maxScrollV = maxScrollV;
		}
		
		public function get scrollH():Number
		{
			return _scrollH;
		}
		
		public function get scrollV():Number
		{
			return _scrollV;
		}
		
		public function get maxScrollH():Number
		{
			return _maxScrollH;
		}
		
		public function get maxScrollV():Number
		{
			return _maxScrollV;
		}

		override public function clone():Event
		{
			return new ScrollEvent(type, scrollH, scrollV, maxScrollH, maxScrollV);
		}
	}
}
