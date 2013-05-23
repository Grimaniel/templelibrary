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

package temple.liveinspector
{
	import temple.core.display.CoreSprite;
	import temple.reflection.ReflectionUtils;
	import temple.ui.layout.LayoutContainer;
	import temple.utils.types.ObjectUtils;

	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.utils.getQualifiedClassName;

	/**
	 * @author	Mark Knol [mediamonks]
	 */
	internal class LiveInspectorItem extends CoreSprite
	{
		private static const _splitter:String = ".";
		private static const _separator:String = ": ";
		
		private var _field:TextField;
		private var _editor:LiveInspectorEditor;
		private var _scope:*;
		private var _oldValue:*;
		private var _propertyName:*;
		private var _depth:uint;
		private var _color:uint;
		private var _propertyNameHTML:String;
		private var _removeButton:CoreSprite;
		private var _minimizeButton:CoreSprite;
		private var _readwrite:Boolean;
		private var _editor_x:Number;
		private var _typeOfProperty:String;

		public function LiveInspectorItem(scope:Object, propertyName:*, depth:uint = 0, color:int = 0x000000)
		{
			_depth = depth;
			_propertyName = propertyName;
			_scope = scope;
			_color = color;
			
			
			if ("name" in scope && scope.name)
			{
				_propertyNameHTML = "<font color='#" + _color.toString(16) + "'>" + _scope.name + _splitter;
			}
			else
			{
				_propertyNameHTML = "<font color='#" + _color.toString(16) + "'>" + getQualifiedClassName(_scope) + _splitter;
			}
			
			if (_propertyName) 
			{
				_propertyNameHTML += "<b>" + _propertyName + "</b></font>" + _separator;
				
				_typeOfProperty = ReflectionUtils.getNameOfTypeOfProperty(_scope, _propertyName);
			}

			createField();
			createEditor();
			createButtons();
			
			addEventListener(MouseEvent.ROLL_OUT, handleMouseEvent);
			addEventListener(MouseEvent.ROLL_OVER, handleMouseEvent);
			addEventListener(Event.ENTER_FRAME, handleEnterFrame);
		}

		private function createField():void
		{
			_field = new TextField();
			_field.alpha = LiveInspector.THEME_ALPHA;
			_field.defaultTextFormat = LiveInspector.THEME_TEXTFORMAT;
			_field.selectable = false;
			_field.mouseEnabled = false;
			_field.tabEnabled = false;
			_field.mouseWheelEnabled = false;
			_field.doubleClickEnabled = false;
			
			_field.background = true;
			_field.backgroundColor = LiveInspector.THEME_BACKGROUND_COLOR;
			
			_field.border = true;
			_field.borderColor = LiveInspector.THEME_BORDER_COLOR;
			_field.htmlText = _propertyNameHTML;
			_editor_x = _field.textWidth;
			addChild(_field);
		}

		private function createButtons(innerSpace:int = 5, buttonWidth:int = 14):void
		{
			_removeButton = new CoreSprite();
			_removeButton.graphics.lineStyle(4, LiveInspector.THEME_BACKGROUND_COLOR, 0);
			_removeButton.graphics.drawRoundRect(0, 0, buttonWidth, buttonWidth, innerSpace);
			_removeButton.graphics.beginFill(_color);
			_removeButton.graphics.drawRoundRect(1, 1, buttonWidth - 2, buttonWidth - 2, innerSpace - 1);
			_removeButton.graphics.lineStyle(2, LiveInspector.THEME_BACKGROUND_COLOR, 1);
			_removeButton.graphics.moveTo(innerSpace, innerSpace);
			_removeButton.graphics.lineTo(buttonWidth - innerSpace, buttonWidth - innerSpace);
			_removeButton.graphics.moveTo(buttonWidth - innerSpace, innerSpace);
			_removeButton.graphics.lineTo(innerSpace, buttonWidth - innerSpace);
			_removeButton.graphics.endFill();
			addChild(_removeButton);

			_minimizeButton = new CoreSprite();
			_minimizeButton.graphics.lineStyle(4, LiveInspector.THEME_BACKGROUND_COLOR, 0);
			_minimizeButton.graphics.drawRoundRect(0, 0, buttonWidth, buttonWidth, innerSpace);
			_minimizeButton.graphics.beginFill(_color);
			_minimizeButton.graphics.drawRoundRect(1, 1, buttonWidth - 2, buttonWidth - 2, innerSpace - 1);
			_minimizeButton.graphics.lineStyle(2, LiveInspector.THEME_BACKGROUND_COLOR, 1);
			_minimizeButton.graphics.moveTo(innerSpace, buttonWidth - innerSpace);
			_minimizeButton.graphics.lineTo(buttonWidth - innerSpace, buttonWidth - innerSpace);
			_minimizeButton.graphics.endFill();
			addChild(_minimizeButton);
			
			_removeButton.filters = _minimizeButton.filters = [new GlowFilter(LiveInspector.THEME_BORDER_COLOR, 1, 2, 2, 4, 1)];
			_removeButton.y = _minimizeButton.y = 2;
			_removeButton.autoAlpha = _minimizeButton.autoAlpha = 0;
			_removeButton.buttonMode = _minimizeButton.buttonMode = true;
			
			_removeButton.addEventListener(MouseEvent.CLICK, handleRemoveButtonClick);
			_minimizeButton.addEventListener(MouseEvent.CLICK, handleMinimizeClick);
		}

		private function createEditor():void
		{
			if (_scope && _propertyName && _propertyName in _scope) 
			{
				var value:* = _scope[_propertyName];
				
				if (ObjectUtils.isPrimitive(value) && ReflectionUtils.isWritable(_scope, _propertyName))
				{
					_readwrite = true;
					
					_editor = new LiveInspectorEditor(_scope, _propertyName, _typeOfProperty, _color);
					addChild(_editor);
					_editor.x = _editor_x;
					_editor.visible = false;
				}
			}
		}
		
		private function handleMinimizeClick(event:MouseEvent):void
		{
			_field.visible = _removeButton.visible = !_field.visible;
			_field.alpha = _field.visible ? LiveInspector.THEME_ALPHA : 0;
			if (_readwrite) _editor.visible = _field.visible;
			
			if (_field.visible) 
			{
				addChildAt(_field, 0);
			}
			else 
			{
				removeChild(_field);
			}
			
			repositionButtons();
			
			layoutContainer();
		}

		private function handleRemoveButtonClick(event:MouseEvent):void
		{
			destruct();
		}
		
		private function repositionButtons():void
		{
			_removeButton.x = _field.width - _removeButton.width + 3;
			_minimizeButton.x = (_field.visible) ? _removeButton.x - _minimizeButton.width + 3: 2;
		}

		private function handleMouseEvent(event:MouseEvent):void
		{
			repositionButtons();
			
			switch (event.type)
			{
				case MouseEvent.ROLL_OUT:
				{
					if (_field.visible) 
					{
						_removeButton.autoAlpha = 0;
						_minimizeButton.autoAlpha = 0;
					}
					else
					{
						_minimizeButton.autoAlpha = 1;
					}
					if (_readwrite) _editor.visible = false;
					break;
				}
				case MouseEvent.ROLL_OVER:
				{
					if (_field.visible) 
					{
						if (_readwrite) _editor.visible = true;
						_removeButton.autoAlpha = 1;
					}
					
					_minimizeButton.autoAlpha = 1;
					break;
				}
				default:
				{
					logError("Live Inspector.handleHover :: Cannot find event.type '" + event.type + "'.");
					break;
				}
			}
		}
	
		private function handleEnterFrame(event:Event):void
		{
			update();
		}
		
		protected function update():void
		{
			var scope:* = _scope;
			
			if (scope && "isDestructed" in scope && scope.isDestructed)
			{
				scope = null;
			}
			
			var oldHeight:Number;
			var oldWidth:Number;
			var output:String;
			
			if (scope && _propertyName != null && _propertyName in scope) 
			{
				var value:* = scope[_propertyName];
				
				var doUpdate:Boolean;
				if (!ObjectUtils.isPrimitive(value)) 
				{
					doUpdate = true;
				}
				else
				{
					doUpdate = value !== _oldValue;
				}
				
				if (doUpdate)
				{
					if (!ObjectUtils.isPrimitive(value)) 
					{
						output = _propertyNameHTML + dump(value, _depth);
					}
					else
					{
						output = _propertyNameHTML + value + " <font color='#" + LiveInspector.THEME_PROPERTY_TYPE_COLOR.toString(16) + "'>(" + _typeOfProperty + ")</font>";
					}
					
					oldHeight = _field.height;
					oldWidth = _field.width;
					
					_field.htmlText = output;
					_field.height = _field.textHeight + 3;
					_field.width = Math.max(LiveInspector.THEME_MIN_WIDTH, _field.textWidth + 3);
					
					if (oldHeight !== _field.height) 
					{
						layoutContainer();
					}
					
					if (_readwrite)
					{
						_editor.text = value || "null";
						_editor.width = _field.width - _editor_x;
						_editor.height = _editor.textHeight + 3;
					}
					
					repositionButtons();
					
					_oldValue = value;
				}
			}
			else if (scope && !_propertyName)
			{
				oldHeight = _field.height;
				
				output = _propertyNameHTML + scope;
				
				oldHeight = _field.height;
				
				_field.htmlText = output;
				_field.height = _field.textHeight + 3;
				_field.width = Math.max(250, _field.textWidth + 3);
				
				if (oldHeight !== _field.height) 
				{
					layoutContainer();
				}
				
				repositionButtons();
			}
			else
			{
				// inspector gadget : self destruct
				logStatus("Live Inspector closed inspection for " + _propertyName);
				
				destruct();
			}
		}
	
		private function layoutContainer():void
		{
			if (this.parent && this.parent is LayoutContainer) 
			{
				LayoutContainer(this.parent).layoutChildren();
			}
		}
		
		override public function destruct():void
		{
			_oldValue = null;
			_scope = null;
			_editor = null;
			
			super.destruct();
			
			layoutContainer();
		}
	}
}
