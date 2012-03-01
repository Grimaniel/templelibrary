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

package temple.ui.form.components 
{
	import temple.common.interfaces.IResettable;
	import temple.ui.form.validation.IHasError;
	import temple.ui.form.validation.rules.NullValidationRule;
	import temple.utils.FrameDelay;

	import flash.events.Event;

	/**
	 * <code>DisplayObjectContainer</code> which adds his children which implements <code>IRadioButton</code>
	 * automatically to a <code>RadioGroup</code>.
	 * 
	 * <p>Use this class in combination with a <code>FormComponents</code> for easy creating form in the
	 * Flash IDE. <strong>Don't use that class as a <code>RadioGroup</code>.</strong></p>
	 * 
	 * @see temple.ui.form.components.IRadioButton
	 * @see temple.ui.form.components.RadioGroup
	 * @see temple.ui.form.components.FormComponent
	 * 
	 * @author Thijs Broerse
	 */
	public class RadioButtonGroup extends FormElementComponent implements IHasError, IResettable, ISetValue
	{
		private var _radioGroup:RadioGroup;
		
		public function RadioButtonGroup()
		{
			super();
			
			this._radioGroup = new RadioGroup();
			this._radioGroup.addEventListener(Event.CHANGE, this.handleChange);
			
			new FrameDelay(this.findRadioButtons);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get value():*
		{
			return this._radioGroup.value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set value(value:*):void
		{
			this._radioGroup.value = value;
		}
		
		/**
		 * @inheritDoc
		 */
		[Inspectable(name="Validation rule", type="String", defaultValue="none", enumeration="none,not null")]
		public function set validationRuleName(value:String):void
		{
			switch (value){
				case "none":
					this._validator = null;
					break;
				
				case "not null":
					this._validator = NullValidationRule;
					break;
				
				default:
					this._validator = null;
					this.logError("validationRule: unknown validation rule '" + value + "'");
					break;
			}
		}
		
		/**
		 * @inheritDoc 
		 */
		override public function showError(message:String = null):void 
		{
			super.showError(message);
			this._radioGroup.showError(message);
		}
		
		/**
		 * @inheritDoc 
		 */
		override public function hideError():void 
		{
			super.hideError();
			this._radioGroup.hideError();
		}

		/**
		 * @inheritDoc
		 */
		public function reset():void
		{
			this._radioGroup.reset();
		}

		/**
		 * @inheritDoc
		 */
		override public function set focus(value:Boolean):void
		{
			this._radioGroup.focus = super.focus = value;
		}

		/**
		 * Returns a reference to the RadioGroup
		 */
		public function get radioGroup():RadioGroup
		{
			return this._radioGroup;
		}
		
		/**
		 * Returns the length of the RadioGroup
		 */
		public function get length():uint
		{
			return this._radioGroup.items.length;
		}

		protected function findRadioButtons():void
		{
			// find form elements components
			var item:IRadioButton;
			var leni:int = this.numChildren;
			for (var i:int = 0; i < leni ; i++)
			{
				item = this.getChildAt(i) as IRadioButton;
				if (item)
				{
					this._radioGroup.add(item, null, item.selected, item.tabIndex);
					if (item.selected) this.dispatchEvent(new Event(Event.CHANGE));
				}
			}
		}
		
		protected function handleChange(event:Event):void
		{
			this.dispatchEvent(event.clone());
		}
		
		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			if (this._radioGroup)
			{
				this._radioGroup.destruct();
				this._radioGroup = null;
			}
			super.destruct();
		}
	}
}
