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

package temple.ui.viewstack 
{
	import temple.core.display.CoreSprite;
	import temple.core.errors.TempleArgumentError;
	import temple.core.errors.throwError;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.FocusEvent;

	/**
	 * A ViewStack allows only one child to be visible at a time. If an other child must be visible, the current visible
	 * child is hidden.
	 * 
	 * @author Thijs Broerse
	 */
	public class ViewStack extends CoreSprite 
	{
		private var _selectedIndex:uint;
		private var _selectedChild:DisplayObject;
		private var _resizeToContent:Boolean;

		public function ViewStack()
		{
			// hide all, except 0
			var leni:int = numChildren;
			for (var i:int = 0; i < leni ; i++)
			{
				getChildAt(i).visible = i == _selectedIndex;
			}
			if (leni) _selectedChild = getChildAt(_selectedIndex);
			
			addEventListener(FocusEvent.FOCUS_IN, handleFocusIn);
		}

		override public function addChild(child:DisplayObject):DisplayObject
		{
			if (numChildren == 0)
			{
				child.visible = true;
				_selectedChild = child;
			}
			else
			{
				child.visible = false;
			}
			
			return super.addChild(child);
		}

		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			if (index == _selectedIndex)
			{
				_selectedChild.visible = false;
				_selectedChild = child;
				_selectedChild.visible = true;
			}
			else
			{
				child.visible = false;
			}
			
			return super.addChildAt(child, index);
		}

		/**
		 * @inheritDoc
		 * 
		 * If child is a button, it will automaticly be removed from the group
		 */
		override public function removeChild(child:DisplayObject):DisplayObject
		{
			var selectedIndex:uint = selectedIndex;
			
			resetIndex(child, selectedIndex);
			
			child = super.removeChild(child);
			
			return child;
		}

		/**
		 * @inheritDoc
		 * 
		 * If child is a button, it will automaticly be removed from the group
		 */
		override public function removeChildAt(index:int):DisplayObject
		{
			var selectedIndex:uint = selectedIndex;
			
			resetIndex(child, selectedIndex);
			
			var child:DisplayObject = super.removeChildAt(index);
			
			return child;
		}
		
		private function resetIndex(removedChild:DisplayObject, oldIndex:int):void
		{
			// do this first, because when changing the selected index the 'unselect' is called in this child which is removed
			
			if (oldIndex == getChildIndex(removedChild))
			{
				if (oldIndex > 0)
				{
					selectedIndex = oldIndex - 1;
				}
				else if (numChildren > 1)
				{
					selectedIndex = oldIndex + 1;
				}
			}
		}


		public function get selectedIndex():uint
		{
			return _selectedIndex;
		}
		
		public function set selectedIndex(value:uint):void
		{
			if (numChildren < value)
			{
				logError("selectedIndex: there is no child with index " + value);
			}
			else if (value != _selectedIndex)
			{
				// hide current
				_selectedChild.visible = false;
				
				_selectedIndex = value;
				_selectedChild = getChildAt(_selectedIndex);
				_selectedChild.visible = true;
				
				dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		public function get selected():DisplayObject
		{
			return getChildAt(_selectedIndex);
		}
		
		public function set selected(value:DisplayObject):void
		{
			if (value.parent != this)
			{
				throwError(new TempleArgumentError(this, "object '" + value + "' is not a child of '" + this + "'"));
			}
			selectedIndex = getChildIndex(value);
		}
		
		public function get resizeToContent():Boolean
		{
			return _resizeToContent;
		}
		
		public function set resizeToContent(value:Boolean):void
		{
			_resizeToContent = value;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get width():Number
		{
			return _resizeToContent && _selectedChild ? _selectedChild.width : super.width;
		}

		/**
		 * @inheritDoc
		 */
		override public function set width(value:Number):void
		{
			if (_resizeToContent)
			{
				var leni:int = numChildren;
				for (var i:int = 0; i < leni ; i++)
				{
					getChildAt(i).width = value;
				}
			}
			else
			{
				super.width = value;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get height():Number
		{
			return _resizeToContent && _selectedChild  ? _selectedChild.height : super.height;
		}

		/**
		 * @inheritDoc
		 */
		override public function set height(value:Number):void
		{
			if (_resizeToContent)
			{
				var leni:int = numChildren;
				for (var i:int = 0; i < leni ; i++)
				{
					getChildAt(i).height = value;
				}
			}
			else
			{
				super.height = value;
			}
		}
		
		private function handleFocusIn(event:FocusEvent):void 
		{
			var child:DisplayObject = selected;
			
			if (event.target == child || child is DisplayObjectContainer && (child as DisplayObjectContainer).contains(event.target as DisplayObject))
			{
				// focussed item is already selected, do nothing
			}
			else
			{
				var leni:int = numChildren;
				for (var i:int = 0; i < leni; i++)
				{
					child = getChildAt(i);
					if (event.target == child || child is DisplayObjectContainer && (child as DisplayObjectContainer).contains(event.target as DisplayObject))
					{
						selected = child;
					}
				}
			}
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			_selectedChild = null;
			
			super.destruct();
		}
	}
}
