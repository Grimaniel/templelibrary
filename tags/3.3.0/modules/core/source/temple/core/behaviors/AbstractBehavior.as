/*
include "../includes/License.as.inc";
 */

package temple.core.behaviors 
{
	import flash.events.IEventDispatcher;
	import temple.core.destruction.DestructEvent;
	import temple.core.errors.TempleArgumentError;
	import temple.core.errors.throwError;
	import temple.core.events.CoreEventDispatcher;
	import temple.core.templelibrary;

	/**
	 * Abstract implementation of a Behavior. This class is used as super class 
	 * for other Behaviors.
	 * 
	 * <p>This class will never be instantiated directly but will always be derived. 
	 * So therefore this class is an 'Abstract' class.</p>
	 * 
	 * <p>This class watches his target. When the target is destructed, the behavior 
	 * will also be destructed (auto destruction). Since this class is useless 
	 * without its target</p>
	 * 
	 * @author Thijs Broerse
	 */
	public class AbstractBehavior extends CoreEventDispatcher implements IBehavior 
	{
		include "../includes/Version.as.inc";
		
		private var _target:Object;
		
		/**
		 * Creates a new AbstractBehavior
		 * @param target The target of this behavior, preferable an IEventDispatcher so the behavior will be destructed when the target is destructed.
		 */
		public function AbstractBehavior(target:Object)
		{
			construct::abstractBehavior(target);
		}

		construct function abstractBehavior(target:Object):void
		{
			if (target == null) throwError(new TempleArgumentError(this, "target cannot be null"));
			this.toStringProps.push('target');
			this._target = target;
			if (this._target is IEventDispatcher)
			{
				(this._target as IEventDispatcher).addEventListener(DestructEvent.DESTRUCT, this.handleTargetDestructed);
			}
			else
			{
				this.logWarn("This object is not an IEventDispatcher, so it will not be auto-destructed");
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public final function get target():Object
		{
			return this._target;
		}
		
		private function handleTargetDestructed(event:DestructEvent):void
		{
			this.destruct();
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			if (this._target)
			{
				if (this._target is IEventDispatcher) (this._target as IEventDispatcher).removeEventListener(DestructEvent.DESTRUCT, this.handleTargetDestructed);
				// Store target as String, so we do not have the real reverence anymore, but we can still see what is was.
				this._target = String(this._target);
			}
			super.destruct();
		}
	}
}
