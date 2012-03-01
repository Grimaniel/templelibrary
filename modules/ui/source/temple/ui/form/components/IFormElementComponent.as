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
	import temple.common.interfaces.IFocusable;
	import temple.common.interfaces.IHasValue;
	import temple.core.display.IDisplayObject;

	/**
	 * Interface for elements which can be used in a <code>FormComponent</code>.
	 * 
	 * @see temple.ui.form.components.FormComponent
	 * 
	 * @author Thijs Broerse
	 */
	public interface IFormElementComponent extends IHasValue, IDisplayObject, IFocusable
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
