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

package temple.ui.form.components 
{
	import temple.common.interfaces.IResettable;
	import temple.common.interfaces.ISelectable;
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
	public class RadioButtonGroup extends FormElementComponent implements IHasError, IResettable, ISetValue, IRadioGroup
	{
		private var _radioGroup:RadioGroup;
		
		public function RadioButtonGroup()
		{
			super();
			
			_radioGroup = new RadioGroup();
			_radioGroup.addEventListener(Event.CHANGE, handleChange);
			
			new FrameDelay(findRadioButtons);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get value():*
		{
			return _radioGroup.value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set value(value:*):void
		{
			_radioGroup.value = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get selected():ISelectable 
		{
			return _radioGroup.selected;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set selected(value:ISelectable):void 
		{
			_radioGroup.selected = value;
		}
		
		/**
		 * @inheritDoc
		 */
		[Inspectable(name="Validation rule", type="String", defaultValue="none", enumeration="none,not null")]
		public function set validationRuleName(value:String):void
		{
			switch (value){
				case "none":
					_validator = null;
					break;
				
				case "not null":
					_validator = NullValidationRule;
					break;
				
				default:
					_validator = null;
					logError("validationRule: unknown validation rule '" + value + "'");
					break;
			}
		}
		
		/**
		 * @inheritDoc 
		 */
		override public function showError(message:String = null):void 
		{
			super.showError(message);
			_radioGroup.showError(message);
		}
		
		/**
		 * @inheritDoc 
		 */
		override public function hideError():void 
		{
			super.hideError();
			_radioGroup.hideError();
		}

		/**
		 * @inheritDoc
		 */
		public function reset():void
		{
			_radioGroup.reset();
		}

		/**
		 * @inheritDoc
		 */
		override public function set focus(value:Boolean):void
		{
			_radioGroup.focus = super.focus = value;
		}

		/**
		 * Returns a reference to the RadioGroup
		 */
		public function get radioGroup():RadioGroup
		{
			return _radioGroup;
		}
		
		/**
		 * @inheritDoc
		 */
		public function add(item:ISelectable, value:* = null, selected:Boolean = false, tabIndex:int = -1):ISelectable
		{
			return _radioGroup.add(item, value, selected, tabIndex);
		}

		/**
		 * @inheritDoc
		 */
		public function remove(item:ISelectable):void
		{
			_radioGroup.remove(item);
		}

		/**
		 * @inheritDoc
		 */
		public function get items():Array
		{
			return _radioGroup.items;
		}
		
		/**
		 * Returns the length of the RadioGroup
		 */
		public function get length():uint
		{
			return _radioGroup.items.length;
		}

		protected function findRadioButtons():void
		{
			// find form elements components
			var item:IRadioButton;
			var leni:int = numChildren;
			for (var i:int = 0; i < leni ; i++)
			{
				item = getChildAt(i) as IRadioButton;
				if (item)
				{
					_radioGroup.add(item, null, item.selected, item.tabIndex);
					if (item.selected) dispatchEvent(new Event(Event.CHANGE));
				}
			}
		}
		
		protected function handleChange(event:Event):void
		{
			dispatchEvent(event.clone());
		}
		
		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			if (_radioGroup)
			{
				_radioGroup.destruct();
				_radioGroup = null;
			}
			super.destruct();
		}
	}
}
