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

package temple.ui.label 
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
			this.toStringProps.push('label');
			this.init(textField);
		}
		
		/**
		 * Initialization
		 */
		protected function init(textField:TextField = null):void
		{
			this._label = textField ? new TextFieldLabelBehavior(textField) : LabelUtils.findLabel(this);
			
			if (this._label is IEventDispatcher)
			{
				(this._label as IEventDispatcher).addEventListener(Event.CHANGE, this.dispatchEvent);
			}
			if (this._label == null) throwError(new TempleError(this, "No TextField or Label found"));
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
		override public function destruct():void
		{
			if (this._label)
			{
				if (this._label is IEventDispatcher)
				{
					(this._label as IEventDispatcher).removeEventListener(Event.CHANGE, this.dispatchEvent);
				}
				this._label.destruct();
				this._label = null;
			}
			super.destruct();
		}
	}
}
