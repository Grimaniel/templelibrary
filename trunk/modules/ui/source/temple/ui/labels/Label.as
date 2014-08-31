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
	import temple.core.display.CoreMovieClip;
	import temple.core.errors.TempleError;
	import temple.core.errors.throwError;

	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.text.TextField;

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
	 * @author Thijs Broerse
	 */
	public class Label extends CoreMovieClip implements ITextFieldLabel
	{
		protected var _label:ILabel;

		/**
		 * Create a new Label.
		 * @param textField optional TextField to pass on which the Label will use to display the label. If no TextField is provide, the Label will search the display list for a TextField of Label to use.
		 */
		public function Label(textField:TextField = null)
		{
			toStringProps.push('text');
			init(textField);
		}
		
		/**
		 * Initialization
		 */
		protected function init(textField:TextField = null):void
		{
			_label = textField ? new TextFieldLabelBehavior(textField) : LabelUtils.findLabel(this);
			
			if (_label is IEventDispatcher)
			{
				(_label as IEventDispatcher).addEventListener(Event.CHANGE, dispatchEvent);
			}
			if (_label == null) throwError(new TempleError(this, "No TextField or Label found"));
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
		[Inspectable(name="AutoSize", type="Boolean")]
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
		override public function destruct():void
		{
			if (_label)
			{
				if (_label is IEventDispatcher)
				{
					(_label as IEventDispatcher).removeEventListener(Event.CHANGE, dispatchEvent);
				}
				_label.destruct();
				_label = null;
			}
			super.destruct();
		}
	}
}
