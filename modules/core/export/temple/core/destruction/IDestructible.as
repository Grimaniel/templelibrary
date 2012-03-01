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

package temple.core.destruction 
{

	/**
	 * Interface for objects that can be destructed.
	 * 
	 * <p>When creating stable and maintainable code, you should always make sure the object can be completely destructed.
	 * Since Flash player 9 has a huge problem with removing unnecessary objects, it's really hard to remove object from
	 * Memory. Destructing objects is one of the key-features of the Temple. If you enabled object registration in the main
	 * Temple class. You can track your objects in Memory. If you destruct the objects they should disappear after a garbage
	 * collection.</p>
	 * 
	 * @see temple.core.debug.Memory
	 * 
	 * @author Thijs Broerse
	 */
	public interface IDestructible 
	{
		/**
		 * Destructs the object and makes it available for garbage collection.
		 * 
		 * <p>When overriding this method, always call super.destruct() at the end!</p>
		 * 
		 * If you want the object to be available for garbage collection make sure you:
		 * <ul>
		 * 	<li>Remove all event listeners on this object (use <code>removeAllEventListeners</code> on Temple objects).</li>
		 * 	<li>Remove all event listeners from this object.</li>
		 * 	<li>Set all non-primitive variables to null.</li>
		 * 	<li>Set all references to this object to null in other objects.</li>
		 * </ul>
		 * 
		 * When a Temple object is destructed a <code>DestructEvent.DESTRUCT</code> is dispatched from the object
		 * (if the object implements <code>ICoreEventDispatcher</code>).
		 * 
		 * <p>Note: Bear in mind that it is possible an object can be destructed more than once.</p>
		 * 
		 *  @example
		 * <listing version="3.0">
		 * override public function destruct()
		 * {
		 *		// first destruct your own objects and set variables to null.
		 *		
		 *		// always check if variable is not null, since it could cause a "null object reference"-error the next
		 *		// time this object is destructed
		 *		if (this._myCoreTimer)
		 *		{
		 *			this._myCoreTimer.destruct();
		 *			this._myCoreTimer = null;
		 *		}
		 *		
		 *		// if you used any Tweens in your class, kill them here
		 *		// TweenLite.killTweensOf(this);
		 *		
		 *		// also remove event listeners to other object
		 *		// if (this.stage) this.stage.removeEventListener(KeyboardEvent.KEY_UP, this.handleKeyUp);
		 *		
		 *		// It is not necessary to destruct DisplayObject, they get destructed automatically. Only set the
		 *		// reference to null
		 *		this.mcMovieClip = null; 
		 * 
		 *		// always calls super.destruct() in the end!
		 *		super.destruct();
		 * }
		 * </listing> 
		 * 
		 * @see temple.core.events.ICoreEventDispatcher
		 * @see temple.core.destruction.DestructEvent
		 */
		function destruct():void;
		
		[Temple]
		/**
		 * If an object is destructed, this property is set to <code>true</code>.
		 * 
		 * <p>After a garbage collection the object should be disappeared from <code>Memory</code>
		 * (if <code>Temple.registerObjectsInMemory</code> is set to <code>true</code>).
		 * 
		 * If the object still exists, you should check your code.</p>
		 * 
		 * @see temple.core.Temple
		 * @see temple.core.Temple#registerObjectsInMemory
		 * @see temple.core.debug.Registry
		 * @see temple.core.debug.Memory
		 */
		function get isDestructed():Boolean
	}
}
