# IHMC Actions
This repository contains reusable actions and workflows for ihmcrobotics repositories.

## Workflows
### gradle-test
gradle-test is meant to run JUnit tests within a Gradle (Java/Kotlin/Groovy) project.

#### Inputs
| Input name           | Required | Description                                                                    | Example input                            |
|----------------------|----------|--------------------------------------------------------------------------------|------------------------------------------|
| extra-repos          | false    | A JSON array of extra repositories to clone                                    | '["my-extra-repo-1", "my-extra-repo-2"]' |
| subproject           | false    | The subproject to test, if using a multi-project repo                          | "my-subproject"                          |
| test-category        | false    | The JUnit Tag / Category to run (default to "fast")                            | "my-tag"                                 |
| requires-self-hosted | false    | Whether or not to run the job on a self-hosted runner or GitHub-hosted runners | true                                     |

#### Example usage
```
name: Gradle test

on:
  workflow_dispatch:
  push:
    branches:
      - develop
  pull_request:

jobs:
  gradle-test:
    uses: ihmcrobotics/ihmc-actions/.github/workflows/gradle-test.yml@main
```
