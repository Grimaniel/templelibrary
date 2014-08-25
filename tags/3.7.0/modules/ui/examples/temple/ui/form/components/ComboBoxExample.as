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
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/ui/examples/temple/ui/form/components/ComboBoxExample.fla" target="_blank">Download .fla file</a></p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/ui/examples/temple/ui/form/components/ComboBoxExample.as" target="_blank">View source</a></p>
 */
package  
{
	import temple.utils.types.TextFormatUtils;
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
			
			mcDataField.hintTextFormat = TextFormatUtils.clone(mcDataField.defaultTextFormat);
			mcDataField.hintTextFormat.color = Colors.GRAY;

			mcLabelField.hintTextFormat = TextFormatUtils.clone(mcLabelField.defaultTextFormat);
			mcLabelField.hintTextFormat.color = Colors.GRAY;

			mcIndexField.hintTextFormat = TextFormatUtils.clone(mcIndexField.defaultTextFormat);
			mcIndexField.hintTextFormat.color = Colors.GRAY;

			mcDataField.hintText = "data";
			mcLabelField.hintText = "label";
			mcIndexField.hintText = "index";
			
			mcIndexField.restrict = Restrictions.NUMERIC;

			mcDataField.reset();
			mcLabelField.reset();
			mcIndexField.reset();
			
			mcComboBox.addItems(["Apple", "Banana", "Orange", "Pear", "Raspberrie", "Grape", "Lemon", "Grapefruit", "Lime", "Mango"]);
			mcComboBox.addEventListener(Event.CHANGE, handleChange);
			
			mcAddItemButton.text = "addItem";
			mcAddItemAtButton.text = "addItemAt";
			mcGetItemAtButton.text = "getItemAt";
			mcSetItemAtButton.text = "setItemAt";
			mcGetLabelAtButton.text = "getLabelAt";
			mcSetLabelAtButton.text = "setLabelAt";
			mcRemoveItemButton.text = "removeItem";
			mcRemoveItemAtButton.text = "removeItemAt";
			mcRemoveAllButton.text = "removeAll";
			mcGetSelectedIndexButton.text = "getSelectedIndex";
			mcSetSelectedIndexButton.text = "setSelectedIndex";
			mcGetSelectedItemButton.text = "getSelectedItem";
			mcSetSelectedItemButton.text = "setSelectedItem";
			mcGetSelectedLabelButton.text = "getSelectedLabel";
			mcSetSelectedLabelButton.text = "setSelectedLabel";
			mcOpenButton.text = "open";
			mcCloseButton.text = "close";
			mcAutoCloseButton.text = "autoClose " + (mcComboBox.autoClose ? "on" : "off");
			
			addEventListener(MouseEvent.CLICK, handleClick);
		}

		private function handleClick(event:MouseEvent):void
		{
			switch(event.target)
			{
				case mcAddItemButton:
				{
					mcComboBox.addItem(mcDataField.value, mcLabelField.value || null);
					break;
				}
				case mcAddItemAtButton:
				{
					mcComboBox.addItemAt(mcDataField.value, mcIndexField.value, mcLabelField.value || null);
					break;
				}
				case mcGetItemAtButton:
				{
					mcDataField.text = mcComboBox.getItemAt(int(mcIndexField.text));
					break;
				}
				case mcSetItemAtButton:
				{
					mcComboBox.setItemAt(mcDataField.text, int(mcIndexField.text), mcLabelField.text || null);
					break;
				}
				case mcGetLabelAtButton:
				{
					mcLabelField.text = mcComboBox.getLabelAt(int(mcIndexField.text));
					break;
				}
				case mcSetLabelAtButton:
				{
					mcComboBox.setLabelAt(int(mcIndexField.text), mcLabelField.text);
					break;
				}
				case mcRemoveItemButton:
				{
					mcComboBox.removeItem(mcDataField.value, mcLabelField.value || null);
					break;
				}
				case mcRemoveItemAtButton:
				{
					mcComboBox.removeItemAt(int(mcIndexField.text));
					break;
				}
				case mcRemoveAllButton:
				{
					mcComboBox.removeAll();
					break;
				}
				case mcGetSelectedIndexButton:
				{
					mcIndexField.text = mcComboBox.selectedIndex.toString();
					break;
				}
				case mcSetSelectedIndexButton:
				{
					mcComboBox.selectedIndex = int(mcIndexField.text);
					break;
				}
				case mcGetSelectedItemButton:
				{
					mcDataField.text = mcComboBox.selectedItem;
					break;
				}
				case mcSetSelectedItemButton:
				{
					mcComboBox.selectedItem = mcDataField.text;
					break;
				}
				case mcGetSelectedLabelButton:
				{
					mcLabelField.text = mcComboBox.selectedLabel;
					break;
				}
				case mcSetSelectedLabelButton:
				{
					mcComboBox.selectedLabel = mcLabelField.text;
					break;
				}
				case mcOpenButton:
				{
					mcComboBox.open();
					break;
				}
				case mcCloseButton:
				{
					mcComboBox.close();
					break;
				}
				case mcAutoCloseButton:
				{
					mcComboBox.autoClose = !mcComboBox.autoClose;
					mcAutoCloseButton.text = "autoClose " + (mcComboBox.autoClose ? "on" : "off");
					break;
				}
			}
		}

		private function handleChange(event:Event):void
		{
			mcDataField.text = mcComboBox.selectedItem;
			mcLabelField.text = mcComboBox.selectedLabel;
			mcIndexField.text = mcComboBox.selectedIndex.toString();
		}

		override public function destruct():void
		{
			mcComboBox = null;
			super.destruct();
		}
	}
}
