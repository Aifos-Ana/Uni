Feature: Search Event
  As an authenticated user, I want to find a event by a keyword so that I can find the event more effectively.

  Scenario: Open and write keyword
    Given I open the drawer
    And I tap the "drawer_Calendário" button
    And I tap the "btn_go_to_search" button
    And I tap the "btn_search" button
    And I fill the "input_search" field with "EVENT_TEST_GHERKIN"
    And I tap the "perform_search" button
    Then I expect the text "EVENT_TEST_GHERKIN" to be present