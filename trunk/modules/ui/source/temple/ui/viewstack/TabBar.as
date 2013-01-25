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
	import temple.common.interfaces.ISelectable;
	import temple.core.display.ICoreDisplayObject;
	import temple.ui.form.components.RadioButtonGroup;
	import temple.ui.layout.ILayoutContainer;
	import temple.ui.layout.LayoutBehavior;

	import flash.display.DisplayObject;

	/**
	 * Class for creating a navigation tab bar.
	 * 
	 * @author Thijs Broerse
	 */
	public class TabBar extends RadioButtonGroup implements ILayoutContainer
	{
		private var _layoutBehavior:LayoutBehavior;

		public function TabBar(autoLayout:Boolean = false)
		{
			super();
			
			if (autoLayout) _layoutBehavior = new LayoutBehavior(this);
			
			var leni:int = numChildren;
			var child:ICoreDisplayObject;
			
			for (var i : int = 0; i < leni; i++)
			{
				child = ICoreDisplayObject(getChildAt(i));
				if (child is ISelectable) radioGroup.add(ISelectable(child), child, radioGroup.items.length == 0);
			}
		}

		/**
		 * @inheritDoc
		 * 
		 * If child is a button, it will automaticly be added to the group
		 */
		override public function addChild(child:DisplayObject):DisplayObject
		{
			super.addChild(child);
			if (child is ISelectable) radioGroup.add(ISelectable(child), child, radioGroup.items.length == 0);
			return child;
		}

		/**
		 * @inheritDoc
		 * 
		 * If child is a button, it will automaticly be added to the group
		 */
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			super.addChildAt(child, index);
			if (child is ISelectable) radioGroup.add(ISelectable(child), child, radioGroup.items.length == 0);
			return child;
		}

		/**
		 * @inheritDoc
		 * 
		 * If child is a button, it will automaticly be removed from the group
		 */
		override public function removeChild(child:DisplayObject):DisplayObject
		{
			var selectedIndex:uint = selectedIndex;
			if (child is ISelectable && radioGroup) radioGroup.remove(ISelectable(child));
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
			if (index < numChildren && getChildAt(index) is ISelectable) radioGroup.remove(ISelectable(getChildAt(index)));
			resetIndex(child, selectedIndex);
			var child:DisplayObject = super.removeChildAt(index);
			return child;
		}
		
		public function get selectedIndex():uint
		{
			return radioGroup && radioGroup.value ? uint(getChildIndex(radioGroup.value)) : 0;
		}

		public function set selectedIndex(value:uint):void
		{
			if (value >= numChildren) return;
			
			radioGroup.setValue(getChildAt(value));
		}
		
		/**
		 * 
		 */
		public function get autoLayout():Boolean
		{
			return _layoutBehavior ? _layoutBehavior.enabled : false;
		}
		
		/**
		 * @private
		 */
		public function set autoLayout(value:Boolean):void
		{
			if (_layoutBehavior)
			{
				_layoutBehavior.enabled = value;
			}
			else if (value)
			{
				_layoutBehavior = new LayoutBehavior(this);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function get orientation():String
		{
			return _layoutBehavior ? _layoutBehavior.orientation : null;;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set orientation(value:String):void
		{
			autoLayout = true;
			_layoutBehavior.orientation = value;
		}

		/**
		 * @inheritDoc
		 */
		public function get direction():String
		{
			return _layoutBehavior ? _layoutBehavior.direction : null;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set direction(value:String):void
		{
			autoLayout = true;
			_layoutBehavior.direction = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get spacing():Number
		{
			return _layoutBehavior ? _layoutBehavior.spacing : NaN;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set spacing(value:Number):void
		{
			autoLayout = true;
			_layoutBehavior.spacing = value;
		}
		
		/**
		 * Returns a reverense to the LayoutBehavior
		 */
		public function get layoutBehavior():LayoutBehavior
		{
			return _layoutBehavior;
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
		
		/**
		 * Returns a reverense to the LayoutBehavior
		 */
		override public function destruct():void 
		{
			_layoutBehavior = null;
			
			super.destruct();
		}
	}
}
