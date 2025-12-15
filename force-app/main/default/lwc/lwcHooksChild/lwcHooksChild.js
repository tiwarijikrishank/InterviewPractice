import { LightningElement, wire, track, api } from 'lwc';


export default class LwcHooksChild extends LightningElement {


testVariableConstructer;
testVariableConnectedCallback;
testVariableRenderedCallback;
@api  fromParent;

    constructor(){
        super();
        this.testVariable = 'Test Variable Value from Constructor';
         console.log('LwcHooksChild Constructor Called' + this.testVariable);
    }

    connectedCallback(){
        
          this.testVariableConnectedCallback = 'Test Variable Value from Connected Callback';
          console.log('LwcHooksChild connectedCallback Called' + this.testVariableConnectedCallback);
                console.log(' ConnecteCallback from Parent LWC: ' + this.fromParent);
    }

    renderedCallback(){
       
        this.testVariableRenderedCallback = 'Test Variable Value from Rendered Callback';
        console.log('LwcHooksChild renderedCallback Called' + this.testVariableRenderedCallback);
    }

    /*render(){
        console.log('LwcHooksChild render method Called');
    }
        */

    disconnectedCallback(){
        console.log('LwcHooksChild disconnectedCallback Called');
    }

}