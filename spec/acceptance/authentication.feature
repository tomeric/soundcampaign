Feature: Authenticating
  
  Background:
    Given I have a user account
  
  Scenario: Signing in
    When I sign in with my credentials
    Then I see my dashboard
  
  Scenario: Resetting a password
    When I follow the instructions to reset my password
    Then I see my dashboard
  