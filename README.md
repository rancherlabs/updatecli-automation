### Note: This repo and automation is now archived and kept for historical purpose. Teams in Rancher are using Updatecli on a per-repo setup, instead of on a central repo.

# Updatecli automation

This project uses [Updatecli](https://github.com/updatecli/updatecli) to automate and orchestrate security related updates and versions bumps in Rancher owned projects.

Initially, all the configuration files (manifests/pipelines) will reside inside this repo. In the future and if more teams decide to adopt the tool, we can move the pipelines files to their own respective target repos, like how Dependabot/Renovate works.

## Tool

We use Updatecli for this automation, instead of Dependabot or Renovate, because of its extensibility and multiple [plugins resources](https://www.updatecli.io/docs/prologue/introduction/) that allow greater flexibility when automating sequences of conditional update steps across multiple repos.

For detailed information on how to use Updatecli, please consult its [documentation](https://www.updatecli.io/docs/prologue/introduction/) page.

## Scheduled workflow

The automation runs as a GitHub Actions scheduled workflow once per day.

Manual execution of the pipelines can be [triggered](https://github.com/rancherlabs/updatecli-automation/actions/workflows/updatecli.yml) when needed.

## Scope

All Rancher owned repositories in [Rancher](https://github.com/rancher) and [Rancher Labs](https://github.com/rancherlabs) can be targeted by this automation.

The main usage of Updatecli is for:

* Bumping versions in unstructured formats, e.g., environment variables in Dockerfiles and by matching regular expressions.
* Scripting the automation process, e.g., update package A in repo B after package X in repo Y matches a pre-defined version criteria.

### Not in scope

* Updatecli will only open a pull request in the targeted repo. It's not responsible for approving and merging the PR.
* The resulting PR must still follow the rules of the targeted repo, e.g., passing checks, QA testing, review process etc.
* Regular updates in major packages ecosystem, like Go Modules, should be done accordingly to the targeted repo owns definition, e.g., manually or by using Dependabot and/or Renovate.

## Project organization

A manifest or pipeline consists of three stages - source, condition and target - that define how to apply the update strategy.

When adding a new manifest, please follow the example structure defined below.

```
.
└── updatecli
    ├── scripts                            # Contains the auxiliary scripts used in the manifests
    ├── updatecli.d
    │   └── rancher                        # Manifests targeting Rancher GH org
    │       └── shell                      # Manifests to update rancher/shell repo
    │           ├── prometheus-federator   # Manifests to update rancher/shell on a dependent repo
    │           └── rancher
    │               └── v2.6               # Manifests to update rancher/shell on a dependent repo - rancher - with multiple branches
    │               └── v2.7
    └── values.yaml                        # Configuration values
```

The manifest file must be placed inside a directory path named accordingly to its targeted repository name. Suppose that we want to target the repository `rancherlabs/exemple`, then the manifest must be organized as:

```
.
└── updatecli
    ├── updatecli.d
    │   └── rancherlabs
    │       └── example
```

Inside `updatecli/updatecli.d/rancherlabs/example` we can add the manifest files and also directories of manifests that are dependent on updates being done in `rancherlabs/example`.

Follow-up questions can be addressed during PR review process.

## Local testing

Local testing of manifests require:

1. Updatecli binary that can be download from [updatecli/updatecli#releases](https://github.com/updatecli/updatecli/releases). Test only with the latest stable version.
   1. Always run locally with the command `diff`, that will show the changes without actually applying them.
2. A GitHub [PAT](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token) (personal access token). The only required permission scope for Updatecli to work, when targeting only public repos, is `public_repo`.
   1. For obvious security reasons and to avoid leaking your GH PAT, export it as a local environment variable.

```shell
export UPDATECLI_GITHUB_TOKEN="your GH PAT"
updatecli diff --clean --config updatecli/updatecli.d/ --values updatecli/values.yaml            
```

## Contributing

Everyone is free to contribute with new manifests and pipelines for security version bumps targeting Rancher owned repos.

Before contributing, please follow the guidelines provided in this readme and make sure to test locally your changes before opening a PR.

## Contact

This project is maintained by Rancher Security team. For any inquiries, please open an issue or bug report in this repo.

