# Contributing to PhotoPrism Contrib

This repository collects **community-contributed resources** for [PhotoPrism®](https://github.com/photoprism/photoprism): apps, plugins, configuration examples, tutorials, scripts, and platform-specific notes (Unraid, etc.). The goal is to make it easier for users to share useful work without the overhead of forking the main repository.

If you have something to share, we'd love to receive a pull request.

## What Belongs Here

| Top-level folder | What goes in it                                                                                                            |
|------------------|----------------------------------------------------------------------------------------------------------------------------|
| `apps/`          | Standalone applications and plugins that integrate with PhotoPrism — Android galleries, browser extensions, mobile apps, … |
| `config/`        | Reproducible deployment recipes — Podman + systemd units, reverse-proxy snippets, sample compose stacks, …                 |
| `scripts/`       | Helper scripts for common operations — bulk renames, FFmpeg pipelines, geotagging, batch face naming, …                    |
| `tutorials/`     | Step-by-step guides — storage tuning (e.g. ZFS), backup strategies, integration walkthroughs, …                            |
| `unraid/`        | Notes specific to the Unraid platform — permission fixes, share configuration, …                                           |

If your contribution doesn't fit any of these neatly, propose a new top-level folder in the pull request description and we'll discuss it there.

## What Does **Not** Belong Here

- **Bug reports or feature requests for PhotoPrism itself.** Open those on the [main repository](https://github.com/photoprism/photoprism/issues) so the core team sees them.
- **Issues with a contributed item that is maintained elsewhere.** Many of the apps and plugins are mirrors or pointers to upstream projects; check the item's own `README.md` for where to file issues.
- **Personal forks of the PhotoPrism backend or frontend.** Those belong in your own GitHub namespace.

## Submission Guidelines

1. **Pick the right folder** (see the table above) and create a new sub-folder named after your contribution.
2. **Include a `README.md` at the root of your sub-folder** that covers:
   - What the contribution does and who it's for.
   - Prerequisites (PhotoPrism version, OS, hardware, language runtime, …).
   - Installation / usage steps a stranger can actually follow.
   - Maintainer contact (GitHub username, email, or upstream project URL).
   - Any third-party licenses that apply to files inside your sub-folder (see § License below).
3. **Test your contribution before submitting.** Scripts should run end-to-end on a clean checkout; configs should produce a working stack; tutorials should be reproducible.
4. **Open a pull request against the `develop` branch.** Keep the description short — what it does, why it's useful, where you tested it.
5. **One contribution per pull request** wherever possible. It makes review and merging much smoother.

## License

This repository is licensed under the [Apache License 2.0](LICENSE). **By submitting a pull request, you agree that your contribution is licensed under the same terms.** Apache 2.0 includes an explicit patent grant from contributors to users (Section 3) and a contributor license grant for submitted material (Section 5), so a separate CLA is not required.

If your contribution includes **third-party code under a different license**, place that code in its own sub-folder and include the upstream `LICENSE` file alongside it. Don't strip or modify upstream license headers. If the upstream license is incompatible with Apache 2.0 (e.g. GPL-2.0-only), we cannot accept it here — please host it in your own repository and submit a pointer to it instead of the code itself.

## Asking Questions

- **General community chat:** [community chat (Element/Matrix)](https://link.photoprism.app/chat).
- **GitHub Discussions:** [photoprism/photoprism discussions](https://link.photoprism.app/discussions).
- **Documentation:** [docs.photoprism.app](https://docs.photoprism.app/).

## Code of Conduct

All interaction in this repository is subject to the [PhotoPrism Code of Conduct](https://www.photoprism.app/code-of-conduct). Be kind, be patient, and assume good faith.

## Thank You to All Current and Past Sponsors 💎 ##

[A big thank you to all of our sponsors](https://github.com/photoprism/photoprism/blob/develop/SPONSORS.md), whose generous support has been and continues to be essential to the success of the project! 💜

Our project infrastructure is provided by the following companies:

- [**GitHub**](https://github.com/) hosts our [code repositories](https://github.com/photoprism/photoprism) and also provides many other important services
- [**Docker**](https://www.docker.com/) approved us for their [Open Source Program](https://www.docker.com/community/open-source/application/) and hosts all of our app images
- [**Element**](https://element.io/) develops and [operates the infrastructure](https://matrix.org/) that our [community chat](https://link.photoprism.app/chat) is based on
- [**BrowserStack**](https://www.browserstack.com/) provides [free access](https://www.browserstack.com/open-source) to their device and browser testing infrastructure

[View Sponsors ›](https://github.com/photoprism/photoprism/blob/develop/SPONSORS.md) [View Credits ›](https://docs.photoprism.app/credits/)

## Privacy Notice ##

We operate a number of web services that help us develop and maintain our software in collaboration with the open source community, for example [translate.photoprism.app](https://translate.photoprism.app/).

Because many of these apps and tools were originally developed for internal use without a high level of privacy in mind, we ask that you do not enter personal information such as your real name or personal email address if you want it to remain private.

**Personal details may otherwise show up in logs, source code, translation files, commit messages, and pull request comments.**

----

*PhotoPrism® is a [registered trademark](https://www.photoprism.app/trademark). By using the software and services we provide, you agree to our [Terms of Service](https://www.photoprism.app/terms), [Privacy Policy](https://www.photoprism.app/privacy), and [Code of Conduct](https://www.photoprism.app/code-of-conduct). Docs are [available](https://link.photoprism.app/github-docs) under the [CC BY-NC-SA 4.0 License](https://creativecommons.org/licenses/by-nc-sa/4.0/); [additional terms](https://github.com/photoprism/photoprism/blob/develop/assets/README.md) may apply.*
