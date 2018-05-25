public with sharing class Product_Table_Controller {
    
    public Product_Table_Controller(){
   		 getProducts();        
    }
    
 	public List<Product_Table__C> getProducts() {
    	List<Product_Table__C> results = Database.query(
       	 'SELECT Name, Image_URL__c, Unit_Price__c, Product_Description__c ' +
         'FROM Product_Table__C'         
  	  );
    return results;
	}  
}