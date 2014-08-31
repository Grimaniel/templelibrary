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

package temple.ui.labels 
{
	import temple.core.errors.TempleError;
	import temple.core.errors.throwError;
	import temple.ui.layout.liquid.LiquidBehavior;
	import temple.ui.layout.liquid.LiquidContainer;

	import flash.display.DisplayObject;
	import flash.display.MorphShape;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	/**
	 * Dispatched after the text in the TextField is changed
	 * Event will also be dispatched from the TextField
	 * @eventType flash.events.Event.CHANGE
	 */
	[Event(name = "change", type = "flash.events.Event")]

	/**
	 * Dispatched after size of the TextField is changed
	 * Event will also be dispatched from the TextField
	 * @eventType flash.events.Event.RESIZE
	 */
	[Event(name = "resize", type = "flash.events.Event")]
	
	/**
	 * Label which automatically adjust his size and position.
	 * 
	 * @see temple.ui.layout.liquid.LiquidBehavior
	 * 
	 * @author Thijs Broerse
	 */
	public class LiquidLabel extends LiquidContainer implements ILiquidLabel
	{
		private var _label:ILabel;
		private var _paddingLeft:Number;
		private var _paddingRight:Number;
		private var _paddingTop:Number;
		private var _paddingBottom:Number;

		/**
		 * Create a new Label.
		 * @param textField optional TextField to pass on which the Label will use to display the label. If no TextField is provide, the Label will search the display list for a TextField of Label to use.
		 */
		public function LiquidLabel(textField:TextField = null)
		{
			init(textField);
			toStringProps.push('text');
		}
		
		/**
		 * Initialization
		 */
		protected function init(textField:TextField = null):void
		{
			_label = textField ? new TextFieldLabelBehavior(textField) : LabelUtils.findLabel(this);
			
			if (_label is IEventDispatcher)
			{
				(_label as IEventDispatcher).addEventListener(Event.CHANGE, handleLabelChange);
				(_label as IEventDispatcher).addEventListener(Event.RESIZE, handleLabelResize);
			}
			if (_label == null) throwError(new TempleError(this, "No TextField or Label found"));
			
			// give all other display object a liquid behavior 
			var leni:int = numChildren;
			var child:DisplayObject;
			for (var i:int = 0; i < leni; i++)
			{
				child = getChildAt(i);
				
				var sameSize:Boolean = (child.x == 0 && child.y == 0 && child.width == width && child.height == height);
				
				if (sameSize && child != textField && !LiquidBehavior.getInstance(child) && !(child is Shape) && !(child is MorphShape))
				{
					new LiquidBehavior(child, {top: 0, left: 0, right:0, bottom: 0}, this);
				}
			}
		}

		/**
		 * @inheritDoc
		 */
		public function get text():String
		{
			return _label ? _label.text : null;
		}
		
		/**
		 * @inheritDoc
		 */
		[Inspectable(name="Label", type="String")]
		public function set text(value:String):void
		{
			if (_label) _label.text = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get autoSize():Boolean
		{
			return _label is IAutoSizableLabel && (_label as IAutoSizableLabel).autoSize;
		}
		
		/**
		 * @inheritDoc
		 */
		[Inspectable(name="AutoSize", type="Boolean", defaultValue="none")]
		public function set autoSize(value:Boolean):void
		{
			if (_label is IAutoSizableLabel)
			{
				(_label as IAutoSizableLabel).autoSize = value;
			}
		}
		
				/**
		 * @inheritDoc
		 */
		public function get multiline():Boolean
		{
			return _label is IAutoSizableLabel && (_label as IAutoSizableLabel).multiline;
		}

		/**
		 * @inheritDoc
		 */
		[Inspectable(name="Multiline", type="Boolean")]
		public function set multiline(value:Boolean):void
		{
			if (_label is IAutoSizableLabel)
			{
				(_label as IAutoSizableLabel).multiline = value;
			}
		}

		/**
		 * @inheritDoc
		 */
		public function get wordWrap():Boolean
		{
			return _label is IAutoSizableLabel && (_label as IAutoSizableLabel).wordWrap;
		}

		/**
		 * @inheritDoc
		 */
		[Inspectable(name="WordWrap", type="Boolean")]
		public function set wordWrap(value:Boolean):void
		{
			if (_label is IAutoSizableLabel)
			{
				(_label as IAutoSizableLabel).wordWrap = value;
			}
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function get html():Boolean
		{
			return _label is IHTMLLabel ? (_label as IHTMLLabel).html : false;
		}
		
		/**
		 * @inheritDoc
		 */
		[Inspectable(name="HTML", type="Boolean")]
		public function set html(value:Boolean):void
		{
			if (_label is IHTMLLabel)
			{
				(_label as IHTMLLabel).html = value;
			}
			else
			{
				throwError(new TempleError(this, "label has no propery 'html'"));
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function get textField():TextField
		{
			if (_label is ITextFieldLabel)
			{
				return (_label as ITextFieldLabel).textField;
			}
			return null;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get paddingLeft():Number
		{
			return _paddingLeft;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set paddingLeft(value:Number):void
		{
			if (_paddingLeft != value)
			{
				_paddingLeft = value;
				resize();
			}
		}

		/**
		 * @private
		 */
		[Inspectable(name="Padding Left", type="String")]
		public function set inspectablePaddingLeft(value:String):void
		{
			if (value != '' && !isNaN(Number(value)))
			{
				paddingLeft = Number(value);
			}
		}

		/**
		 * @inheritDoc
		 */
		public function get paddingRight():Number
		{
			return _paddingRight;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set paddingRight(value:Number):void
		{
			if (_paddingRight != value)
			{
				_paddingRight = value;
				resize();
			}
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="Padding Right", type="String")]
		public function set inspectablePaddingRight(value:String):void
		{
			if (value != '' && !isNaN(Number(value)))
			{
				paddingRight = Number(value);
			}
		}

		/**
		 * @inheritDoc
		 */
		public function get paddingTop():Number
		{
			return _paddingTop;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set paddingTop(value:Number):void
		{
			if (_paddingTop != value)
			{
				_paddingTop = value;
				resize();
			}
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="Padding Top", type="String")]
		public function set inspectablePaddingTop(value:String):void
		{
			if (value != '' && !isNaN(Number(value)))
			{
				paddingTop = Number(value);
			}
		}

		/**
		 * @inheritDoc
		 */
		public function get paddingBottom():Number
		{
			return _paddingBottom;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set paddingBottom(value:Number):void
		{
			if (_paddingBottom != value)
			{
				_paddingBottom = value;
				resize();
			}
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="Padding Bottom", type="String")]
		public function set inspectablePaddingBottom(value:String):void
		{
			if (value != '' && !isNaN(Number(value)))
			{
				paddingBottom = Number(value);
			}
		}

		/**
		 * @inheritDoc
		 */
		public function get padding():Number
		{
			return _paddingLeft == _paddingRight && _paddingLeft == _paddingTop && _paddingLeft == _paddingBottom ? _paddingLeft : NaN;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set padding(value:Number):void
		{
			_paddingLeft = _paddingRight = _paddingTop = _paddingBottom = value;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set width(value:Number):void
		{
			var textFieldWidth:Number = value;
			if (!isNaN(_paddingLeft)) textFieldWidth -= _paddingLeft;
			if (!isNaN(_paddingRight)) textFieldWidth -= _paddingRight;
			textField.width = textFieldWidth;
			super.width = value;
		}

		override protected function initLiquid():void
		{
			super.initLiquid();
			resize();
		}

		protected function handleLabelChange(event:Event):void
		{
			dispatchEvent(event.clone());
		}
		
		protected function handleLabelResize(event:Event):void
		{
			resize();
		}
		
		protected function resize():void
		{
			if (autoSize == TextFieldAutoSize.NONE) return;
			
			var displayObject:DisplayObject;
			
			if (_label is DisplayObject)
			{
				displayObject = _label as DisplayObject;
			}
			else
			{
				displayObject = textField;
			}
			
			if (displayObject)
			{
				if (!isNaN(_paddingLeft) || !isNaN(_paddingRight))
				{
					if (!isNaN(_paddingLeft)) displayObject.x = _paddingLeft;
					width = (_paddingLeft ? _paddingLeft : 0) + displayObject.width + (_paddingRight ? _paddingRight : 0);
				}
				if (!isNaN(_paddingTop) || !isNaN(_paddingBottom))
				{
					if (!isNaN(_paddingTop)) displayObject.y = _paddingTop;
					height = (_paddingTop ? _paddingTop : 0) + displayObject.height + (_paddingBottom ? _paddingBottom : 0);
				}
			}
			if (liquidBehavior) liquidBehavior.update();
			dispatchEvent(new Event(Event.RESIZE));
		}
		
		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			if (_label)
			{
				if (_label is IEventDispatcher)
				{
					(_label as IEventDispatcher).removeEventListener(Event.CHANGE, handleLabelChange);
					(_label as IEventDispatcher).removeEventListener(Event.RESIZE, handleLabelResize);
				}
				_label.destruct();
				_label = null;
			}
			super.destruct();
		}
	}
}
