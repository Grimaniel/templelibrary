/*
include "../includes/License.as.inc";
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
		 *		if (_myCoreTimer)
		 *		{
		 *			_myCoreTimer.destruct();
		 *			_myCoreTimer = null;
		 *		}
		 *		
		 *		// if you used any Tweens in your class, kill them here
		 *		// TweenLite.killTweensOf(this);
		 *		
		 *		// also remove event listeners to other object
		 *		// if (stage) stage.removeEventListener(KeyboardEvent.KEY_UP, handleKeyUp);
		 *		
		 *		// It is not necessary to destruct DisplayObject, they get destructed automatically. Only set the
		 *		// reference to null
		 *		mcMovieClip = null; 
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
