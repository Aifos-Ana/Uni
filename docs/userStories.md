## User Stories

# Story #1
As an user, I want to be able to login in the app so that I can have full access to the app.

## User interface mockups
<p align="center" justify="center">
   <img src="https://user-images.githubusercontent.com/82966644/161283322-4248db3d-9fea-47e2-b9d7-6d0cdca29118.png" width=300>
</p>

## Acceptance tests
```Gherkin
Feature: Login
    As an user, I want to be able to login in the app so that I can have full access to the app.

    Scenario Outline: Login to my account with success
        Given The "Login" screen
        When I tap the "Username" field
        And I write my user credential with <user>
        And I tap "the Password" field
        And I write my password credential with <password>
        And I tap the "Log in" button
        Then If the combination <email>/<password> exists
        Then I became logged in and i'm redirected to the "Home" page

        Examples:
            | user       | password |
            | up20230053 | pass     |
            | lcom       | lcom     |
            | root       | feup     |

    Scenario Outline: Login to my account without success
        Given The "Login" screen
        When I tap the "Username" field
        And I write my user credential with <user>
        And I tap the "Password" field
        And I write my password credential with <password>
        And I tap the "Log in" button
        Then If the combination <email>/<password> don't exists
        Then an error message appears and I stay in the "Login" page

        Examples:
            | user       | password |
            | user       | pass     |
            | up0000     | abcde    |
            | root       | feuup    |
```

## Value and effort
* Value: Must have
* Effort: XS


# Story #2
As a Authenticated User, I want to consult a calendar so that i know all the dates related to the university.

## User interface mockups
<p align="center" justify="center">
   <img src="https://user-images.githubusercontent.com/82966644/161301368-9c883ea5-8fec-43a8-b5c8-c6e7c503f4ca.png" width=300>
</p>

## Acceptance tests
```Gherkin
Feature: Calendar View
  As a Authenticated User, I want to consult a calendar so that i know all the dates related to the university.

  Scenario: Consult the calendar
    Given The initial menu in "Home" page
    When I tap "Calendar"
    Then the "Calendar" page appears
```

## Value and effort
* Value: Must have
* Effort: M

# Story #3
As an authenticated user, I want to be able to filter events so that I only see the events that I want and to be more efficient.

## User interface mockups
<p align="center" justify="center">
   <img src="https://user-images.githubusercontent.com/82966644/161286583-beac760e-adb1-444a-af01-20e50b71e7fc.png" width=300>
</p>

## Acceptance tests
```Gherkin
Feature: Calendar Filters
  As an authenticated user, I want to be able to filter events so that I only see the events that I want and to be more efficient.

  Scenario Outline: Filter the "Calendar"
    Given The "Calendar" page
    When I tap "Filter" button
    And I choose the filter <filter>
    Then the view changes accordingly to <filter>

    Examples:
      | filter      |
      | Exams       |
      | Events      |
```

## Value and effort
* Value: Must have
* Effort: L

# Story #4
As a Authenticated User, I want to favorite an event so that i receive a notification.

## User interface mockups
<p align="center" justify="center">
   <img src="https://user-images.githubusercontent.com/82966644/161289798-ab6110c6-038c-496d-bf37-c9fc97416c4a.png" width=300>
</p>

## Acceptance tests
```Gherkin
Feature: Favorite an Event
  As a Authenticated User, I want to favorite an event so that i receive a notification.

  Scenario Outline: Favorite an event
    Given The the event page of <event>
    When I tap the star button
    Then the event is added to the favorites

  Examples:
    | event                |
    | atuacao da tuna      |
    | semana do engenheiro |
    | sinf                 |
```

## Value and effort
* Value: Should have
* Effort: S

# Story #5
As an authenticated user, I want to find a event by a keyword so that I can find the event more effectively. 

## User interface mockups
<p align="center" justify="center">
   <img src="https://user-images.githubusercontent.com/82966644/161289475-a2650a2c-b2fa-468d-a0e1-fc0b4cb6ca59.png" width=300>
</p>

## Acceptance tests
```Gherkin
Feature: Search Event
  As an authenticated user, I want to find a event by a keyword so that I can find the event more effectively.

  Scenario: Search bar opened.
    Given The "Calendar" page
    When I tap the search button
    Then A search bar appears
    
  Scenario Outline: Search for an event.
    Given The search bar
    When I write a <keyword>
    Then the events that have that <keyword> appears

    Examples:
      | keyword      |
      | Software     |
      | Music        |
      | Orquestra    |
```

## Value and effort
* Value: Should have
* Effort: L

# Story #6
As an authenticated user, I want to receive notification reminding me for important events for me so that I won't miss it.

## User interface mockups
<p align="center" justify="center">
    <img src="https://user-images.githubusercontent.com/82966644/161290578-e1a4ce3c-3490-4a6f-89c9-3ccc5c16c7df.png" width=300>
</p>
<p align="center" justify="center">
   <img src="https://user-images.githubusercontent.com/82966644/161290636-d71f8f81-4d4e-422a-808f-5fc33c6e5ac4.png" width=300>
</p>


## Acceptance tests
```Gherkin
Feature: Notification
  As an authenticated user, I want to receive notification reminding me for important events for me so that I won't miss it.

  Scenario Outline: Receive a notification
    Given the favorite event <event>
    When the event date is near
    Then I received a notification reminding me of the event

    Examples:
      | event                |
      | atuacao da tuna      |
      | semana do engenheiro |
      | sinf                 |

```

## Value and effort
* Value: Should have
* Effort: L
