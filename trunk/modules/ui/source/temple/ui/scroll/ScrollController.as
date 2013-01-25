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
	import temple.core.destruction.DestructEvent;
	import temple.core.errors.TempleArgumentError;
	import temple.core.errors.throwError;
	import temple.core.events.CoreEventDispatcher;
	import temple.utils.types.ArrayUtils;

	import flash.utils.Dictionary;

	/**
	 * The ScrollController attaches multiple IScrollables together. Useful if you want to scroll multiple ScrollPanes with a single ScrollBar.
	 * 
	 * @author Thijs Broerse
	 */
	public class ScrollController extends CoreEventDispatcher implements IScrollable
	{
		private static const _dictionary:Dictionary = new Dictionary(true);
		

		/**
		 * Returns a list of all ScrollController of a IScrollable if the IScrollable has ScrollControllers. Otherwise null is returned.
		 */
		public static function getInstances(target:IScrollable):Array
		{
			return ScrollController._dictionary[target] as Array;
		}
		
		private var _blockRequest:Boolean;
		private var _targetScrollH:Number;
		private var _targetScrollV:Number;
		private var _scrollables:Dictionary;
		
		public function ScrollController(useWeakReference:Boolean = true, ...args)
		{
			_scrollables = new Dictionary(useWeakReference);
			
			for each (var scrollable: IScrollable in args)
			{
				add(scrollable);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function get scrollH():Number
		{
			var scrollable:IScrollable;
			for (var key:Object in _scrollables)
			{
				scrollable = IScrollable(key);
				return scrollable.maxScrollH ? scrollable.scrollH / scrollable.maxScrollH : 0;
			}
			return NaN;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set scrollH(value:Number):void
		{
			var scrollable:IScrollable;
			for (var key:Object in _scrollables)
			{
				scrollable = IScrollable(key);
				scrollable.scrollH = value * scrollable.maxScrollH;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function get maxScrollH():Number
		{
			return 1;
		}
		
		/**
		 * @inheritDoc
		 */
		public function scrollHTo(value:Number):void
		{
			_targetScrollH = value;
			var scrollable:IScrollable;
			for (var key:Object in _scrollables)
			{
				scrollable = IScrollable(key);
				scrollable.scrollHTo(_targetScrollH * scrollable.maxScrollH);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function get targetScrollH():Number
		{
			return _targetScrollH;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get scrollV():Number
		{
			var scrollable:IScrollable;
			for (var key:Object in _scrollables)
			{
				scrollable = IScrollable(key);
				return scrollable.maxScrollV ? scrollable.scrollV / scrollable.maxScrollV : 0;
			}
			return NaN;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set scrollV(value:Number):void
		{
			var scrollable:IScrollable;
			for (var key:Object in _scrollables)
			{
				scrollable = IScrollable(key);
				scrollable.scrollV = value * scrollable.maxScrollV;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function get maxScrollV():Number
		{
			return 1;
		}
		
		/**
		 * @inheritDoc
		 */
		public function scrollVTo(value:Number):void
		{
			_targetScrollV = value;
			var scrollable:IScrollable;
			for (var key:Object in _scrollables)
			{
				scrollable = IScrollable(key);
				scrollable.scrollVTo(_targetScrollV * scrollable.maxScrollV);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function get targetScrollV():Number
		{
			return _targetScrollV;
		}
		
		/**
		 * Add an IScrollable to the ScrollController
		 */
		public function add(scrollable:IScrollable, useWeakReference:Boolean = true):void
		{
			if (scrollable == null) throwError(new TempleArgumentError(this, "scrollable can not be null"));
			
			if (ScrollController._dictionary[scrollable] == null) ScrollController._dictionary[scrollable] = new Array();
			(ScrollController._dictionary[scrollable] as Array).push(this);
			
			_scrollables[scrollable] = this;
			
			scrollable.scrollH = scrollH;
			scrollable.scrollV = scrollV;
			
			scrollable.addEventListener(ScrollEvent.SCROLL, handleScroll, false, 0, useWeakReference);
			scrollable.addEventListener(DestructEvent.DESTRUCT, handleScrollableDestructed, false, 0, useWeakReference);
		}
		
		/**
		 * Remove an IScrollable from the ScrollController
		 */
		public function remove(scrollable:IScrollable):void
		{
			if (scrollable == null) throwError(new TempleArgumentError(this, "scrollable can not be null"));
			
			scrollable.removeEventListener(ScrollEvent.SCROLL, handleScroll);
			scrollable.removeEventListener(DestructEvent.DESTRUCT, handleScrollableDestructed);
			
			delete _scrollables[scrollable];
			
			if (ScrollController._dictionary && ScrollController._dictionary[scrollable])
			{
				ArrayUtils.removeValueFromArray(ScrollController._dictionary[scrollable], this);
			}
		}
		
		private function handleScroll(event:ScrollEvent):void
		{
			if (_blockRequest) return;
			
			_blockRequest = true;
			
			var scrollable:IScrollable;
			for (var key:Object in _scrollables)
			{
				scrollable = IScrollable(key);
				
				if (scrollable != event.target)
				{
					if (!isNaN(event.scrollH))
					{
						scrollable.scrollHTo(event.maxScrollH ? (event.scrollH / event.maxScrollH) * scrollable.maxScrollH : 0);
					}
					
					if (!isNaN(event.scrollV))
					{
						scrollable.scrollVTo(event.maxScrollV ? (event.scrollV / event.maxScrollV) * scrollable.maxScrollV : 0);
					}
				}
			}
			_blockRequest = false;
			dispatchEvent(event.clone());
		}
		
		private function handleScrollableDestructed(event:DestructEvent):void
		{
			remove(event.target as IScrollable);
		}
	}
}
