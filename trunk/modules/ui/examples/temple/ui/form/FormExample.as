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
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/ui/examples/D:/Projects/Temple/GoogleCode/templelibrary/modules/ui/examples/temple/ui/form/FormExample.fla" target="_blank">Download .fla file</a></p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/ui/examples/temple/ui/form/FormExample.as" target="_blank">View source</a></p>
 */
package
{
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
			this._data = new PersonData();
			
			// create a new Form with a FormObjectService as service. Pass the PersonData object as object.
			this._form = new Form(new ObjectFormService(this._data));
			
			// enable debug, so debug infomation is logged
			this._form.debug = true;
			
			// add InputFields to the Form. Note: the 'name' property (2nd parameter) must match the corresponding property value of the PersonData object, since we want to store the data in that object.
			this._form.addElement(this.mcNameField, "name", EmptyStringValidationRule, "Please fill in your name"); // EmptyStringValidationRule means: this field can not be empty. 
			this._form.addElement(this.mcEmailField, "email", EmailValidationRule, "Please fill in a correct e-mailaddress"); // EmailValidationRule means: this field must contain an emailaddress.
			this._form.addElement(this.mcCompanyField, "company");
			this._form.addElement(this.mcCountryField, "country", NullValidationRule, "Please select your country"); // NullValidationRule: a ComboBox returns null when no item is selected.
			
			// fill country ComboBox with some countries. We use the ISO code as data. (For this case we don't add all countries of the world, since the example would be too large. But ofcourse you can add all the countries you want.)
			this.mcCountryField.addItem("BEL","Belgium");
			this.mcCountryField.addItem("CZE","Czech Republic");
			this.mcCountryField.addItem("DNK","Denmark");
			this.mcCountryField.addItem("EST","Estonia");
			this.mcCountryField.addItem("FRA","France");
			this.mcCountryField.addItem("DEU","Germany");
			this.mcCountryField.addItem("GRC","Greece");
			this.mcCountryField.addItem("GRL","Greenland");
			this.mcCountryField.addItem("HUN","Hungary");
			this.mcCountryField.addItem("ISL","Iceland");
			this.mcCountryField.addItem("IRL","Ireland");
			this.mcCountryField.addItem("ITA","Italy");
			this.mcCountryField.addItem("JPN","Japan");
			this.mcCountryField.addItem("LUX","Luxembourg");
			this.mcCountryField.addItem("MEX","Mexico");
			this.mcCountryField.addItem("NLD","Netherlands");
			this.mcCountryField.addItem("NZL","New Zealand");
			this.mcCountryField.addItem("NOR","Norway");
			this.mcCountryField.addItem("PER","Peru");
			this.mcCountryField.addItem("POL","Poland");
			this.mcCountryField.addItem("PRT","Portugal");
			this.mcCountryField.addItem("ROU","Romania");
			this.mcCountryField.addItem("RWA","Rwanda");
			this.mcCountryField.addItem("SGP","Singapore");
			this.mcCountryField.addItem("ZAF","South Africa");
			this.mcCountryField.addItem("ESP","Spain");
			this.mcCountryField.addItem("SWE","Sweden");
			this.mcCountryField.addItem("CHE","Switzerland");
			this.mcCountryField.addItem("THA","Thailand");
			this.mcCountryField.addItem("TUR","Turkey");
			this.mcCountryField.addItem("UGA","Uganda");
			this.mcCountryField.addItem("UKR","Ukraine");
			this.mcCountryField.addItem("GBR","United Kingdom");
			this.mcCountryField.addItem("USA","United States");
			this.mcCountryField.addItem("ZWE","Zimbabwe");
						
			
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
			this.mcCountryField.hintText = "select your country...";
			
			// change the color of the hintText
			this.mcNameField.hintTextColor = 0x888888;
			this.mcEmailField.hintTextColor = 0x888888;
			this.mcCompanyField.hintTextColor = 0x888888;
			this.mcCountryField.hintTextColor = 0x888888;

			// change the textColor for errors
			this.mcNameField.errorTextColor = 0xFF0000;
			this.mcEmailField.errorTextColor = 0xFF0000;
			this.mcCompanyField.errorTextColor = 0xFF0000;
			this.mcCountryField.errorTextColor = 0xFF0000;
			
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
			
			// enable submit on enter and spacebar on buttons
			this.mcResetButton.buttonBehavior.clickOnEnter = true;
			this.mcResetButton.buttonBehavior.clickOnSpacebar = true;
			this.mcSubmitButton.buttonBehavior.clickOnEnter = true;
			this.mcSubmitButton.buttonBehavior.clickOnSpacebar = true;
			this.mcPrefillButton.buttonBehavior.clickOnEnter = true;
			this.mcPrefillButton.buttonBehavior.clickOnSpacebar = true;
			
			// Set the labels of the buttons
			this.mcSubmitButton.label = "Submit";
			this.mcResetButton.label = "Reset";
			this.mcPrefillButton.label = "Prefill";
			
			// We add the mcPrefillButton to the tabFocusManager of the Form, so we can tab to this button
			this._form.tabFocusManager.add(this.mcPrefillButton);
			
			this.mcPrefillButton.addEventListener(MouseEvent.CLICK, this.handlePrefillClick);
			
			// Listen to all FormEvents from the form
			EventUtils.addAll(FormEvent, this._form, this.handleFormEvent);
		}

		private function handlePrefillClick(event:MouseEvent):void
		{
			// Prefill data
			this._data.name = "Thijs";
			this._data.email = "thijs@mediamonks.com";
			this._data.company = "MediaMonks";
			this._data.country = "NLD";
			this._data.newsletter = true;
			this._data.gender = "male";
			
			this._form.prefillData(this._data);
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
					logError("Validate error: " + ObjectUtils.traceObject(event.result, 3, false));
					break;
				}
				case FormEvent.SUBMIT_SUCCESS:
				{
					logInfo("Submit success: " + ObjectUtils.traceObject(event.result.data, 3, false));
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
					this.logError("handleFormEvent: unhandled event '" + event.type + "'");
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
