package
{
	import temple.common.enum.Enumerator;

	public class Gender extends Enumerator
	{
		public static const MALE:Gender = new Gender("male");
		public static const FEMALE:Gender = new Gender("female");

		public function Gender(value:String)
		{
			super(value);
		}
	}
}
