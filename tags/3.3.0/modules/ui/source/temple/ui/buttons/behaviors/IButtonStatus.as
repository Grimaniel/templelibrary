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

package temple.ui.buttons.behaviors 
{
	import temple.common.interfaces.IDisableable;
	import temple.common.interfaces.IFocusable;
	import temple.common.interfaces.ISelectable;

	/**
	 * Indicates the status of a button. The <code>IButtonStatus</code> has the following properties which are used to
	 * indicate and update the status of a button:.
	 * 
	 * <ul>
	 * <li><strong>over</strong>: Indicates if the Mouse is currently over the button.</li>
	 * <li><strong>down</strong>: Indicates if the Mouse button is down on the button.</li>
	 * <li><strong>selected</strong>: Indicates if the button is seleceted.</li>
	 * <li><strong>disabled</strong>: Indicates if the button is disabled.</li>
	 * <li><strong>focus</strong>: Indicates if the button has focus.</li>
	 * </ul>
	 * 
	 * @author Thijs Broerse
	 */
	public interface IButtonStatus extends ISelectable, IDisableable, IFocusable
	{
		/**
		 * Indicates if the Mouse is currently over the button
		 */
		function get over():Boolean;

		/**
		 * Indicates if the Mouse button is down on the button
		 */
		function get down():Boolean;
	}
}
