import { LightningElement, wire } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

// Custom Labels
import LABEL_SAVE from "@salesforce/label/c.SaveButton";
import LABEL_CANCEL from "@salesforce/label/c.CancelButton";
import LABEL_UPDATE from "@salesforce/label/c.UpdateButton";
import LABEL_OPPORTUNITY_NAME from "@salesforce/label/c.Name";
import LABEL_OPPORTUNITY_STAGE from "@salesforce/label/c.Stage";
import SUCCESS_TOAST from "@salesforce/label/c.SuccessToast";
import ERROR_TOAST from "@salesforce/label/c.ErrorToast";
// Opportunity Object
import OPPORTUNITY_OBJECT from "@salesforce/schema/Opportunity";
// Opportunity Fields
import NAME_FIELD from "@salesforce/schema/Opportunity.Name";
import STAGE_FIELD from "@salesforce/schema/Opportunity.StageName";
// Apex Methods
import apex_displayMyOpportunities from "@salesforce/apex/CTRL_MyOpportunities.getOpportunities";
import apex_updateMyOpportunities from "@salesforce/apex/CTRL_MyOpportunities.updateOpportunities";

export default class DisplayMyOpportunities extends LightningElement {
  columns = [
    { label: LABEL_OPPORTUNITY_NAME, fieldName: NAME_FIELD.fieldApiName },
    { label: LABEL_OPPORTUNITY_STAGE, fieldName: STAGE_FIELD.fieldApiName }
  ];
  buttonLabels = { LABEL_SAVE, LABEL_CANCEL, LABEL_UPDATE };
  toastLabels = { SUCCESS_TOAST, ERROR_TOAST };
  opportunityObject = OPPORTUNITY_OBJECT;
  stageField = STAGE_FIELD;

  showModal = false; // {Boolean} To show and hide modal for selecting Stage value
  isProcessing = true;
  errorOccurred = false; // {Boolean} Tracked variable to indicate if an error occurred on the page
  errorMessage; // {String} Error message to display when error occurs on page

  showButtonGroup = false; // {Boolean} To hide or un-hide an update and button until user has selected at least one record
  opportunities; // The opportunities created by a user
  selectedRecords = []; // List of opportunity records which are selected by a user to be updated
  selectedStage; // The stage selected to be updated for the selected records

  // Call Apex method to retrieve all opportunities
  @wire(apex_displayMyOpportunities)
  retrieveOpportunities({ data, error }) {
    this.refreshVariable = data;
    if (data) {
      this.isProcessing = false;
      this.opportunities = data;
    } else if (error) {
      this.errorOccurred = true;
      this.errorMessage = error;
    }
  }

  showModalBox() {
    this.showModal = true;
  }

  hideModalBox() {
    this.showModal = false;
  }

  // To hide/un-hide Update and Cancel button until a record is selected
  handleRowClick() {
    this.selectedRecords = this.template.querySelector("lightning-datatable").getSelectedRows();
    this.showButtonGroup = this.selectedRecords.length > 0;
  }

  // Call Apex method to update stage for the selected opportunities
  async handleSave() {
    this.selectedStage = this.template.querySelector(
      'lightning-input-field[data-name="stage"]'
    ).value;
    apex_updateMyOpportunities({
      opportunities: this.selectedRecords,
      stageName: this.selectedStage
    })
      .then((data) => {
        this.opportunities = data;
        this.showToast(this, this.toastLabels.SUCCESS_TOAST, "success");
      })
      .catch((error) => {
        this.errorOccurred = true;
        this.errorMessage = error;
        this.showToast(this, this.toastLabels.ERROR_TOAST, "error");
      });

    this.showButtonGroup = false;
    this.hideModalBox();
    this.template.querySelector("lightning-datatable").selectedRows = [];
  }

  // Deselect the records on click of Cancel button and hide the Update and Cancel buttons
  handleCancel() {
    this.showButtonGroup = false;
    this.template.querySelector("lightning-datatable").selectedRows = [];
  }

  showToast(context, title, variant) {
    context.dispatchEvent(
      new ShowToastEvent({
        title: title,
        variant: variant
      })
    );
  }
}