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

## Actions
### send-junit-to-api
action sends junit xml files to evergreen api

#### Example ussage
```
name: Gradle test

on:
  workflow_call   

jobs:
  build:
    runs-on: 'self-hosted'   
    steps:
      # Checkout repository-group
      - name: Checkout repository-group
        uses: actions/checkout@v4        

      ....

      - name: Setup JDK
        uses: actions/setup-java@v4
        with:
          java-version: '17'
          distribution: 'temurin'

      - name: Setup Gradle
        uses: gradle/actions/setup-gradle@v4
        with:
          gradle-version: "8.10.2"

      - name: Gradle test        
        run: 
          gradle test"

      ## generate XML files
      - name: Publish Test Report - ${{ inputs.test-category }}
        uses: mikepenz/action-junit-report@v4
        if: success() || failure() # always run even if the previous step fails
        with:
          report_paths: '**/build/test-results/test/TEST-*.xml'
          detailed_summary: true
          check_name: JUnit Test Report ${{ inputs.subproject || ''}}

      # Use send-junit-to-api action
      - name: Send JUNIT XML Files to Evergreen API    
        uses: ihmcrobotics/ihmc-actions/.github/actions/send-junit-to-api@main
        if: success() || failure() # always run even if the previous step fails
        with:
          subproject: ${{ inputs.subproject }}

```