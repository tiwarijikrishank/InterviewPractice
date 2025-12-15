import { LightningElement, wire } from 'lwc'
import getContactsWithName from '@salesforce/apex/lwcMethodsController.getContactsWithName'
import refreshApex from '@salesforce/apex'
import updateContactName from '@salesforce/apex/lwcMethodsController.updateContactName'


const columns = [
	{ label: 'Name', fieldName: 'Name', type: 'text', editable: true },
	{ label: 'Email', fieldName: 'Email', type: 'text' },
	{ label: 'Phone', fieldName: 'Phone', type: 'text' }
]
export default class LwcMethods extends LightningElement {
	contactList = [];
	accountName;
	contactNameToSearch;
	inputContactName;
	columns = columns;

	@wire(getContactsWithName,{ nameSearch : '$contactNameToSearch'})
		contacts({data,error})
		{
			if(data){
					this.contactList = data;
					console.log('Contacts fetched successfully: ' + JSON.stringify(this.contactList));
			}
			if(error){
					console.error('Error fetching contacts: ' + JSON.stringify(error));
			}
		}

		handleChange(event){
			this.inputContactName = event.target.value; 
		}

		handleSearch(){
			if(this.inputContactName) {
				this.contactNameToSearch = this.inputContactName;
			}
			}
		async handleSave(event){
			const updatedValue = event.target.draftValues;
			console.log('Updated Value: ' + JSON.stringify(updatedValue));
			updateContactName({searchContactName : this.contactNameToSearch,  contactName: updatedValue[0].Name}).then(
				() =>{
					console.log('Contact name updated successfully');
					this.contactList = [];
					this.contactNameToSearch =  updatedValue[0].Name;
				}
			).catch((error) => {
				console.error('Error updating contact name: ' + JSON.stringify(error));
			})
			await refreshApex (this.contacts);
		}
		
	}