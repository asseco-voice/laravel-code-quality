# Code quality standard

This repository is meant to be a single place for PHP related quality 
standards when it comes to committing code from any PHP microservice
to repository. Its main purpose is creating Git hooks which would
catch any pre-commit action and see whether code is written according
to agreed standards. If it fails, commit will not be made. 

## Installation

This repository is NOT to be used separately as a standalone service.

External (micro) service which needs to comply to set of standards 
developed here MUST do the following to support it:

1. možda da composer dependencye uključim u ovaj repo da ne mora ići
iznova na svaki servis? To je ionako njegov dependency realno

2. clone the repository at the same level as the service

    ```
    |
    |--- code-quality
    |--- service1
    |--- service2
    ```

3. 

4. 


### PHP Mess detector

https://phpmd.org/rules/index.html


