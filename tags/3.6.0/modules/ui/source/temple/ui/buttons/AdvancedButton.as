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

package temple.ui.buttons 
{
	import temple.common.interfaces.IHasValue;
	import temple.ui.form.components.IRadioButton;
	import temple.ui.form.components.IRadioGroup;
	import temple.ui.form.components.RadioGroup;
	import temple.ui.label.LabelUtils;
	import temple.ui.label.TextFieldLabelBehavior;

	import flash.events.MouseEvent;
	import flash.text.TextField;

	/**
	 * The most advanced button of the Temple.
	 * 
	 * <p>The Temple knows different kinds of buttons. Check out the 
	 * <a href="http://templelibrary.googlecode.com/svn/trunk/modules/ui/readme.html" target="_blank">button schema</a>
	 * in the UI Module of the Temple for a list of all available buttons which their features. </p>
	 * 
	 * @see temple.ui.buttons.behaviors.ButtonBehavior
	 * @see ../../../../readme.html
	 * 
	 * @author Thijs Broerse
	 */
	public class AdvancedButton extends LabelButton implements IHasValue, IRadioButton
	{
		protected var _group:IRadioGroup;
		protected var _data:*;
		protected var _toggle:Boolean;

		public function AdvancedButton() 
		{
			addEventListener(MouseEvent.CLICK, handleClick);
		}
		
		override protected function init(textField:TextField = null):void
		{
			_label = textField ? new TextFieldLabelBehavior(textField) : LabelUtils.findLabel(this);
		}
		
		/**
		 *  @inheritDoc
		 */
		public function get groupName():String
		{
			return _group ? _group.name : null;
		}

		/**
		 * @inheritDoc
		 */
		public function set groupName(value:String):void
		{
			group = RadioGroup.getInstance(value);
		}

		/**
		 * @inheritDoc
		 */
		public function get group():IRadioGroup
		{
			return _group;
		}

		/**
		 * @inheritDoc
		 */
		public function set group(value:IRadioGroup):void
		{
			if (_group == value) return;
			
			// remove from group if we already had a group
			if (_group) _group.remove(this);
			
			_group = value;
			if (_group) _group.add(this);
		}

		/**
		 * @inheritDoc
		 */
		public function get value():*
		{
			return _data;
		}

		/**
		 * @inheritDoc
		 */
		public function set value(value:*):void
		{
			_data = value;
		}

		/**
		 * Get or set a data object
		 */
		public function get data():*
		{
			return _data;
		}

		/**
		 * @private
		 */
		public function set data(value:*):void
		{
			_data = value;
		}

		/**
		 * Indicates if button can be selected deselect when selected. Default: false
		 */
		public function get toggle():Boolean
		{
			return _toggle;
		}

		/**
		 * @private
		 */
		public function set toggle(value:Boolean):void
		{
			_toggle = value;
		}
		
		protected function handleClick(event:MouseEvent):void 
		{
			if (_toggle)
			{
				selected = !selected;
			}
			else if (_group)
			{
				selected = true;
			}
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			if (_group)
			{
				var group:IRadioGroup = _group;
				group.remove(this);
				// check if this is the only button in the group. If so, destruct group
				if (!group.isDestructed && (group.items == null || group.items.length == 0))
				{
					group.destruct();
				}
			}
			
			_group = null;
			_data = null;
			
			super.destruct();
		}
	}
}
