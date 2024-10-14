# Changelog

## [v1.1.0]

- Instead of building a context for a resource module we should just accept an existing context. This ensures consistency 
in resource naming when creating resources

## [v1.0.0]

### Changed

- Use conditions for high level account and organisation level filtering on read only access
- Can set aws_organisation_ids and/or aws_account_ids to apply the controls as fine grained as required ( down to account/org level)
- Apply policy for service level principals as well with lambda as a default
- Move the lifecycle policy into a data resource
- Add outputs for details on the repository
- Remove nested module structure

## [v0.0.5]

### Changed

- combine multiple repository policies into one policy

## [v0.0.4]

### Changed

- allow to use custom lifecycle policy

## [v0.0.3]

### Changed

- allow to set a custom repository name

## [v0.0.2]

### Changed

- reorganize project structure

## [v0.0.1]

### Added

- initial commit
