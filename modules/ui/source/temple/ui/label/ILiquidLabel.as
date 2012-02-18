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
	import temple.core.display.IDisplayObjectContainer;

	/**
	 * Interface for object which are liquid and have a label.
	 * 
	 * @see temple.ui.layout.liquid.LiquidBehavior
	 * 
	 * @author Thijs Broerse
	 */
	public interface ILiquidLabel extends ITextFieldLabel, IDisplayObjectContainer
	{
		/**
		 * Space between the left side of the TextField and the left border of the container.
		 * If NaN property is not used
		 */
		function get paddingLeft():Number;

		/**
		 * @inheritDoc
		 */
		function set paddingLeft(value:Number):void
		
		/**
		 * Space between the right side of the TextField and the right border of the container.
		 * If NaN property is not used
		 */
		function get paddingRight():Number;

		/**
		 * @inheritDoc
		 */
		function set paddingRight(value:Number):void
		
		/**
		 * Space between the top of the TextField and the top of the container.
		 * If NaN property is not used
		 */
		function get paddingTop():Number;

		/**
		 * @inheritDoc
		 */
		function set paddingTop(value:Number):void
		
		/**
		 * Space between the bottom side of the TextField and the bottom of the container.
		 * If NaN property is not used
		 */
		function get paddingBottom():Number;

		/**
		 * @inheritDoc
		 */
		function set paddingBottom(value:Number):void
		
		/**
		 * Property to set paddingLeft, paddingRight, paddingTop and paddingBottom at once.
		 * If paddingLeft, paddingRight, paddingTop and paddingBottom are not equal, NaN will be returned
		 */
		function get padding():Number;

		/**
		 * @inheritDoc
		 */
		function set padding(value:Number):void
	}
}
