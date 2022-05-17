import { LightningElement, wire, track, api } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import Razorpay from '@salesforce/resourceUrl/RazorpayCheckout';
import createInvoiceRec from '@salesforce/apex/RazorpayPaymentHandler.createInvoiceRec';
import sendPaymentLink from '@salesforce/apex/RazorpayPaymentHandler.sendPaymentLink';

import { CloseActionScreenEvent } from 'lightning/actions';


export default class PaymentIntegration extends LightningElement {
    // devRazorPayCred
    //     id - rzp_test_UJ6CeLOw4o6n89
    //     key - S6PdyPzfyds12aPkkH0CKrQP

    @api recordId;

    @wire(sendPaymentLink, { recordId: "$recordId" })
    paymentResp(result) {
        debugger;
        if (result.data && result.data.accept_partial) {
            console.log(result);
            alert('Paymet Sent Successfully');
            this.createInvoice();
            this.closeAction();
        } else if (!this.recordId && !result.data) {
            console.log('Payment Initated ----------------------')
        } else if (this.recordId && !result.data) {
            alert('Payment Failed');
            this.closeAction();
        }
    }
    createInvoice() {
        createInvoiceRec({ recordId: this.recordId }).then(result => {
            console.log("Creating Reccc----", result);
            console.log("RESULT----", result);
        }).catch(error => {
            console.log("Error Occureed----", result);
            console.log("Errorr----", error);
        })
    }
    closeAction() {
        this.dispatchEvent(new CloseActionScreenEvent());
    }

}