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
			var leni:int = this.numChildren;
			for (var i:int = 0; i < leni ; i++)
			{
				this.getChildAt(i).visible = i == this._selectedIndex;
			}
			if (leni) this._selectedChild = this.getChildAt(this._selectedIndex);
			
			this.addEventListener(FocusEvent.FOCUS_IN, this.handleFocusIn);
		}

		override public function addChild(child:DisplayObject):DisplayObject
		{
			if (this.numChildren == 0)
			{
				child.visible = true;
				this._selectedChild = child;
			}
			else
			{
				child.visible = false;
			}
			
			return super.addChild(child);
		}

		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			if (index == this._selectedIndex)
			{
				this._selectedChild.visible = false;
				this._selectedChild = child;
				this._selectedChild.visible = true;
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
			var selectedIndex:uint = this.selectedIndex;
			
			this.resetIndex(child, selectedIndex);
			
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
			var selectedIndex:uint = this.selectedIndex;
			
			this.resetIndex(child, selectedIndex);
			
			var child:DisplayObject = super.removeChildAt(index);
			
			return child;
		}
		
		private function resetIndex(removedChild:DisplayObject, oldIndex:int):void
		{
			// do this first, because when changing the selected index the 'unselect' is called in this child which is removed
			
			if (oldIndex == this.getChildIndex(removedChild))
			{
				if (oldIndex > 0)
				{
					this.selectedIndex = oldIndex - 1;
				}
				else if (this.numChildren > 1)
				{
					this.selectedIndex = oldIndex + 1;
				}
			}
		}


		public function get selectedIndex():uint
		{
			return this._selectedIndex;
		}
		
		public function set selectedIndex(value:uint):void
		{
			if (this.numChildren < value)
			{
				this.logError("selectedIndex: there is no child with index " + value);
			}
			else if (value != this._selectedIndex)
			{
				// hide current
				this._selectedChild.visible = false;
				
				this._selectedIndex = value;
				this._selectedChild = this.getChildAt(this._selectedIndex);
				this._selectedChild.visible = true;
				
				this.dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		public function get selected():DisplayObject
		{
			return this.getChildAt(this._selectedIndex);
		}
		
		public function set selected(value:DisplayObject):void
		{
			if (value.parent != this)
			{
				throwError(new TempleArgumentError(this, "object '" + value + "' is not a child of '" + this + "'"));
			}
			this.selectedIndex = this.getChildIndex(value);
		}
		
		public function get resizeToContent():Boolean
		{
			return this._resizeToContent;
		}
		
		public function set resizeToContent(value:Boolean):void
		{
			this._resizeToContent = value;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get width():Number
		{
			return this._resizeToContent && this._selectedChild ? this._selectedChild.width : super.width;
		}

		/**
		 * @inheritDoc
		 */
		override public function set width(value:Number):void
		{
			if (this._resizeToContent)
			{
				var leni:int = this.numChildren;
				for (var i:int = 0; i < leni ; i++)
				{
					this.getChildAt(i).width = value;
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
			return this._resizeToContent && this._selectedChild  ? this._selectedChild.height : super.height;
		}

		/**
		 * @inheritDoc
		 */
		override public function set height(value:Number):void
		{
			if (this._resizeToContent)
			{
				var leni:int = this.numChildren;
				for (var i:int = 0; i < leni ; i++)
				{
					this.getChildAt(i).height = value;
				}
			}
			else
			{
				super.height = value;
			}
		}
		
		private function handleFocusIn(event:FocusEvent):void 
		{
			var child:DisplayObject = this.selected;
			
			if (event.target == child || child is DisplayObjectContainer && (child as DisplayObjectContainer).contains(event.target as DisplayObject))
			{
				// focussed item is already selected, do nothing
			}
			else
			{
				var leni:int = this.numChildren;
				for (var i:int = 0; i < leni; i++)
				{
					child = this.getChildAt(i);
					if (event.target == child || child is DisplayObjectContainer && (child as DisplayObjectContainer).contains(event.target as DisplayObject))
					{
						this.selected = child;
					}
				}
			}
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			this._selectedChild = null;
			
			super.destruct();
		}
	}
}
