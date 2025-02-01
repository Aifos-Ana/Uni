Feature: Favorite an Event
  As a Authenticated User, I want to favorite an event so that i receive a notification.

  Scenario: Having an event on day 15 in one months, I can navigate to there and favorite it
    Given I open the drawer
    And I tap the "drawer_Calendário" button
    And I pause for 1 seconds
    And I swipe left by 250 pixels on the widget that contains the text "dom"
    And I swipe left by 250 pixels on the widget that contains the text "dom"
    And I pause for 1 seconds
    And I tap the widget that contains the text "15"
    And I tap the "not_fav_btn_EVENT_TEST_GHERKIN" icon
    Then I expect the widget "fav_btn_EVENT_TEST_GHERKIN" to be present within 5 second