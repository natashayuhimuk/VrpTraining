public with sharing class OrderingController {

   public List<Product_Table__c> productsById = new List<Product_Table__c>();
   public String productId;

    public OrderingController() {
        this.unitPrice = 0;
        this.unitAmount = 1;
        this.totalAmount = 0;
 }

    public Decimal unitPrice ;
    public String firstName{
        get; set;
    }
    public String lastName{
        get; set;
    }
    public String email{
        get; set;
    }
      public Decimal unitAmount{
        get; set;
    }

    public Decimal totalAmount{
        get; set;
	}

    public PageReference incrementTotalAmount(){

        this.totalAmount = this.unitAmount*this.unitPrice;
        return null;
    }

     public Contact getContacts()
     {
         Contact cont = new Contact();
         return cont;
     }

   public String getProductId(){

        productId = System.currentPagereference().getParameters().get('productId');
        return productId;
    }

    public Product_Table__c  getProductById(){

        String productId = getProductId();
         productsById = Database.query(
        'SELECT  Name, Image_URL__c, Unit_Price__c, Product_Description__c, Units_Available__c '+
           'FROM Product_Table__c WHERE id =\'' + productId + '\''
        );
        this.unitPrice = productsById.get(0).Unit_Price__c;
        incrementTotalAmount();

        return productsById.get(0);
    }

    public PageReference getUserCreateOrder(){

        Integer avaiableAfterOrder = Integer.valueOf(this.productsById.get(0).Units_Available__c) - Integer.valueOf(this.unitAmount);

        if(avaiableAfterOrder < 0){
            System.debug('Error, No units for buy');
            return null;
        }

        List<Contact> contacts = Database.query(
        'SELECT id, FirstName, LastName, Email '+
           'FROM Contact WHERE Email =\'' + this.email + '\''
            + 'limit 100'
        );

        Contact userContact = new Contact();

        if(!contacts.isEmpty() ){
            userContact = contacts.get(0);
            update userContact;
        }

        else{
            userContact.FirstName = this.firstName;
            userContact.LastName = this.lastName;
            userContact.Email = this.email;
			
            
            //userContact  = contacts.get(0);    
            contacts.add(userContact);
            insert contacts;
        }

       List<Contact> newUserContact = Database.query(
        'SELECT id, FirstName, LastName, Email '+
           'FROM Contact WHERE Email =\'' + this.email + '\''
           + 'limit 10'
        );

        Order_Table__c newRecordOrder = new Order_Table__c();
        newRecordOrder.Product__c = this.productsById.get(0).id;
        newRecordOrder.Units__c = this.unitAmount;
        newRecordOrder.Order_Amount__c = this.totalAmount;
        newRecordOrder.Contact__c = contacts.get(0).id;
        insert newRecordOrder;


      	this.productsById.get(0).Units_Available__c = avaiableAfterOrder;
        update productsById.get(0);
        return new PageReference('http://www.google.com').setRedirect(true);
    }

}