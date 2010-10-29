/**
 * @exampleText
 * 
 * <h1>Form</h1>
 * 
 * <p>This is an example of the Form. In this case we have a form for submitting personal data. 
 * When the form is submitted the data is stored in a PersonData object.</p>
 * 
 * <p>This example uses Yalala to log debug information. Go to <a href="http://yalala.tyz.nl" target="_blank">http://yalala.tyz.nl</a> to view the debug messages.</p>
 * 
 * <p>View this example online at: <a href="http://templelibrary.googlecode.com/svn/trunk/examples/temple/ui/form/FormExample.swf" target="_blank">http://templelibrary.googlecode.com/svn/trunk/examples/temple/ui/form/FormExample.swf</a></p>
 * 
 * <p>This example uses an .fla file which can be found at: <a href="http://templelibrary.googlecode.com/svn/trunk/examples/temple/ui/form/FormExample.fla" target="_blank">http://templelibrary.googlecode.com/svn/trunk/examples/temple/ui/form/FormExample.fla</a></p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/examples/temple/ui/form/FormExample.as" target="_blank">Download source</a></p>   
 */
package  
{
	import temple.ui.buttons.MultiStateButton;
	import temple.ui.form.Form;
	import temple.ui.form.FormEvent;
	import temple.ui.form.components.CheckBox;
	import temple.ui.form.components.InputField;
	import temple.ui.form.components.RadioButton;
	import temple.ui.form.components.RadioGroup;
	import temple.ui.form.services.FormObjectService;
	import temple.ui.form.validation.rules.BooleanValidationRule;
	import temple.ui.form.validation.rules.EmailValidationRule;
	import temple.ui.form.validation.rules.EmptyStringValidationRule;
	import temple.ui.form.validation.rules.NullValidationRule;
	import temple.ui.form.validation.rules.Restrictions;
	import temple.utils.types.ObjectUtils;

	import flash.text.TextFieldAutoSize;

	// This class extends the DocumentClassExample, which handles some default Temple settings. This class can be found in directory '/examples/templates/'
	public class FormExample extends DocumentClassExample 
	{
		// timeline elements
		public var mcNameField:InputField;
		public var mcEmailField:InputField;
		public var mcCompanyField:InputField;
		
		public var mcGenderMaleRadioButton:RadioButton;
		public var mcGenderFemaleRadioButton:RadioButton;
		
		public var mcNewsletterCheckBox:CheckBox;
		public var mcTermsCheckBox:CheckBox;
		
		public var mcSubmitButton:MultiStateButton;
		public var mcResetButton:MultiStateButton;
		
		private var _data:PersonData;
		private var _form:Form;

		public function FormExample()
		{
			super("Temple - FormExample");
			
			// create a PersonData object in which we store the data after submitting.
			this._data = new PersonData();
			
			// create a new Form with a FormObjectService as service. Pass the PersonData object as object.
			this._form = new Form(new FormObjectService(this._data));
			
			// add InputFields to the Form. Note: the 'name' property (2nd parameter) must match the corresponding property value of the PersonData object, since we want to store the data in that object.
			this._form.addElement(this.mcNameField, "name", EmptyStringValidationRule, "Please fill in your name"); // EmptyStringValidationRule means: this field can not be empty. 
			this._form.addElement(this.mcEmailField, "email", EmailValidationRule, "Please fill in a correct e-mailaddress"); // EmailValidationRule means: this field must contain an emailaddress.
			this._form.addElement(this.mcCompanyField, "company");
			
			// create a RadioGroup for the RadioButtons.
			var radiogroup:RadioGroup = new RadioGroup();
			radiogroup.add(this.mcGenderMaleRadioButton, "male");
			radiogroup.add(this.mcGenderFemaleRadioButton, "female");
			
			// add RadioGroup to the Form
			this._form.addElement(radiogroup, "gender", NullValidationRule, "select your gender");
			
			// add CheckBoxes to the Form
			this._form.addElement(this.mcNewsletterCheckBox, "newsletter");
			this._form.addElement(this.mcTermsCheckBox, "terms", BooleanValidationRule, "You must agree to the terms", -1, false); // Must agree to terms, but we don't want to submit this value
			
			// set some restrictions
			this.mcEmailField.restrict = Restrictions.EMAIL;
			
			// set some hintText on the fields
			this.mcNameField.hintText = "your name here...";
			this.mcEmailField.hintText = "your e-mailaddress here...";
			this.mcCompanyField.hintText = "your company here...";
			
			// change the color of the hintText
			this.mcNameField.hintTextColor = 0x888888;
			this.mcEmailField.hintTextColor = 0x888888;
			this.mcCompanyField.hintTextColor = 0x888888;

			// change the textColor for errors
			this.mcNameField.errorTextColor = 0xFF0000;
			this.mcEmailField.errorTextColor = 0xFF0000;
			this.mcCompanyField.errorTextColor = 0xFF0000;
			
			// add the submit button
			this._form.addSubmitButton(this.mcSubmitButton);

			// add the reset button
			this._form.addResetButton(this.mcResetButton);
			
			// reset the form. By resetting the form all elements will be cleared.
			this._form.reset();
			
			// set labels for RadioButtons and CheckBoxes
			this.mcGenderMaleRadioButton.html = false;
			this.mcGenderMaleRadioButton.autoSize = TextFieldAutoSize.LEFT;
			this.mcGenderMaleRadioButton.label = "Male";
			this.mcGenderFemaleRadioButton.autoSize = TextFieldAutoSize.LEFT;
			this.mcGenderFemaleRadioButton.label = "Female";
			
			this.mcNewsletterCheckBox.autoSize = TextFieldAutoSize.LEFT;
			this.mcNewsletterCheckBox.label = "Sign me up for the Newsletter";
			this.mcTermsCheckBox.autoSize = TextFieldAutoSize.LEFT;
			this.mcTermsCheckBox.label = "I agree to the terms";
			
			this._form.addEventListener(FormEvent.SUBMIT_SUCCESS, this.handleFormSubmitSuccess);
		}

		private function handleFormSubmitSuccess(event:FormEvent):void 
		{
			this.logInfo("Submit success: " + ObjectUtils.traceObject(this._data, 3, false));
		}
	}
}

class PersonData
{
	public var name:String;
	public var email:String;
	public var company:String;
	public var gender:String;
	public var newsletter:Boolean;
}