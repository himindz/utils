Feature: User Service

  Scenario: Create user Wendy
    Given I set Content-Type header to application/json
    And I pipe contents of file ./test/acceptance/data/wendy.json to body
    When I POST to /user
    Then response code should be 200
 