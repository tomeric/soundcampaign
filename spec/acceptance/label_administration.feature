Feature: Label administration
  
  Background:
    Given I am signed in
  
  Scenario: Add a new label
    When I add a new label
    Then I see the label overview
    And I see my label
  
  Scenario: Updating a label
    Given I have a label
    When I update my label
    Then I see my updated label
  
  Scenario: Delete a label
    Given I have a label
    When I delete my label
    Then I see the label overview
    And I don't see my label
