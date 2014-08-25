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
	import temple.common.interfaces.ISelectable;
	import temple.core.events.ICoreEventDispatcher;

	/**
	 * @author Thijs Broerse
	 */
	public interface IRadioGroup extends ICoreEventDispatcher, IFormElement
	{
		/**
		 * Get the name of the group
		 */
		function get name():String;
		
		/**
		 *	Add a button to the group
		 *	@param item the ISelectable to add
		 *	@param value value of the button. When the button is selected this will be the value of the group
		 *	@param selected set if the buttons should be selected
		 *	@param tabIndex the order of the button in tabbing, -1 means at the end
		 *	
		 *	@return the added item
		 */
		function add(item:ISelectable, value:* = null, selected:Boolean = false, tabIndex:int = -1):ISelectable;
		
		/**
		 * Removes an item from the group
		 * @param item the ISelectable item to remove
		 */
		function remove(item:ISelectable):void
		
		/**
		 *	Get or set the specified button (can be null to deselect current selection)
		 */
		function get selected():ISelectable;

		/**
		 * @private
		 */
		function set selected(value:ISelectable):void;
		
		/**
		 * @return all items in this group; objects of type ISelectable
		 */
		function get items():Array;
	}
}
