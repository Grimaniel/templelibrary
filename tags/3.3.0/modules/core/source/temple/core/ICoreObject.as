/*
include "../includes/License.as.inc";
 */

package temple.core 
{
	import temple.core.destruction.IDestructible;

	/**
	 * Interface for all core classes of the Temple. The Temple's core classes are 
	 * extensions on the native (base) classes of Flash enhanced with the basic features 
	 * of the Temple, like memory registration and event listener registration.
	 * 
	 * <p>Temple's core classes are designed for easy destruction. ICoreObject extends 
	 * IDestructible. Therefore are all objects enhanced with a destruction method.</p>
	 * 
	 * <p>Since all core objects are registered in memory (if that feature is enabled) 
	 * they can be tracked. After destructing the object and a garbage collection the 
	 * object should be disappeared from Memory. If the object is still exists in Memory, 
	 * you have to check your code.</p>
	 * 
	 * @see temple.core.Temple
	 * @see temple.core.debug.Registry
	 * @see temple.core.debug.Memory
	 * 
	 * @author Thijs Broerse
	 */
	public interface ICoreObject extends IDestructible
	{
		[Temple]
		/**
		 * The unique identifier of the object. The id is generated and registered by the <code>Registry</code> class.
		 * @see temple.core.debug.Registry#add()
		 */
		function get registryId():uint;
	}
}
