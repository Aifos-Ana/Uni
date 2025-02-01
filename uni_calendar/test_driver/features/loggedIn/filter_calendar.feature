Feature: Search Event
  As an authenticated user, I want to be able to filter events so that I only see the events that I want and to be more efficient.

  Scenario: Go to filter and select general
    Given I open the drawer
    And I tap the "drawer_Calendário" button
    And I tap the "btn_go_to_search" button
    And I tap the "btn_filter" button
    And I tap the "filter_general" button
    And I tap the "perform_filter" button
    Then I expect the text "EVENT_TEST_GHERKIN" to be absent