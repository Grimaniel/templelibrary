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

package temple.codecomponents.windows
{
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	import temple.codecomponents.buttons.CodeLabelButton;
	import temple.common.interfaces.IFocusable;
	import temple.core.destruction.DestructEvent;
	import temple.ui.focus.FocusManager;
	import temple.ui.layout.LayoutContainer;



	/**
	 * @author Thijs Broerse
	 */
	public class CodeTaskBar extends LayoutContainer
	{
		private var _desktop:DisplayObjectContainer;
		private var _taskBarDictionary:Dictionary;

		public function CodeTaskBar(desktop:DisplayObjectContainer = null, width:Number = NaN, height:Number = NaN, orientation:String = "horizontal", direction:String = "ascending", spacing:Number = 0)
		{
			super(width, height, orientation, direction, spacing);
			
			this._taskBarDictionary = new Dictionary(true);
			this.desktop = desktop;
		}

		public function get desktop():DisplayObjectContainer
		{
			return this._desktop;
		}

		public function set desktop(value:DisplayObjectContainer):void
		{
			if (this._desktop) this._desktop.removeEventListener(Event.ADDED, this.handleAdded);
			this._desktop = value;
			if (this._desktop) this._desktop.addEventListener(Event.ADDED, this.handleAdded);
		}

		private function handleAdded(event:Event):void
		{
			if (event.target is IWindow)
			{
				var window:IWindow = IWindow(event.target);
				
				var button:CodeLabelButton = new CodeLabelButton(window.label);
				button.top = 3;
				this.addChild(button);
				button.addEventListener(MouseEvent.CLICK, this.handleClick);
				this._taskBarDictionary[button] = window;
				this._taskBarDictionary[window] = button;
				window.addEventListener(Event.CHANGE, this.handleWindowChange);
				window.addEventListener(DestructEvent.DESTRUCT, this.handleWindowDestruct);
			}
		}

		private function handleClick(event:MouseEvent):void
		{
			if (this._taskBarDictionary[event.target] is IFocusable)
			{
				IFocusable(this._taskBarDictionary[event.target]).focus = true;
			}
			else
			{
				FocusManager.focus = this._taskBarDictionary[event.target] as InteractiveObject;
			}
		}
		
		private function handleWindowChange(event:Event):void
		{
			CodeLabelButton(this._taskBarDictionary[event.target]).label = IWindow(event.target).label;
		}
		
		private function handleWindowDestruct(event:DestructEvent):void
		{
			var button:CodeLabelButton = this._taskBarDictionary[event.target] as CodeLabelButton;
			if (button)
			{
				button.destruct();
				delete this._taskBarDictionary[event.target];
				delete this._taskBarDictionary[button];
			}
		}
	}
}
