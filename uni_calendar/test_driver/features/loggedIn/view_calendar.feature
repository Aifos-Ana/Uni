Feature: Calendar View
  As a Authenticated User, I want to consult a calendar so that i know all the dates related to the university.

  Scenario: From the initial page i can consult the calendar
    Given I open the drawer
    When I tap the "drawer_Calendário" button
    Then I expect the text "Calendário de Eventos" to be present

  Scenario: Having an event on day 15 in one months, I can navigate to there and see the event
    Given I open the drawer
    And I tap the "drawer_Calendário" button
    And I pause for 1 seconds
    And I swipe left by 250 pixels on the widget that contains the text "dom"
    And I swipe left by 250 pixels on the widget that contains the text "dom"
    And I pause for 1 seconds
    And I tap the widget that contains the text "15"
    Then I expect the text "EVENT_TEST_GHERKIN" to be present
