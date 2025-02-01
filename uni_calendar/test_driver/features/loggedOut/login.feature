Feature: Login
  As an user, I want to be able to login in the app so that I can have full access to the app.

  Scenario Outline: Login to my account without success
    Given I fill the "login_username" field with <user>
    And I fill the "login_password" field with <password>
    When I tap the "login_enter" button
    Then I expect the text "palavra-passe" to be present

    Examples:
      | user         | password   |
      | "user"       | "pass"     |
      | "up0000"     | "abcde"    |
      | "root"       | "feuup"    |
