import { LightningElement, wire, track, api } from 'lwc';


export default class LwcHooksParent extends LightningElement {


testVariableConstructer;
testVariableConnectedCallback;
testVariableRenderedCallback;
@api recordId;
@api objectApiName;
@api flowInputName;
@api  recordpageName;

    constructor(){
        super();
        this.testVariable = 'Test Variable Value from Constructor';
         console.log('LwcHooksParent Constructor Called' + this.testVariable);
         console.log(' ConstructorRecord Id in Parent LWC: ' + this.recordId);
         console.log(' ConstructorObject Api Name in Parent LWC: ' + this.objectApiName);
         console.log(' ConstructorFlow Input Name in Parent LWC: ' + this.flowInputName);
         console.log(' Constructor Record Page Name in Parent LWC: ' + this.recordpageName);
    }

    connectedCallback(){
        
          this.testVariableConnectedCallback = 'Test Variable Value from Connected Callback';
          console.log('LwcHooksParent connectedCallback Called' + this.testVariableConnectedCallback);
             console.log(' ConnecteCallback Record Id in Parent LWC: ' + this.recordId);
         console.log(' ConnecteCallback Object Api Name in Parent LWC: ' + this.objectApiName);
         console.log(' ConnecteCallback Flow Input Name in Parent LWC: ' + this.flowInputName);
         console.log(' ConnecteCallback Record Page Name in Parent LWC: ' + this.recordpageName);
    }

    renderedCallback(){
       
        this.testVariableRenderedCallback = 'Test Variable Value from Rendered Callback';
        console.log('LwcHooksParent renderedCallback Called' + this.testVariableRenderedCallback);
    }

    /*render(){
        console.log('LwcHooksParent render method Called');
    }
        */

    disconnectedCallback(){
        console.log('LwcHooksParent disconnectedCallback Called');
        this.testVariableRenderedCallback = null;
        this.testVariableConnectedCallback = null;
        this.testVariableConstructer = null;
        console.log('LwcHooksParent disconnectedCallback Called' +
             this.testVariable, this.testVariableConnectedCallback, this.testVariableRenderedCallback );
    }

}