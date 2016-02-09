# To Do

## Controller Level
* Skip controller and views creation if no actions present.
* Cleanup controller actions (and respective views) dynamically given the ones chosen by the user.
* Fix identation issues.
* Set strong params based on model fields. (add an editable? field to them, true by default)
* Set the set-instance before action with the correct actions.

## Routing
* Generate routes using the resources method. (--views-specs)
* Add basic routing specs for included actions. (--routing-specs)

## Model
* Add presence validations and its respective tests
* Add factory test. (based on a shared test file that is copied to the project)
' Add relationships and its respective tests
' Add other kinds of validations and its respective tests

## Testing
* Add base integration tests with Rspec & Capybara for the selected actions on each controller

Note. ' Represents a Nice To Have
