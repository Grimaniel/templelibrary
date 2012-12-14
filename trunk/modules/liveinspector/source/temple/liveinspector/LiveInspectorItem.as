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
			this._depth = depth;
			this._propertyName = propertyName;
			this._scope = scope;
			this._color = color;
			
			
			if ("name" in scope && scope.name)
			{
				this._propertyNameHTML = "<font color='#" + this._color.toString(16) + "'>" + this._scope.name + _splitter;
			}
			else
			{
				this._propertyNameHTML = "<font color='#" + this._color.toString(16) + "'>" + getQualifiedClassName(this._scope) + _splitter;
			}
			
			if (this._propertyName) 
			{
				this._propertyNameHTML += "<b>" + this._propertyName + "</b></font>" + _separator;
				
				this._typeOfProperty = ReflectionUtils.getNameOfTypeOfProperty(this._scope, this._propertyName);
			}

			this.createField();
			this.createEditor();
			this.createButtons();
			
			this.addEventListener(MouseEvent.ROLL_OUT, handleMouseEvent);
			this.addEventListener(MouseEvent.ROLL_OVER, handleMouseEvent);
			this.addEventListener(Event.ENTER_FRAME, this.handleEnterFrame);
		}

		private function createField():void
		{
			this._field = new TextField();
			this._field.alpha = LiveInspector.THEME_ALPHA;
			this._field.defaultTextFormat = LiveInspector.THEME_TEXTFORMAT;
			this._field.selectable = false;
			this._field.mouseEnabled = false;
			this._field.tabEnabled = false;
			this._field.mouseWheelEnabled = false;
			this._field.doubleClickEnabled = false;
			
			this._field.background = true;
			this._field.backgroundColor = LiveInspector.THEME_BACKGROUND_COLOR;
			
			this._field.border = true;
			this._field.borderColor = LiveInspector.THEME_BORDER_COLOR;
			this._field.htmlText = this._propertyNameHTML;
			this._editor_x = this._field.textWidth;
			this.addChild(this._field);
		}

		private function createButtons(innerSpace:int = 5, buttonWidth:int = 14):void
		{
			this._removeButton = new CoreSprite();
			this._removeButton.graphics.lineStyle(4, LiveInspector.THEME_BACKGROUND_COLOR, 0);
			this._removeButton.graphics.drawRoundRect(0, 0, buttonWidth, buttonWidth, innerSpace);
			this._removeButton.graphics.beginFill(_color);
			this._removeButton.graphics.drawRoundRect(1, 1, buttonWidth - 2, buttonWidth - 2, innerSpace - 1);
			this._removeButton.graphics.lineStyle(2, LiveInspector.THEME_BACKGROUND_COLOR, 1);
			this._removeButton.graphics.moveTo(innerSpace, innerSpace);
			this._removeButton.graphics.lineTo(buttonWidth - innerSpace, buttonWidth - innerSpace);
			this._removeButton.graphics.moveTo(buttonWidth - innerSpace, innerSpace);
			this._removeButton.graphics.lineTo(innerSpace, buttonWidth - innerSpace);
			this._removeButton.graphics.endFill();
			this.addChild(this._removeButton);

			this._minimizeButton = new CoreSprite();
			this._minimizeButton.graphics.lineStyle(4, LiveInspector.THEME_BACKGROUND_COLOR, 0);
			this._minimizeButton.graphics.drawRoundRect(0, 0, buttonWidth, buttonWidth, innerSpace);
			this._minimizeButton.graphics.beginFill(_color);
			this._minimizeButton.graphics.drawRoundRect(1, 1, buttonWidth - 2, buttonWidth - 2, innerSpace - 1);
			this._minimizeButton.graphics.lineStyle(2, LiveInspector.THEME_BACKGROUND_COLOR, 1);
			this._minimizeButton.graphics.moveTo(innerSpace, buttonWidth - innerSpace);
			this._minimizeButton.graphics.lineTo(buttonWidth - innerSpace, buttonWidth - innerSpace);
			this._minimizeButton.graphics.endFill();
			this.addChild(this._minimizeButton);
			
			this._removeButton.filters = this._minimizeButton.filters = [new GlowFilter(LiveInspector.THEME_BORDER_COLOR, 1, 2, 2, 4, 1)];
			this._removeButton.y = this._minimizeButton.y = 2;
			this._removeButton.autoAlpha = this._minimizeButton.autoAlpha = 0;
			this._removeButton.buttonMode = this._minimizeButton.buttonMode = true;
			
			this._removeButton.addEventListener(MouseEvent.CLICK, handleRemoveButtonClick);
			this._minimizeButton.addEventListener(MouseEvent.CLICK, handleMinimizeClick);
		}

		private function createEditor():void
		{
			if (this._scope && this._propertyName && this._propertyName in this._scope) 
			{
				var value:* = this._scope[this._propertyName];
				
				if (ObjectUtils.isPrimitive(value) && ReflectionUtils.isWritable(this._scope, this._propertyName))
				{
					this._readwrite = true;
					
					this._editor = new LiveInspectorEditor(this._scope, this._propertyName, this._typeOfProperty, this._color);
					this.addChild(this._editor);
					this._editor.x = this._editor_x;
					this._editor.visible = false;
				}
			}
		}
		
		private function handleMinimizeClick(event:MouseEvent):void
		{
			this._field.visible = this._removeButton.visible = !this._field.visible;
			this._field.alpha = this._field.visible ? LiveInspector.THEME_ALPHA : 0;
			if (this._readwrite) this._editor.visible = this._field.visible;
			
			if (this._field.visible) 
			{
				this.addChildAt(this._field, 0);
			}
			else 
			{
				this.removeChild(this._field);
			}
			
			this.repositionButtons();
			
			this.layoutContainer();
		}

		private function handleRemoveButtonClick(event:MouseEvent):void
		{
			this.destruct();
		}
		
		private function repositionButtons():void
		{
			this._removeButton.x = this._field.width - this._removeButton.width + 3;
			this._minimizeButton.x = (this._field.visible) ? this._removeButton.x - this._minimizeButton.width + 3: 2;
		}

		private function handleMouseEvent(event:MouseEvent):void
		{
			this.repositionButtons();
			
			switch (event.type)
			{
				case MouseEvent.ROLL_OUT:
				{
					if (this._field.visible) 
					{
						this._removeButton.autoAlpha = 0;
						this._minimizeButton.autoAlpha = 0;
					}
					else
					{
						this._minimizeButton.autoAlpha = 1;
					}
					if (this._readwrite) this._editor.visible = false;
					break;
				}
				case MouseEvent.ROLL_OVER:
				{
					if (this._field.visible) 
					{
						if (this._readwrite) this._editor.visible = true;
						this._removeButton.autoAlpha = 1;
					}
					
					this._minimizeButton.autoAlpha = 1;
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
			this.update();
		}
		
		protected function update():void
		{
			var scope:* = this._scope;
			
			if (scope && "isDestructed" in scope && scope.isDestructed)
			{
				scope = null;
			}
			
			var oldHeight:Number;
			var oldWidth:Number;
			var output:String;
			
			if (scope && this._propertyName != null && this._propertyName in scope) 
			{
				var value:* = scope[this._propertyName];
				
				var doUpdate:Boolean;
				if (!ObjectUtils.isPrimitive(value)) 
				{
					doUpdate = true;
				}
				else
				{
					doUpdate = value !== this._oldValue;
				}
				
				if (doUpdate)
				{
					if (!ObjectUtils.isPrimitive(value)) 
					{
						output = this._propertyNameHTML + dump(value, this._depth);
					}
					else
					{
						output = this._propertyNameHTML + value + " <font color='#" + LiveInspector.THEME_PROPERTY_TYPE_COLOR.toString(16) + "'>(" + this._typeOfProperty + ")</font>";
					}
					
					oldHeight = this._field.height;
					oldWidth = this._field.width;
					
					this._field.htmlText = output;
					this._field.height = this._field.textHeight + 3;
					this._field.width = Math.max(LiveInspector.THEME_MIN_WIDTH, this._field.textWidth + 3);
					
					if (oldHeight !== this._field.height) 
					{
						this.layoutContainer();
					}
					
					if (this._readwrite)
					{
						this._editor.text = value || "null";
						this._editor.width = this._field.width - this._editor_x;
						this._editor.height = this._editor.textHeight + 3;
					}
					
					this.repositionButtons();
					
					this._oldValue = value;
				}
			}
			else if (scope && !this._propertyName)
			{
				oldHeight = this._field.height;
				
				output = this._propertyNameHTML + scope;
				
				oldHeight = this._field.height;
				
				this._field.htmlText = output;
				this._field.height = this._field.textHeight + 3;
				this._field.width = Math.max(250, this._field.textWidth + 3);
				
				if (oldHeight !== this._field.height) 
				{
					this.layoutContainer();
				}
				
				this.repositionButtons();
			}
			else
			{
				// inspector gadget : self destruct
				logStatus("Live Inspector closed inspection for " + this._propertyName);
				
				this.destruct();
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
			this._oldValue = null;
			this._scope = null;
			this._editor = null;
			
			super.destruct();
			
			this.layoutContainer();
		}
	}
}
