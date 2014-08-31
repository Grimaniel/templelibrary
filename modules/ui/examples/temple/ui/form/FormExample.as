/**
 * @exampleText
 * 
 * <a name="Form"></a>
 * <h1>Form</h1>
 * 
 * <p>This is an example of the <a href="http://templelibrary.googlecode.com/svn/trunk/modules/ui/doc/temple/ui/form/Form.html">Form.</a>
 * In this case we have a form for submitting personal data. 
 * When the form is submitted the data is stored in a PersonData object.</p>
 * 
 * <p>This example uses Yalala to log debug information. Go to <a href="http://yalala.tyz.nl" target="_blank">http://yalala.tyz.nl</a> to view the debug messages.</p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/ui/examples/temple/ui/form/FormExample.swf" target="_blank">View this example</a></p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/ui/examples/temple/ui/form/FormExample.fla" target="_blank">Download .fla file</a></p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/ui/examples/temple/ui/form/FormExample.as" target="_blank">View source</a></p>
 */
package
{
	import temple.utils.types.TextFormatUtils;
	import temple.utils.types.EventUtils;
	import flash.events.Event;
	import temple.ui.buttons.LabelButton;
	import temple.ui.form.Form;
	import temple.ui.form.FormEvent;
	import temple.ui.form.components.CheckBox;
	import temple.ui.form.components.ComboBox;
	import temple.ui.form.components.InputField;
	import temple.ui.form.components.RadioButton;
	import temple.ui.form.components.RadioGroup;
	import temple.ui.form.services.ObjectFormService;
	import temple.ui.form.validation.rules.BooleanValidationRule;
	import temple.ui.form.validation.rules.EmailValidationRule;
	import temple.ui.form.validation.rules.EmptyStringValidationRule;
	import temple.ui.form.validation.rules.NullValidationRule;
	import temple.ui.form.validation.rules.Restrictions;
	import temple.utils.types.ObjectUtils;

	import flash.events.MouseEvent;
	import flash.text.TextFieldAutoSize;

	// This class extends the DocumentClassExample, which handles some default Temple settings. This class can be found in directory '/examples/templates/'
	public class FormExample extends DocumentClassExample 
	{
		// timeline elements
		public var mcNameField:InputField;
		public var mcEmailField:InputField;
		public var mcCompanyField:InputField;
		public var mcCountryField:ComboBox;
		
		public var mcGenderMaleRadioButton:RadioButton;
		public var mcGenderFemaleRadioButton:RadioButton;
		
		public var mcNewsletterCheckBox:CheckBox;
		public var mcTermsCheckBox:CheckBox;
		
		public var mcSubmitButton:LabelButton;
		public var mcResetButton:LabelButton;
		public var mcPrefillButton:LabelButton;
		
		private var _data:PersonData;
		private var _form:Form;

		public function FormExample()
		{
			super("Temple - FormExample");
			
			// create a PersonData object in which we store the data after submitting.
			_data = new PersonData();
			
			// create a new Form with a FormObjectService as service. Pass the PersonData object as object.
			_form = new Form(new ObjectFormService(_data));
			
			// enable debug, so debug infomation is logged
			_form.debug = true;
			
			// add InputFields to the Form. Note: the 'name' property (2nd parameter) must match the corresponding property value of the PersonData object, since we want to store the data in that object.
			_form.add(mcNameField, "name", EmptyStringValidationRule, "Please fill in your name"); // EmptyStringValidationRule means: this field can not be empty. 
			_form.add(mcEmailField, "email", EmailValidationRule, "Please fill in a correct e-mailaddress"); // EmailValidationRule means: this field must contain an emailaddress.
			_form.add(mcCompanyField, "company");
			_form.add(mcCountryField, "country", NullValidationRule, "Please select your country"); // NullValidationRule: a ComboBox returns null when no item is selected.
			
			// fill country ComboBox with some countries. We use the ISO code as data. (For this case we don't add all countries of the world, since the example would be too large. But ofcourse you can add all the countries you want.)
			mcCountryField.addItem("BEL","Belgium");
			mcCountryField.addItem("CZE","Czech Republic");
			mcCountryField.addItem("DNK","Denmark");
			mcCountryField.addItem("EST","Estonia");
			mcCountryField.addItem("FRA","France");
			mcCountryField.addItem("DEU","Germany");
			mcCountryField.addItem("GRC","Greece");
			mcCountryField.addItem("GRL","Greenland");
			mcCountryField.addItem("HUN","Hungary");
			mcCountryField.addItem("ISL","Iceland");
			mcCountryField.addItem("IRL","Ireland");
			mcCountryField.addItem("ITA","Italy");
			mcCountryField.addItem("JPN","Japan");
			mcCountryField.addItem("LUX","Luxembourg");
			mcCountryField.addItem("MEX","Mexico");
			mcCountryField.addItem("NLD","Netherlands");
			mcCountryField.addItem("NZL","New Zealand");
			mcCountryField.addItem("NOR","Norway");
			mcCountryField.addItem("PER","Peru");
			mcCountryField.addItem("POL","Poland");
			mcCountryField.addItem("PRT","Portugal");
			mcCountryField.addItem("ROU","Romania");
			mcCountryField.addItem("RWA","Rwanda");
			mcCountryField.addItem("SGP","Singapore");
			mcCountryField.addItem("ZAF","South Africa");
			mcCountryField.addItem("ESP","Spain");
			mcCountryField.addItem("SWE","Sweden");
			mcCountryField.addItem("CHE","Switzerland");
			mcCountryField.addItem("THA","Thailand");
			mcCountryField.addItem("TUR","Turkey");
			mcCountryField.addItem("UGA","Uganda");
			mcCountryField.addItem("UKR","Ukraine");
			mcCountryField.addItem("GBR","United Kingdom");
			mcCountryField.addItem("USA","United States");
			mcCountryField.addItem("ZWE","Zimbabwe");
						
			
			// create a RadioGroup for the RadioButtons.
			var radiogroup:RadioGroup = new RadioGroup();
			radiogroup.add(mcGenderMaleRadioButton, "male");
			radiogroup.add(mcGenderFemaleRadioButton, "female");
			
			// add RadioGroup to the Form
			_form.add(radiogroup, "gender", NullValidationRule, "select your gender");
			
			// add CheckBoxes to the Form
			_form.add(mcNewsletterCheckBox, "newsletter");
			_form.add(mcTermsCheckBox, "terms", BooleanValidationRule, "You must agree to the terms", -1, false); // Must agree to terms, but we don't want to submit this value
			
			// set some restrictions
			mcEmailField.restrict = Restrictions.EMAIL;
			
			// set some hintText on the fields
			mcNameField.hintText = "your name here...";
			mcEmailField.hintText = "your e-mailaddress here...";
			mcCompanyField.hintText = "your company here...";
			mcCountryField.hintText = "select your country...";
			
			// change the color of the hintText
			mcNameField.hintTextFormat = TextFormatUtils.clone(mcNameField.defaultTextFormat);
			mcNameField.hintTextFormat.color = 0x888888;
			mcEmailField.hintTextFormat = TextFormatUtils.clone(mcEmailField.defaultTextFormat);
			mcEmailField.hintTextFormat.color = 0x888888;
			mcCompanyField.hintTextFormat = TextFormatUtils.clone(mcCompanyField.defaultTextFormat);
			mcCompanyField.hintTextFormat.color = 0x888888;
			mcCountryField.hintTextFormat = TextFormatUtils.clone(mcCountryField.defaultTextFormat);
			mcCountryField.hintTextFormat.color = 0x888888;
			
			// change the textColor for errors
			mcNameField.errorTextFormat = TextFormatUtils.clone(mcNameField.defaultTextFormat);
			mcNameField.errorTextFormat.color = 0xFF0000;
			mcEmailField.errorTextFormat = TextFormatUtils.clone(mcEmailField.defaultTextFormat);
			mcEmailField.errorTextFormat.color = 0xFF0000;
			mcCompanyField.errorTextFormat = TextFormatUtils.clone(mcCompanyField.defaultTextFormat);
			mcCompanyField.errorTextFormat.color = 0xFF0000;
			mcCountryField.errorTextFormat = TextFormatUtils.clone(mcCountryField.defaultTextFormat);
			mcCountryField.errorTextFormat.color = 0xFF0000;
			
			// add the submit button
			_form.addSubmitButton(mcSubmitButton);

			// add the reset button
			_form.addResetButton(mcResetButton);
			
			// reset the form. By resetting the form all elements will be cleared.
			_form.reset();
			
			// set labels for RadioButtons and CheckBoxes
			mcGenderMaleRadioButton.html = false;
			mcGenderMaleRadioButton.autoSize = TextFieldAutoSize.LEFT;
			mcGenderMaleRadioButton.text = "Male";
			mcGenderFemaleRadioButton.autoSize = TextFieldAutoSize.LEFT;
			mcGenderFemaleRadioButton.text = "Female";
			
			mcNewsletterCheckBox.autoSize = TextFieldAutoSize.LEFT;
			mcNewsletterCheckBox.text = "Sign me up for the Newsletter";
			mcTermsCheckBox.autoSize = TextFieldAutoSize.LEFT;
			mcTermsCheckBox.text = "I agree to the terms";
			
			// enable submit on enter and spacebar on buttons
			mcResetButton.buttonBehavior.clickOnEnter = true;
			mcResetButton.buttonBehavior.clickOnSpacebar = true;
			mcSubmitButton.buttonBehavior.clickOnEnter = true;
			mcSubmitButton.buttonBehavior.clickOnSpacebar = true;
			mcPrefillButton.buttonBehavior.clickOnEnter = true;
			mcPrefillButton.buttonBehavior.clickOnSpacebar = true;
			
			// Set the labels of the buttons
			mcSubmitButton.text = "Submit";
			mcResetButton.text = "Reset";
			mcPrefillButton.text = "Prefill";
			
			// We add the mcPrefillButton to the tabFocusManager of the Form, so we can tab to this button
			_form.tabFocusManager.add(mcPrefillButton);
			
			mcPrefillButton.addEventListener(MouseEvent.CLICK, handlePrefillClick);
			
			// Listen to all FormEvents from the form
			EventUtils.addAll(FormEvent, _form, handleFormEvent);
		}

		private function handlePrefillClick(event:MouseEvent):void
		{
			// Prefill data
			_data.name = "Thijs";
			_data.email = "thijs@mediamonks.com";
			_data.company = "MediaMonks";
			_data.country = "NLD";
			_data.newsletter = true;
			_data.gender = "male";
			
			_form.prefill(_data);
		}

		private function handleFormEvent(event:FormEvent):void
		{
			switch(event.type)
			{
				case FormEvent.VALIDATE_SUCCESS:
				{
					logInfo("Validate success");
					break;
				}
				case FormEvent.VALIDATE_ERROR:
				{
					logError("Validate error: " + dump(event.result));
					break;
				}
				case FormEvent.SUBMIT_SUCCESS:
				{
					logInfo("Submit success: " + dump(event.result.data));
					break;
				}
				case FormEvent.SUBMIT_ERROR:
				{
					logError("Submit error");
					break;
				}
				case FormEvent.RESET:
				{
					logInfo("Reset");
					break;
				}
				default:
				{
					logError("handleFormEvent: unhandled event '" + event.type + "'");
					break;
				}
			}
		}
	}
}

// Private class for storing the data of the person
class PersonData
{
	public var name:String;
	public var email:String;
	public var company:String;
	public var gender:String;
	public var newsletter:Boolean;
	public var country:String;
}
