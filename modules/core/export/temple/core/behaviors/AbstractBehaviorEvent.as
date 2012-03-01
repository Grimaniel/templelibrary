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

package temple.core.behaviors 
{
	import flash.events.Event;
	import temple.core.debug.objectToString;
	import temple.core.templelibrary;

	/**
	 * Abstract implementation of a BehaviorEvent. This class is used as super class for other BehaviorEvents.
	 * This class will never be instantiated directly but will always be derived. So therefore this class is an 'Abstract' class.
	 * 
	 * @author Thijs Broerse
	 */
	public class AbstractBehaviorEvent extends Event implements IBehaviorEvent
	{
		/**
		 * The current version of the Temple Library
		 */
		templelibrary static const VERSION:String = "3.0.0";
		
		private var _behavior:IBehavior;

		/**
		 * Creates a new AbstractBehaviorEvent
		 * @param type The type of event.
		 * @param behavior The behavior
		 */
		public function AbstractBehaviorEvent(type:String, behavior:IBehavior, bubbles:Boolean = false)
		{
			super(type, bubbles);
			
			this._behavior = behavior;
		}

		/**
		 * @inheritDoc
		 */
		public function get behavior():IBehavior 
		{
			return this._behavior;
		}

		/**
		 * @inheritDoc
		 */
		public function get behaviorTarget():Object
		{
			return this._behavior.target;
		}

		/**
		 * @inheritDoc
		 */
		override public function toString():String
		{
			return objectToString(this, Vector.<String>(['type', 'behaviorTarget']));
		}
	}
}
