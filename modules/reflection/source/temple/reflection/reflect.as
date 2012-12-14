package temple.reflection
{
	/**
	 * Returns the output of the <code>descrypeType</code> method for an object. Uses a caching system for better performance.
	 * 
	 * @see Reflection#get()
	 * 
	 * @author Thijs Broerse
	 */
	public function reflect(value:*):XML
	{
		return Reflection.get(value);
	}
}
