public with sharing class ProductDescriptionController {
    
    public ProductDescriptionController(){
  
    }
 
    public String getProductId(){
        String productId = System.currentPagereference().getParameters().get('productId');
        return productId;
    }
    
    public Product_Table__c  getProductById(){
        String productId = getProductId();
        List<Product_Table__c> productById = Database.query(
        'SELECT  Name, Image_URL__c, Unit_Price__c, Product_Description__c, Units_Available__c '+
           'FROM Product_Table__c WHERE id =\'' + productId + '\''
        );      
        return productById.get(0);
    }
}