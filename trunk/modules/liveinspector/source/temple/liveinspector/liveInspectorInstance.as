package temple.liveinspector
{
	/**
	 * This is the 'singleton' instance of the LiveInspector. Always use this instance class if you want to use the Live Inspector Module.
	 * 
	 * @see LiveInspector
	 * 
	 * @includeExample LiveInspectorExample.as
	 * @see ../../../readme.html readme.html
	 * 
	 * @author	Mark Knol
	 */
	public const liveInspectorInstance:LiveInspector = new LiveInspector({left:3, top:5});
}
