package
{
	public class Person
	{
		public var name:String;
		public var birthdate:Date;
		public var gender:Gender;
		
		private var _friends:Vector.<Person>;

		public function get friends():Vector.<Person>
		{
			return _friends;
		}

		// note: setter must be untyped, since the JSONDecoder can't create runtime Vectors
		public function set friends(value:*):void
		{
			_friends = Vector.<Person>(value);
		}
	}
}
