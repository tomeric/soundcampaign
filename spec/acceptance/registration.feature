Feature: Creating an account
  
  Background:
    Given I have been invited
  
  Scenario: Signing up
    When I open my invite
    And I sign up
    Then I see my dashboard
