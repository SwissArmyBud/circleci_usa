# Micro-Service Architecture CI
#### (uSA) CircleCI Production Manager

## Intro
The system implemented here allows for a micro-service-architecture (uSA) that can be flexibly developed and deployed via a CircleCI integration.

## Machination
CircleCI is driven by the global [YAML configuration](.config/circleci.yaml) and each language has its own workflow filter and resulting containerized setup. Once the containers are setup and the environment is configured, a global runner is started to handle all the next CI steps.

Each project is referenced in the [runner script](/runner.sh) by the name of its branch, injected into the environment as $CIRCLE_BRANCH from the CI system - the runner loads source code from that project folder and executes it. The combination of language tag (container setup) and the project name (runner code) derives from the (language)-(name) service naming schema. The runner sources the CI-lifecycle scripts from each service, which can then be used to call any number of other jobs from the [CircleCI API](https://circleci.com/docs/2.0/api-job-trigger/).

## Customization
CircleCI requires that the branch have an "engaged watcher" derived from the master branch's config.yaml , but will process branch-specific config.yaml and runner.sh files when a build is triggered. This means customization for large or complex integration testing is as simple as pushing a workflow with the appropriate branch filter (i.e. ```integration-.\*```) to the master branch's config.yaml and then re-writing runner.sh to act in any way desired, or even completely rewriting the config.yaml job run for the trigger.
