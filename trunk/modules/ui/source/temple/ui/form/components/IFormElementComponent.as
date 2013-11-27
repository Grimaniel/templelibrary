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
	import temple.core.display.IDisplayObject;

	/**
	 * Interface for elements which can be used in a <code>FormComponent</code>.
	 * 
	 * @see temple.ui.form.components.FormComponent
	 * 
	 * @author Thijs Broerse
	 */
	public interface IFormElementComponent extends IFormElement, IDisplayObject
	{
		/**
		 * If this element is automatically added by the FormComponent, the FormComponent will use this as property name for this element.
		 */
		function get dataName():String;
		
		/**
		 * @private
		 */
		function set dataName(value:String):void;
	
		/**
		 * Name of the validation rule
		 */
		function get validationRule():Class;
		
		/**
		 * Order of tabbing
		 */
		function get tabIndex():int;
		
		/**
		 * @private
		 */
		function set tabIndex(value:int):void;
		
		/**
		 * The error message that is shown when value is not valid.
		 * This property is only used by the FormComponent. When this element is set as component this propery can be set in Component Inspector.
		 * 
		 * <p>Note: this property is not used if you add the element to a Form with the 'addElement' method of the Form.</p> 
		 * 
		 * @see temple.ui.form.components.FormComponent  
		 */
		function get errorMessage():String;
		
		/**
		 * @private
		 */
		function set errorMessage(value:String):void;
		
		/**
		 * Indicates if this value should be submitted to the service (true) or should be ignored (false)
		 */
		function get submit():Boolean;
		
		/**
		 * @private
		 */
		function set submit(value:Boolean):void;
	}
}
