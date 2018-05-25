trigger Product_Table on Product_Table__c (before insert) {   
    List<WareHouse__c> WarehouseList = new List<WareHouse__c>();
    WarehouseList = Database.query('SELECT name,  Period_Start__c, Period_End__c FROM Warehouse__c');
    
    for(Product_Table__c product : Trigger.new  ){
        for( WareHouse__c warehouse : WarehouseList ){
            if(warehouse.Period_Start__c <= product.Added_Date__c && warehouse.Period_End__c >= product.Added_Date__c){
                product.WareHouse__c = warehouse.Id;
                break;
            }            
        }  
        if(product.WareHouse__c == NULL){
            Org_Configuration__c orgconfiguration = Org_Configuration__c.getInstance();
            Integer days = (Integer)orgconfiguration.Period_Term__c;
            WareHouse__c warehouse = new WareHouse__c(
                Name = 'warehouse ' + product.Added_Date__c + ' ' + product.Added_Date__c.addDays(days),
                Period_Start__c = product.Added_Date__c,
                Period_End__c = product.Added_Date__c.addDays(days)
            );
            insert warehouse;
            product.WareHouse__c = warehouse.id;
        }
 
    }
}