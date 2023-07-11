# Charon for CI
This repository makes using [Charon](https://github.com/Haspamelodica/Charon) easier for CI systems.

It requires two repositories to be cloned into subfolders by the CI system;
the "student submission" repository containing all files submitted by the student,
and the "tests" containing all files created by the exercise creator.

No files from the tests repository will be (directly) visible to student code.
Additionally, no files from the student submission repository will be (directly) visible to test code by default,
which is to prevent accidental security bugs.

When used with the recommended pipeline, a Maven or Gradle build will be invoked
in the tests repository for the `test` goal
with the `net.haspamelodica.charon.communicationargs` system property
set correctly for communicating with the student side via the Charon JUnit 5 extension.

Charon-CI uses Docker images built by https://github.com/Haspamelodica/Charon-CI-Images.

## Requirements

### Build environment
- The build environment must have Docker preinstalled.

### Student submissions repository
- All sources must be in one folder called `src` at repository root.
- Student code must not have any dependencies.

### Tests repository
- There must be a POM file (for Maven-based tests) or Gradle build files (for Gradle-based tests) at the repository root.
  The tests repository may use any dependencies and plugins, but using
  `org.apache.maven.plugins:maven-surefire-plugin:3.0.0` and `org.junit.jupiter:junit-jupiter-engine:5.8.2`
  is recommended because those two artifacts and all their dependencies are cached in the exercise container.

## Recommended pipeline for testing student submissions
1. Clone / check out this repository.
2. (Optional) To pull all required docker containers, execute `pull_containers.sh`.
   This can be used to avoid warnings from Docker about automatically pulling when containers are run.
     Step 1 has to be finished for this to work.
3. (Optional) To delete all files from old student submissions and tests, execute `clean.sh`.
     Step 1 (and step 2, if used) has to be finished for this to work.
4. Clone / check out exercise-specific repositories: student submission to `student/assignment`, tests to `exercise/tests`.
     Step 3, if used, has to be finished for this to work.
5. Execute `run_exercise_maven.sh` for Maven-based tests, or `run_exercise_gradle.sh` for Gradle-based tests.
     Steps 1 and 4 have to be finished for this to work.
6. (Optional) Import any build artifacts, like test results.
     Step 5 has to be finished for this to work.
7. (Optional) To delete all files from the student submission and tests, execute `clean.sh`.
     Step 5 has to be finished for this to work.

## Configuring
- You can specify additional arguments for Docker using the environment variables
  `$ADDITIONAL_DOCKER_ARGS_STUDENT` and `$ADDITIONAL_DOCKER_ARGS_EXERCISE`.
- You can give a timeout using `$TIMEOUT`.

## Limitations
- (The student submisison can not create any files outside of its Docker container.
  This is intentional and as designed.)
- Currently, the student side is always invoked using Maven with a fixed POM file. This will likely be changed in the future.
- Build artifacts created by the tests will only be visible to the outside of the container
  if they are created in `/data` (or subdirectories).
  The POM file will be invoked in `/data/tests` in the Docker container.
  This implies all build artifacts from the `target` folder for Maven, or the `build` folder for Gradle, will be visible to the outside.
- The exercise build can't assume to be able to modify or delete any existing files in the `exercise` folder,
  which includes all files in the tests repository,
  except for those under `target` for Maven, or under `build` or `.gradle` for Gradle.
