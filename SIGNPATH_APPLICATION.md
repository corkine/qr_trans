# SignPath Foundation application draft

Status: prepared; not submitted or approved. Existing releases must not be described as signed by SignPath Foundation.

## Project details

- Project: QR Trans (`qr_trans`)
- Maintainer: Corkine Ma (`corkine` on GitHub)
- Repository: https://github.com/corkine/qr_trans
- Downloads: https://github.com/corkine/qr_trans/releases
- License: MIT; see LICENSE
- Target: the project's Windows application executable distributed in ZIP releases
- Build service: GitHub Actions, `.github/workflows/release.yml`
- Application form: https://signpath.org/apply

## Application description

QR Trans is a Flutter application that transfers user-selected files between devices using sequences of QR codes. The core transfer mechanism uses a display and camera instead of a network connection. The project publishes Windows ZIP packages alongside other platform builds.

I maintain the project as corkine on GitHub and would like to apply for free Windows code signing through SignPath Foundation. Windows builds are produced from this repository using GitHub Actions. The requested signing scope is QR Trans's own Windows executable; this application does not request signing for unrelated projects or third-party binaries.

The repository README declares the MIT license. This change adds the corresponding license text. I would appreciate guidance on the Foundation's onboarding and artifact-verification requirements.

## Items to resolve before claiming compliance

- Confirm maintainer MFA is enabled for GitHub and, when created, SignPath.
- Review the licenses of bundled dependencies against the Foundation's conditions.
- Verify application and bundled-component network behavior before publishing a privacy policy.
- Publish the approved code signing policy, team roles, privacy policy, and release-page links.
- Configure the verified build integration, executable metadata restrictions, and manual release approval after onboarding.

Do not add organization IDs, certificate IDs, API tokens, or claims of acceptance until supplied by SignPath.
