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

package temple.ui.label 
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
			this.init(textField);
			this.toStringProps.push('label');
		}
		
		/**
		 * Initialization
		 */
		protected function init(textField:TextField = null):void
		{
			this._label = textField ? new TextFieldLabelBehavior(textField) : LabelUtils.findLabel(this);
			
			if (this._label is IEventDispatcher)
			{
				(this._label as IEventDispatcher).addEventListener(Event.CHANGE, this.handleLabelChange);
				(this._label as IEventDispatcher).addEventListener(Event.RESIZE, this.handleLabelResize);
			}
			if (this._label == null) throwError(new TempleError(this, "No TextField or Label found"));
			
			// give all other display object a liquid behavior 
			var leni:int = this.numChildren;
			var child:DisplayObject;
			for (var i:int = 0; i < leni; i++)
			{
				child = this.getChildAt(i);
				
				var sameSize:Boolean = (child.x == 0 && child.y == 0 && child.width == this.width && child.height == this.height);
				
				if (sameSize && child != this.textField && !LiquidBehavior.getInstance(child) && !(child is Shape) && !(child is MorphShape))
				{
					new LiquidBehavior(child, this, {top: 0, left: 0, right:0, bottom: 0});
				}
			}
		}

		/**
		 * @inheritDoc
		 */
		public function get label():String
		{
			return this._label ? this._label.label : null;
		}
		
		/**
		 * @inheritDoc
		 */
		[Inspectable(name="Label", type="String")]
		public function set label(value:String):void
		{
			if (this._label) this._label.label = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get autoSize():String
		{
			return this._label is IAutoSizableLabel ? (this._label as IAutoSizableLabel).autoSize : null;
		}
		
		/**
		 * @inheritDoc
		 */
		[Inspectable(name="AutoSize", type="String", defaultValue="none", enumeration="none,left,right,center")]
		public function set autoSize(value:String):void
		{
			if (this._label is IAutoSizableLabel)
			{
				(this._label as IAutoSizableLabel).autoSize = value;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function get html():Boolean
		{
			return this._label is IHTMLLabel ? (this._label as IHTMLLabel).html : false;
		}
		
		/**
		 * @inheritDoc
		 */
		[Inspectable(name="HTML", type="Boolean")]
		public function set html(value:Boolean):void
		{
			if (this._label is IHTMLLabel)
			{
				(this._label as IHTMLLabel).html = value;
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
			if (this._label is ITextFieldLabel)
			{
				return (this._label as ITextFieldLabel).textField;
			}
			return null;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get paddingLeft():Number
		{
			return this._paddingLeft;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set paddingLeft(value:Number):void
		{
			if (this._paddingLeft != value)
			{
				this._paddingLeft = value;
				this.resize();
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
				this.paddingLeft = Number(value);
			}
		}

		/**
		 * @inheritDoc
		 */
		public function get paddingRight():Number
		{
			return this._paddingRight;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set paddingRight(value:Number):void
		{
			if (this._paddingRight != value)
			{
				this._paddingRight = value;
				this.resize();
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
				this.paddingRight = Number(value);
			}
		}

		/**
		 * @inheritDoc
		 */
		public function get paddingTop():Number
		{
			return this._paddingTop;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set paddingTop(value:Number):void
		{
			if (this._paddingTop != value)
			{
				this._paddingTop = value;
				this.resize();
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
				this.paddingTop = Number(value);
			}
		}

		/**
		 * @inheritDoc
		 */
		public function get paddingBottom():Number
		{
			return this._paddingBottom;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set paddingBottom(value:Number):void
		{
			if (this._paddingBottom != value)
			{
				this._paddingBottom = value;
				this.resize();
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
				this.paddingBottom = Number(value);
			}
		}

		/**
		 * @inheritDoc
		 */
		public function get padding():Number
		{
			return this._paddingLeft == this._paddingRight && this._paddingLeft == this._paddingTop && this._paddingLeft == this._paddingBottom ? this._paddingLeft : NaN;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set padding(value:Number):void
		{
			this._paddingLeft = this._paddingRight = this._paddingTop = this._paddingBottom = value;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set width(value:Number):void
		{
			var textFieldWidth:Number = value;
			if (!isNaN(this._paddingLeft)) textFieldWidth -= this._paddingLeft;
			if (!isNaN(this._paddingRight)) textFieldWidth -= this._paddingRight;
			this.textField.width = textFieldWidth;
			super.width = value;
		}

		override protected function initLiquid():void
		{
			super.initLiquid();
			this.resize();
		}

		protected function handleLabelChange(event:Event):void
		{
			this.dispatchEvent(event.clone());
		}
		
		protected function handleLabelResize(event:Event):void
		{
			this.resize();
		}
		
		protected function resize():void
		{
			if (this.autoSize == TextFieldAutoSize.NONE) return;
			
			var displayObject:DisplayObject;
			
			if (this._label is DisplayObject)
			{
				displayObject = this._label as DisplayObject;
			}
			else
			{
				displayObject = textField;
			}
			
			if (displayObject)
			{
				if (!isNaN(this._paddingLeft) || !isNaN(this._paddingRight))
				{
					if (!isNaN(this._paddingLeft)) displayObject.x = this._paddingLeft;
					this.width = (this._paddingLeft ? this._paddingLeft : 0) + displayObject.width + (this._paddingRight ? this._paddingRight : 0);
				}
				if (!isNaN(this._paddingTop) || !isNaN(this._paddingBottom))
				{
					if (!isNaN(this._paddingTop)) displayObject.y = this._paddingTop;
					this.height = (this._paddingTop ? this._paddingTop : 0) + displayObject.height + (this._paddingBottom ? this._paddingBottom : 0);
				}
			}
			if (this.liquidBehavior) this.liquidBehavior.update();
			this.dispatchEvent(new Event(Event.RESIZE));
		}
		
		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			if (this._label)
			{
				if (this._label is IEventDispatcher)
				{
					(this._label as IEventDispatcher).removeEventListener(Event.CHANGE, this.handleLabelChange);
					(this._label as IEventDispatcher).removeEventListener(Event.RESIZE, this.handleLabelResize);
				}
				this._label.destruct();
				this._label = null;
			}
			super.destruct();
		}
	}
}
