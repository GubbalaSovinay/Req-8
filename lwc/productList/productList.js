import { LightningElement, api } from 'lwc';

import getProductsData from '@salesforce/apex/AddressController.getProductsData';

import getProductsDataByOrderSummaryId from '@salesforce/apex/AddressController.getProductsDataByOrderSummaryId';



export default class B2BProductsDisplayCheckout extends LightningElement {



    @api cartId;

    @api orderSummaryId;

    products;




    getProducts()

    {

        getProductsData({cartId : this.cartId})

        .then(result=>{

            console.log(result);

            this.products = result;

        })

        .catch(error=>{

            console.log('** error' + JSON.stringify(error));

        });

    }



    getProductsByOrderSummaryId()

    {

        console.log(this.orderSummaryId);

        getProductsDataByOrderSummaryId({orderSummaryId : this.orderSummaryId})

        .then(result=>{

            console.log(result);

            this.products = result;

        })

        .catch(error=>{

            console.log('** error' + JSON.stringify(error));

        });

    }



    connectedCallback()

    {

        if(this.orderSummaryId!=null)

        {

            this.getProductsByOrderSummaryId();

        }

        else{

            this.getProducts();

        }  

    }

}