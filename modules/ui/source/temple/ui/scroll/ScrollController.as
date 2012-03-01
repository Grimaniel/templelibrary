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
			this._scrollables = new Dictionary(useWeakReference);
			
			for each (var scrollable: IScrollable in args)
			{
				this.add(scrollable);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function get scrollH():Number
		{
			var scrollable:IScrollable;
			for (var key:Object in this._scrollables)
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
			for (var key:Object in this._scrollables)
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
			this._targetScrollH = value;
			var scrollable:IScrollable;
			for (var key:Object in this._scrollables)
			{
				scrollable = IScrollable(key);
				scrollable.scrollHTo(this._targetScrollH * scrollable.maxScrollH);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function get targetScrollH():Number
		{
			return this._targetScrollH;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get scrollV():Number
		{
			var scrollable:IScrollable;
			for (var key:Object in this._scrollables)
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
			for (var key:Object in this._scrollables)
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
			this._targetScrollV = value;
			var scrollable:IScrollable;
			for (var key:Object in this._scrollables)
			{
				scrollable = IScrollable(key);
				scrollable.scrollVTo(this._targetScrollV * scrollable.maxScrollV);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function get targetScrollV():Number
		{
			return this._targetScrollV;
		}
		
		/**
		 * Add an IScrollable to the ScrollController
		 */
		public function add(scrollable:IScrollable, useWeakReference:Boolean = true):void
		{
			if (scrollable == null) throwError(new TempleArgumentError(this, "scrollable can not be null"));
			
			if (ScrollController._dictionary[scrollable] == null) ScrollController._dictionary[scrollable] = new Array();
			(ScrollController._dictionary[scrollable] as Array).push(this);
			
			this._scrollables[scrollable] = this;
			
			scrollable.scrollH = this.scrollH;
			scrollable.scrollV = this.scrollV;
			
			scrollable.addEventListener(ScrollEvent.SCROLL, this.handleScroll, false, 0, useWeakReference);
			scrollable.addEventListener(DestructEvent.DESTRUCT, this.handleScrollableDestructed, false, 0, useWeakReference);
		}
		
		/**
		 * Remove an IScrollable from the ScrollController
		 */
		public function remove(scrollable:IScrollable):void
		{
			if (scrollable == null) throwError(new TempleArgumentError(this, "scrollable can not be null"));
			
			scrollable.removeEventListener(ScrollEvent.SCROLL, this.handleScroll);
			scrollable.removeEventListener(DestructEvent.DESTRUCT, this.handleScrollableDestructed);
			
			delete this._scrollables[scrollable];
			
			if (ScrollController._dictionary && ScrollController._dictionary[scrollable])
			{
				ArrayUtils.removeValueFromArray(ScrollController._dictionary[scrollable], this);
			}
		}
		
		private function handleScroll(event:ScrollEvent):void
		{
			if (this._blockRequest) return;
			
			this._blockRequest = true;
			
			var scrollable:IScrollable;
			for (var key:Object in this._scrollables)
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
			this._blockRequest = false;
			this.dispatchEvent(event.clone());
		}
		
		private function handleScrollableDestructed(event:DestructEvent):void
		{
			this.remove(event.target as IScrollable);
		}
	}
}
