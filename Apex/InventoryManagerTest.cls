@isTest
public class InventoryManagerTest {

    @isTest
    static void testProcessOrderStock() {

        // Create product with sufficient stock
        Re_Plastic_Innovations_Recycled_Product__c product =
            new Re_Plastic_Innovations_Recycled_Product__c(
                Name = 'Test Product',
                Stock_Level__c = 100,
                Threshold__c = 20
            );
        insert product;

        // Create an order in memory.
        // We do not insert it because the Order trigger would run automatically.
        Re_Plastic_Innovations_Order__c order =
            new Re_Plastic_Innovations_Order__c(
                Recycled_Product__c = product.Id,
                Quantity__c = 30
            );

        Test.startTest();

        InventoryManager.processOrderStock(
            new List<Re_Plastic_Innovations_Order__c>{order}
        );

        Test.stopTest();

        // Check that stock was reduced
        Re_Plastic_Innovations_Recycled_Product__c updatedProduct =
            [SELECT Stock_Level__c
             FROM Re_Plastic_Innovations_Recycled_Product__c
             WHERE Id = :product.Id];

        System.assertEquals(
            70,
            updatedProduct.Stock_Level__c,
            'Stock should be reduced by the order quantity'
        );
    }


    @isTest
    static void testInsufficientStockCreatesRestockRequest() {

        // Create product with insufficient stock
        Re_Plastic_Innovations_Recycled_Product__c product =
            new Re_Plastic_Innovations_Recycled_Product__c(
                Name = 'Low Stock Test Product',
                Stock_Level__c = 50,
                Threshold__c = 20
            );
        insert product;

        // Order quantity is greater than available stock
        Re_Plastic_Innovations_Order__c order =
            new Re_Plastic_Innovations_Order__c(
                Recycled_Product__c = product.Id,
                Quantity__c = 150
            );

        Test.startTest();

        InventoryManager.processOrderStock(
            new List<Re_Plastic_Innovations_Order__c>{order}
        );

        Test.stopTest();

        // Check that a restock request was created
        List<Re_Plastic_Innovations_Restock_Request__c> requests =
            [SELECT Id, Product__c, Request_Quantity__c, Status__c
             FROM Re_Plastic_Innovations_Restock_Request__c
             WHERE Product__c = :product.Id];

        System.assertEquals(
            1,
            requests.size(),
            'A restock request should be created'
        );

        System.assertEquals(
            100,
            requests[0].Request_Quantity__c,
            'Requested quantity should equal the stock shortage'
        );

        System.assertEquals(
            'Pending',
            requests[0].Status__c,
            'Restock request should initially be Pending'
        );
    }


    @isTest
    static void testProcessRestockApproval() {

        // Create product
        Re_Plastic_Innovations_Recycled_Product__c product =
            new Re_Plastic_Innovations_Recycled_Product__c(
                Name = 'Restock Approval Test Product',
                Stock_Level__c = 50,
                Threshold__c = 20
            );
        insert product;

        // Create pending restock request
        Re_Plastic_Innovations_Restock_Request__c restock =
            new Re_Plastic_Innovations_Restock_Request__c(
                Product__c = product.Id,
                Request_Quantity__c = 100,
                Status__c = 'Pending'
            );
        insert restock;

        // Test the approval method directly
        restock.Status__c = 'Approved';

        Test.startTest();

        InventoryManager.processRestockApproval(
            new List<Re_Plastic_Innovations_Restock_Request__c>{restock}
        );

        Test.stopTest();

        // Check that stock increased
        Re_Plastic_Innovations_Recycled_Product__c updatedProduct =
            [SELECT Stock_Level__c
             FROM Re_Plastic_Innovations_Recycled_Product__c
             WHERE Id = :product.Id];

        System.assertEquals(
            150,
            updatedProduct.Stock_Level__c,
            'Stock should increase after restock approval'
        );
    }


    @isTest
    static void testRestockApprovalTrigger() {

        // Create product
        Re_Plastic_Innovations_Recycled_Product__c product =
            new Re_Plastic_Innovations_Recycled_Product__c(
                Name = 'Trigger Test Product',
                Stock_Level__c = 50,
                Threshold__c = 20
            );
        insert product;

        // Create pending request
        Re_Plastic_Innovations_Restock_Request__c restock =
            new Re_Plastic_Innovations_Restock_Request__c(
                Product__c = product.Id,
                Request_Quantity__c = 100,
                Status__c = 'Pending'
            );
        insert restock;

        // Change status to Approved.
        // This activates UpdateStockAfterRestockApproval.
        Test.startTest();

        restock.Status__c = 'Approved';
        update restock;

        Test.stopTest();

        // Verify automatic stock update
        Re_Plastic_Innovations_Recycled_Product__c updatedProduct =
            [SELECT Stock_Level__c
             FROM Re_Plastic_Innovations_Recycled_Product__c
             WHERE Id = :product.Id];

        System.assertEquals(
            150,
            updatedProduct.Stock_Level__c,
            'Stock should automatically increase after approval'
        );
    }
    @isTest
static void testUpdateStockAfterOrderTrigger() {

    // Create product with sufficient stock
    Re_Plastic_Innovations_Recycled_Product__c product =
        new Re_Plastic_Innovations_Recycled_Product__c(
            Name = 'Trigger Coverage Product',
            Stock_Level__c = 100,
            Threshold__c = 20
        );
    insert product;

    // Create an order.
    // Inserting the order automatically fires UpdateStockAfterOrder.
    Re_Plastic_Innovations_Order__c order =
        new Re_Plastic_Innovations_Order__c(
            Recycled_Product__c = product.Id,
            Quantity__c = 30
        );

    Test.startTest();

    insert order;

    Test.stopTest();

    // Verify that the trigger reduced the stock
    Re_Plastic_Innovations_Recycled_Product__c updatedProduct =
        [SELECT Stock_Level__c
         FROM Re_Plastic_Innovations_Recycled_Product__c
         WHERE Id = :product.Id];

    System.assertEquals(
        70,
        updatedProduct.Stock_Level__c,
        'Stock should be reduced by the order trigger'
    );
}
}