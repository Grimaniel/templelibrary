package temple.liveinspector
{
	import temple.utils.DefinitionProvider;
	import temple.utils.Enum;

	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.ui.Keyboard;

	/**
	 * @author	Mark Knol [mediamonks]
	 */
	internal class LiveInspectorEditor extends TextField
	{
		private static const _propertyClassTypeMappings:Object = 
		{
			"flash.display.Stage":
			{
				"quality":"flash.display.StageQuality", 
				"align":"flash.display.StageAlign",
				"scaleMode":"flash.display.StageScaleMode",
				"displayState":"flash.display.StageDisplayState"
			},
			"flash.display.DisplayObject":
			{
				"blendMode":"flash.display.BlendMode"
			},
			"flash.text.TextField":
			{
				"autoSize":"flash.text.TextFieldAutoSize",
				"antiAliasType":"flash.text.AntiAliasType",
				"type":"flash.text.TextFieldType",
				"gridFitType":"flash.text.GridFitType"
			}
		};
		
		private var _scope:Object;
		private var _propertyName:*;
		private var _typeOfProperty:String;

		public function LiveInspectorEditor(scope:Object, propertyName:*, typeOfProperty:String, color:uint)
		{
			this._typeOfProperty = typeOfProperty;
			this._propertyName = propertyName;
			this._scope = scope;
			
			this.type = TextFieldType.INPUT;
			this.defaultTextFormat = LiveInspector.THEME_EDITOR_TEXTFORMAT;
			this.filters = [new GlowFilter(color, .1, 5, 5, 2, 3)];
			
			this.background = true;
			this.backgroundColor = LiveInspector.THEME_BACKGROUND_COLOR;

			this.border = true;
			this.borderColor = LiveInspector.THEME_BORDER_COLOR;
			
			this.addEventListener(Event.CHANGE, handleValueChange, false, 0, true);
			this.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyPress, false, 0, true);
			this.addEventListener(MouseEvent.MOUSE_WHEEL, handleScrollWheel, false, 0, true);
			
			switch (this._typeOfProperty)
			{
				case 'int':
				{
					this.restrict = "0-9-";
					break;
				}
				case 'uint':
				{
					this.restrict = "0-9";
					break;
				}
				case 'Number':
				{
					this.restrict = "0-9-.";
					break;
				}
				case 'Boolean':
				{
					this.restrict = "falsetru";
					break;
				}
			}
		}
		
		private function handleScrollWheel(event:MouseEvent):void
		{
			var value:* = this._scope[this._propertyName];
			
			try
			{
				switch (this._typeOfProperty)
				{
					case 'Number':
					{
						if (this._scope[this._propertyName] < 1 && this._scope[this._propertyName] > -1)
						{
							this._scope[this._propertyName] += event.delta > 0 ? .1 : -.1;
						}
						else
						{
							this._scope[this._propertyName] += event.delta;
						}
						break;
					}
					case 'int':
					case 'uint':
					{
						this._scope[this._propertyName] += event.delta;
						break;
					}
					case 'Boolean':
					{
						this._scope[this._propertyName] = !value;
						break;
					}
					case 'String':
					{
						this._scope[this._propertyName] = this.getSpecialStringValue(event.delta > 0 ? 1 : -1, value);
						break;
					}
				}
			}
			catch(e:Error)
			{
			}
		}
		
		private function handleKeyPress(event:KeyboardEvent):void
		{
			var value:* = this._scope[this._propertyName];
			
			if (event.keyCode === Keyboard.UP || event.keyCode === Keyboard.DOWN)
			{
				try
				{
					var amount:Number = (event.keyCode === Keyboard.UP) ? 1 : -1;
					switch (this._typeOfProperty)
					{
						case 'Number':
						{
							if (this._scope[this._propertyName] < 1 && this._scope[this._propertyName] > -1)
							{
								this._scope[this._propertyName] += amount * .1;
							}
							else
							{
								this._scope[this._propertyName] += amount;
							}
							break;
						}
						case 'int':
						case 'uint':
						{
							this._scope[this._propertyName] += amount;
							break;
						}
						case 'Boolean':
						{
							this._scope[this._propertyName] = !value;
							break;
						}
						case 'String':
						{
							this._scope[this._propertyName] = this.getSpecialStringValue(amount, value);
							break;
						}
					}
				}
				catch(e:Error)
				{
				}
			}
		}

		private function handleValueChange(event:Event):void
		{
			var scope:* = this._scope;
			
			if (scope && "isDestructed" in scope && scope.isDestructed)
			{
				scope = null;
			}
			
			if (scope && this._propertyName in scope) 
			{
				try
				{
					var text:String = TextField(event.currentTarget).text;
					switch (this._typeOfProperty)
					{
						case 'Number':
						{
							scope[this._propertyName] = Number(text);
							break;
						}
						case 'uint':
						{
							scope[this._propertyName] = uint(text);
							break;
						}
						case 'int':
						{
							scope[this._propertyName] = int(text);
							break;
						}
						case 'Boolean':
						{
							scope[this._propertyName] = (text === "true");
							break;
						}
						case 'String':
						{
							scope[this._propertyName] = text;
							break;
						}
					}
				}
				catch(e:Error)
				{
				}
			}
		}
		
		private function getSpecialStringValue(amount:int, value:String):String
		{
			for (var key:String in _propertyClassTypeMappings)
			{
				var classPropertyNames:Object = _propertyClassTypeMappings[key];
				if (DefinitionProvider.hasDefinition(key))
				{
					if (this._propertyName in classPropertyNames)
					{
						var mappedClassName:String = classPropertyNames[this._propertyName];
						if (DefinitionProvider.hasDefinition(mappedClassName))
						{
							return this.iterateOnClassType(amount, DefinitionProvider.getDefinition(mappedClassName), value);
						}
					}
				}
			}
			return value;
		}
		
		private function iterateOnClassType(amount:int, ClassName:Class, value:String):String
		{
			var list:Array = Enum.getArray(ClassName);
			var currentIndex:int = list.indexOf(value);
			var nextIndex:int = currentIndex + amount;
			
			if (nextIndex < 0) nextIndex = list.length - 1;
			else if (nextIndex >= list.length) nextIndex = 0;
			return list[nextIndex];
		}
	}
}
