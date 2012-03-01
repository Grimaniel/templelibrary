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
	import temple.core.debug.IDebuggable;

	import flash.events.MouseEvent;

	/**
	 * <p>This class can be used as component by setting this class as 'Component Definition' in the Flash IDE.
	 * You can set different properties in the Flash IDE in the 'Component Inspector'</p>
	 * 
	 * <p>The Temple knows different kinds of buttons. Check out the 
	 * <a href="http://templelibrary.googlecode.com/svn/trunk/modules/ui/readme.html" target="_blank">button schema</a>
	 * in the UI Module of the Temple for a list of all available buttons which their features. </p>
	 * 
	 * @see ../../../../../readme.html
	 * @see temple.ui.form.Form
	 * @see temple.ui.form.components.RadioGroup
	 * 
	 * @author Thijs Broerse
	 */
	public class RadioButton extends CheckBox implements IRadioButton, IDebuggable
	{
		private var _group:IRadioGroup;
		private var _toggle:Boolean;
		
		public function RadioButton()
		{
			super();
		}

		/**
		 * @inheritDoc
		 */
		public function get groupName():String
		{
			return this._group ? this._group.name : null;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set groupName(value:String):void
		{
			this.group = RadioGroup.getInstance(value);
		}
		
		/**
		 * @inheritDoc
		 */
		public function get group():IRadioGroup
		{
			return this._group;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set group(value:IRadioGroup):void
		{
			// remove from group if we already have a group
			if (this._group) this._group.remove(this);
			
			this._group = value;
			if (this._group)
			{
				this._group.add(this, this.selectedValue);
				if (this.selected) this._group.selected = this;
			}
		}

		/**
		 * @inheritDoc
		 */
		override public function set dataName(value:String):void
		{
			super.dataName = value;
		}

		/**
		 * @inheritDoc
		 */
		override public function set errorMessage(value:String):void
		{
			super.errorMessage = value;
		}

		/**
		 * @inheritDoc
		 */
		[Inspectable(name="Value", type="String")]
		override public function set selectedValue(value:*):void
		{
			// also store value as unselectedm since value will allways be get throug the RadioGroup
			this.unselectedValue = super.selectedValue = value;
		}

		/**
		 * @inheritDoc
		 */
		override public function set unselectedValue(value:*):void
		{
			super.unselectedValue = value;
		}

		/**
		 * @inheritDoc
		 */
		override public function set validationRuleName(value:String):void
		{
			super.validationRuleName = value;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set submit(value:Boolean):void
		{
			super.submit = value;
		}
		
		/**
		 * Indicates if button can be selected deselect when selected. Default: false
		 */
		public function get toggle():Boolean
		{
			return this._toggle;
		}

		/**
		 * @private
		 */
		public function set toggle(value:Boolean):void
		{
			this._toggle = value;
		}

		/**
		 * @private
		 */
		override protected function handleClick(event:MouseEvent):void
		{
			this.selected = this._toggle ? !this.selected : true;
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			if (this._group)
			{
				this._group.remove(this);
				this._group = null;
			}
			
			super.destruct();
		}
	}
}
