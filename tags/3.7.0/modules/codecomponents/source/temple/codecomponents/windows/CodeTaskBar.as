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
			
			_taskBarDictionary = new Dictionary(true);
			this.desktop = desktop;
		}

		public function get desktop():DisplayObjectContainer
		{
			return _desktop;
		}

		public function set desktop(value:DisplayObjectContainer):void
		{
			if (_desktop) _desktop.removeEventListener(Event.ADDED, handleAdded);
			_desktop = value;
			if (_desktop) _desktop.addEventListener(Event.ADDED, handleAdded);
		}

		private function handleAdded(event:Event):void
		{
			if (event.target is IWindow)
			{
				var window:IWindow = IWindow(event.target);
				
				var button:CodeLabelButton = new CodeLabelButton(window.text);
				button.top = 3;
				addChild(button);
				button.addEventListener(MouseEvent.CLICK, handleClick);
				_taskBarDictionary[button] = window;
				_taskBarDictionary[window] = button;
				window.addEventListener(Event.CHANGE, handleWindowChange);
				window.addEventListener(DestructEvent.DESTRUCT, handleWindowDestruct);
			}
		}

		private function handleClick(event:MouseEvent):void
		{
			if (_taskBarDictionary[event.target] is IFocusable)
			{
				IFocusable(_taskBarDictionary[event.target]).focus = true;
			}
			else
			{
				FocusManager.focus = _taskBarDictionary[event.target] as InteractiveObject;
			}
		}
		
		private function handleWindowChange(event:Event):void
		{
			CodeLabelButton(_taskBarDictionary[event.target]).text = IWindow(event.target).text;
		}
		
		private function handleWindowDestruct(event:DestructEvent):void
		{
			var button:CodeLabelButton = _taskBarDictionary[event.target] as CodeLabelButton;
			if (button)
			{
				button.destruct();
				delete _taskBarDictionary[event.target];
				delete _taskBarDictionary[button];
			}
		}
	}
}
