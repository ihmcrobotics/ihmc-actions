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
| timeout-minutes      | false    | Number of minutes before the build job times out (default 30)                  | 45                                       |

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

#### Example ussage
```
name: Gradle test

on:
  workflow_call:
    secrets:
      ROSIE_PERSONAL_ACCESS_TOKEN:
        description: 'Personal access token'
        required: false
    inputs:
      extra-repos:
        required: false
        type: string
        description: 'JSON array of repositories to checkout, repos are required to be in the ihmcrobotics org. Do not include ihmcrobotics in the name.'
        default: '[""]'
      subproject:
        required: false
        type: string
        description: 'Sub project name'
      test-category:
        required: false
        type: string
        description: 'Test category'
        default: 'fast'
      requires-self-hosted:
        required: false
        type: boolean
        description: 'Set to true to use a self-hosted runner, false for ubuntu-latest'
        default: false

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
```
