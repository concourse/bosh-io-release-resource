# bosh.io release resource

Tracks the versions of a release on [bosh.io](https://bosh.io).

For example, to automatically consume releases of
[Concourse](https://github.com/concourse/concourse):

```yaml
resources:
- name: concourse
  type: bosh-io-release
  source:
    repository: concourse/concourse-bosh-release
```


## Source Configuration

* `repository`: *Required.* The GitHub repository of the release, i.e.
`username/reponame`.
* `regexp`: *Optional* A regular expression matching the version(s) to fetch, i.e.
`13.*`.


## Behavior

### `check`: Check for new versions of the release.

Detects new versions of the release that have been published to [bosh.io](https://bosh.io). If no version is specified, `check` returns the latest version, otherwise `check` returns all versions from the version specified on.

Note that there may be a delay between the final release appearing on
GitHub, and it appearing in bosh.io.


### `in`: Fetch a version of the release.

Fetches a given release, placing the following in the destination:

* `version`: The version number of the release.
* `url`: A URL that can be used to download the release tarball.
* `sha1`: The sha1 of the release tarball.
* `release.tgz`: The release tarball, if the `tarball` param is `true`.

#### Parameters

* `tarball`: *Optional.* Default `true`. Fetch the release tarball.

## Development

### Prerequisites

* docker is *required* - version 17.06.x is tested; earlier versions may also
  work.

### Running the tests

The tests have been embedded with the `Dockerfile`; ensuring that the testing
environment is consistent across any `docker` enabled platform. When the docker
image builds, the test are run inside the docker container, on failure they
will stop the build.

Run the tests with the following command:

```sh
docker build -t bosh-io-release-resource .
```

### Contributing

Please make all pull requests to the `master` branch and ensure tests pass
locally.
