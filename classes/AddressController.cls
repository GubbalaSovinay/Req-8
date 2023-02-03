public with sharing class AddressController {
    public AddressController() {
         /*
         List<ContactPointAddress> result = [SELECT Address,	AddressType,ParentId FROM ContactPointAddress WHERE ParentId = '001DM000027xQJ1YAM'];
        for(ContactPointAddress c : result)
        {
            Address add = c.Address;
            System.debug(add.getCity() + ' ' + c.Id);
        }
         */
    }  
    @AuraEnabled
    public static Map<Id,String> getShippingAddress(Id cartId){
        try {
        
            Map<Id,String> shippingMap = new Map<Id,String>(); 
            List<WebCart> cartList = [SELECT AccountId FROM WebCart WHERE id=: cartId];
            Id accountId = cartList[0].AccountId;
            List<ContactPointAddress> result = [SELECT Id,Name,Address,AddressType,ParentId,IsDefault FROM ContactPointAddress WHERE ParentId =:accountId AND AddressType ='Shipping'];
            for(ContactPointAddress c : result)
            {
                
                /*Address add = c.Address;
                String street = add.getStreet();
                String city = add.getCity();
                String state = add.getState();
                String country = add.getCountry();
                String postalCode = add.getPostalCode();*/
                Boolean isDefault = c.IsDefault;
                String name = c.Name;
                String isDefault1 = isDefault ? 'true' : 'false';
                //String shippingAddress = street+','+city+','+state+','+country+','+postalcode+'/'+isDefault1;
                String shippingAddress = name+'/'+isDefault1;
                Id addressId = c.Id;
                String addressType= c.AddressType;
               
                shippingMap.put(addressId,shippingAddress);

            }
            for(Id	key: shippingMap.keyset())
            {
                String add = shippingMap.get(key);
                System.debug(key +':'+add);
            }
            return shippingMap;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Map<String,String> handlerShippingAddress(Id addressId){
        try {
            List<ContactPointAddress> result = [SELECT Name,Address,IsDefault FROM ContactPointAddress WHERE id=:addressId];
            result[0].IsDefault = true;
            update result;
            Map<String,String> Map1 = new Map<String,String>();
            Address add = result[0].Address;
            Map1.put('street',add.getStreet());
            Map1.put('city',add.getCity());
            Map1.put('state',add.getState());
            Map1.put('country',add.getCountry());
            Map1.put('postalCode',add.getPostalCode());

            /*String street = add.getStreet();
            String city = add.getCity();
            String state = add.getState();
            String country = add.getCountry();
            String postalCode = add.getPostalCode();*/
            system.debug(Map1);
            return Map1;
                        
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

  /*  @AuraEnabled
    public static Map<String,String> handlerShippingAddress(Id cartId,String addressType){
        try {
            List<WebCart> accountIdList = [SELECT AccountId FROM WebCart WHERE id=: cartId];
            String accountId = accountIdList[0].AccountId;
            List<ContactPointAddress> result = new List<ContactPointAddress>();

            if(addressType == 'Shipping'){
                result = [SELECT Address FROM ContactPointAddress WHERE ParentId=:accountId AND IsDefault = true AND AddressType = 'Shipping' ];
            }
            else if(addressType == 'Billing')
            {
                 result = [SELECT Address FROM ContactPointAddress WHERE ParentId=:accountId AND IsDefault = true AND AddressType = 'Billing' ];
            }
            
            result[0].IsDefault = true;
            update result;
            Map<String,String> Map1 = new Map<String,String>();
            Address add = result[0].Address;
            Map1.put('street',add.getStreet());
            Map1.put('city',add.getCity());
            Map1.put('state',add.getState());
            Map1.put('country',add.getCountry());
            Map1.put('postalCode',add.getPostalCode());
            system.debug(Map1);
            return Map1;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }*/

    @AuraEnabled
    public static Map<Id,String> getBillingAddress(Id cartId){
        try {
            Map<Id,String> billingMap = new Map<Id,String>(); 
            List<WebCart> cartList = [SELECT AccountId FROM WebCart WHERE id=:cartId];
            Id accountId = cartList[0].AccountId;
            List<ContactPointAddress> result = [SELECT Id,Name,Address,AddressType,ParentId,IsDefault FROM ContactPointAddress WHERE ParentId =:accountId AND AddressType ='Billing'];
            for(ContactPointAddress c : result)
            {
                
                /*Address add = c.Address;
                String street = add.getStreet();
                String city = add.getCity();
                String state = add.getState();
                String country = add.getCountry();
                String postalCode = add.getPostalCode();*/
                Boolean isDefault = c.IsDefault;
                String isDefault1 = isDefault ? 'true' : 'false';
                String name = c.Name;
                //String billingAddress = street+','+city+','+state+','+country+','+postalcode+'/'+isDefault1;
                String billingAddress = name+'/'+isDefault1;
                Id addressId = c.Id;
                String addressType= c.AddressType;
               
                billingMap.put(addressId,billingAddress);

            }
            for(Id	key: billingMap.keyset())
            {
                String add = billingMap.get(key);
                System.debug(key +':'+add);
            }
            return billingMap;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static string createShipingAddress(String name,String street,String city,String state, String country,
                                                String postalCode,Boolean isDefault,Boolean saveAddress,Id cartId ){
        try {
            String mssg ='not inserted';
            List<WebCart> cartList = [SELECT AccountId FROM WebCart WHERE id=: cartId];
            Id accountId = cartList[0].AccountId;
            if(name!=null && city != null && state != null && country != null && postalCode!=null && saveAddress == true)
            {

                ContactPointAddress address2=new ContactPointAddress();
                address2.Street=street;
                address2.City=city;
                address2.State=state;
                address2.Country=country;
                address2.PostalCode=postalCode;
                address2.IsDefault = isDefault;
                address2.Name = name;
                address2.ParentId=accountId;
                address2.AddressType='Shipping';
                insert address2;
                mssg = 'Inserted';   
            }
            else if(name!=null && city != null && state != null && country != null && postalCode!=null && saveAddress == false)
            {
                mssg = 'Not Saved';
            }
            
            return mssg;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    /*@AuraEnabled
    public static Map<String,String> getCartDeliveryGroup(Id cartId){
        try {
            list<CartDeliveryGroup> result = [SELECT ShippingInstructions,TotalProductAmount,TotalChargeAmount,
                                                    TotalTaxAmount,TotalAmount FROM CartDeliveryGroup WHERE CartId=: cartId];
            Map<String,String> returnMap = new Map<String,String>();
            returnMap.put('ShippingInstruction',result[0].ShippingInstructions);
            returnMap.put('SubTotal',String.valueOf(result[0].TotalProductAmount.format()));
            returnMap.put('ShippingCost',String.valueOf(result[0].TotalChargeAmount.format()));
            returnMap.put('Tax',String.valueOf(result[0].TotalProductAmount.format()));
            returnMap.put('TotalAmount',String.valueOf(result[0].TotalAmount.format()));

            return returnMap;

            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }*/

    @AuraEnabled
    public static List<CartItem> getProductsData(String cartId){

        try {
            List<CartItem> cartItems = [SELECT  Name, Sku, Quantity ,ListPrice, TotalPrice FROM CartItem WHERE CartId=:cartId AND Sku!=null];
            return cartItems;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled
    public static List<OrderItemSummary> getProductsDataByOrderSummaryId(String orderSummaryId){
        try {
            List<OrderItemSummary> OSItems = [SELECT  Name, StockKeepingUnit, Quantity ,ListPrice, TotalPrice FROM OrderItemSummary WHERE OrderSummaryId=:orderSummaryId AND StockKeepingUnit!=null];
            return OSItems;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}
