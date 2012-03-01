/**
 * @exampleText
 * 
 * <a name="ComboBox"></a>
 * <h1>ComboBox</h1>
 * 
 * <p>This is an example about the usage of the <a href="http://templelibrary.googlecode.com/svn/trunk/modules/ui/doc/temple/ui/form/components/ComboBox.html">ComboBox</a>.</p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/ui/examples/temple/ui/form/components/ComboBoxExample.swf" target="_blank">View this example</a></p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/ui/examples/D:/Projects/Temple/GoogleCode/templelibrary/modules/ui/examples/temple/ui/form/components/ComboBoxExample.fla" target="_blank">Download .fla file</a></p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/ui/examples/temple/ui/form/components/ComboBoxExample.as" target="_blank">View source</a></p>
 */
package  
{
	import temple.ui.buttons.LabelButton;
	import temple.ui.form.components.ComboBox;
	import temple.ui.form.components.InputField;
	import temple.ui.form.validation.rules.Restrictions;
	import temple.utils.color.Colors;

	import flash.events.Event;
	import flash.events.MouseEvent;

	public class ComboBoxExample extends DocumentClassExample 
	{
		public var mcComboBox:ComboBox;
		public var mcDataField:InputField;
		public var mcLabelField:InputField;
		public var mcIndexField:InputField;
		
		public var mcAddItemButton:LabelButton;
		public var mcAddItemAtButton:LabelButton;
		
		public var mcGetItemAtButton:LabelButton;
		public var mcSetItemAtButton:LabelButton;
		public var mcGetLabelAtButton:LabelButton;
		public var mcSetLabelAtButton:LabelButton;

		public var mcRemoveItemButton:LabelButton;
		public var mcRemoveItemAtButton:LabelButton;
		public var mcRemoveAllButton:LabelButton;

		public var mcGetSelectedIndexButton:LabelButton;
		public var mcSetSelectedIndexButton:LabelButton;
		public var mcGetSelectedItemButton:LabelButton;
		public var mcSetSelectedItemButton:LabelButton;
		public var mcGetSelectedLabelButton:LabelButton;
		public var mcSetSelectedLabelButton:LabelButton;
		
		public var mcOpenButton:LabelButton;
		public var mcCloseButton:LabelButton;
		public var mcAutoCloseButton:LabelButton;

		public function ComboBoxExample()
		{
			super("ComboBoxExample");
			
			this.mcDataField.hintTextColor = Colors.GRAY;
			this.mcLabelField.hintTextColor = Colors.GRAY;
			this.mcIndexField.hintTextColor = Colors.GRAY;

			this.mcDataField.hintText = "data";
			this.mcLabelField.hintText = "label";
			this.mcIndexField.hintText = "index";
			
			this.mcIndexField.restrict = Restrictions.NUMERIC;

			this.mcDataField.reset();
			this.mcLabelField.reset();
			this.mcIndexField.reset();
			
			this.mcComboBox.addItems(["Apple", "Banana", "Orange", "Pear", "Raspberrie", "Grape", "Lemon", "Grapefruit", "Lime", "Mango"]);
			this.mcComboBox.addEventListener(Event.CHANGE, this.handleChange);
			
			this.mcAddItemButton.label = "addItem";
			this.mcAddItemAtButton.label = "addItemAt";
			this.mcGetItemAtButton.label = "getItemAt";
			this.mcSetItemAtButton.label = "setItemAt";
			this.mcGetLabelAtButton.label = "getLabelAt";
			this.mcSetLabelAtButton.label = "setLabelAt";
			this.mcRemoveItemButton.label = "removeItem";
			this.mcRemoveItemAtButton.label = "removeItemAt";
			this.mcRemoveAllButton.label = "removeAll";
			this.mcGetSelectedIndexButton.label = "getSelectedIndex";
			this.mcSetSelectedIndexButton.label = "setSelectedIndex";
			this.mcGetSelectedItemButton.label = "getSelectedItem";
			this.mcSetSelectedItemButton.label = "setSelectedItem";
			this.mcGetSelectedLabelButton.label = "getSelectedLabel";
			this.mcSetSelectedLabelButton.label = "setSelectedLabel";
			this.mcOpenButton.label = "open";
			this.mcCloseButton.label = "close";
			this.mcAutoCloseButton.label = "autoClose " + (this.mcComboBox.autoClose ? "on" : "off");
			
			this.addEventListener(MouseEvent.CLICK, this.handleClick);
		}

		private function handleClick(event:MouseEvent):void
		{
			switch(event.target)
			{
				case this.mcAddItemButton:
				{
					this.mcComboBox.addItem(mcDataField.value, mcLabelField.value || null);
					break;
				}
				case this.mcAddItemAtButton:
				{
					this.mcComboBox.addItemAt(mcDataField.value, mcIndexField.value, mcLabelField.value || null);
					break;
				}
				case mcGetItemAtButton:
				{
					this.mcDataField.text = this.mcComboBox.getItemAt(int(this.mcIndexField.text));
					break;
				}
				case mcSetItemAtButton:
				{
					this.mcComboBox.setItemAt(this.mcDataField.text, int(this.mcIndexField.text), this.mcLabelField.text || null);
					break;
				}
				case mcGetLabelAtButton:
				{
					this.mcLabelField.text = this.mcComboBox.getLabelAt(int(this.mcIndexField.text));
					break;
				}
				case mcSetLabelAtButton:
				{
					this.mcComboBox.setLabelAt(int(this.mcIndexField.text), this.mcLabelField.text);
					break;
				}
				case mcRemoveItemButton:
				{
					this.mcComboBox.removeItem(mcDataField.value, mcLabelField.value || null);
					break;
				}
				case mcRemoveItemAtButton:
				{
					this.mcComboBox.removeItemAt(int(this.mcIndexField.text));
					break;
				}
				case mcRemoveAllButton:
				{
					this.mcComboBox.removeAll();
					break;
				}
				case mcGetSelectedIndexButton:
				{
					this.mcIndexField.text = this.mcComboBox.selectedIndex.toString();
					break;
				}
				case mcSetSelectedIndexButton:
				{
					this.mcComboBox.selectedIndex = int(this.mcIndexField.text);
					break;
				}
				case mcGetSelectedItemButton:
				{
					this.mcDataField.text = this.mcComboBox.selectedItem;
					break;
				}
				case mcSetSelectedItemButton:
				{
					this.mcComboBox.selectedItem = this.mcDataField.text;
					break;
				}
				case mcGetSelectedLabelButton:
				{
					this.mcLabelField.text = this.mcComboBox.selectedLabel;
					break;
				}
				case mcSetSelectedLabelButton:
				{
					this.mcComboBox.selectedLabel = this.mcLabelField.text;
					break;
				}
				case this.mcOpenButton:
				{
					this.mcComboBox.open();
					break;
				}
				case this.mcCloseButton:
				{
					this.mcComboBox.close();
					break;
				}
				case this.mcAutoCloseButton:
				{
					this.mcComboBox.autoClose = !this.mcComboBox.autoClose;
					this.mcAutoCloseButton.label = "autoClose " + (this.mcComboBox.autoClose ? "on" : "off");
					break;
				}
			}
		}

		private function handleChange(event:Event):void
		{
			this.mcDataField.text = this.mcComboBox.selectedItem;
			this.mcLabelField.text = this.mcComboBox.selectedLabel;
			this.mcIndexField.text = this.mcComboBox.selectedIndex.toString();
		}

		override public function destruct():void
		{
			this.mcComboBox = null;
			super.destruct();
		}
	}
}
