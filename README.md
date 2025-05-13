# AnyPackage.Docker

[![gallery-image]][gallery-site]
[![build-image]][build-site]
[![cf-image]][cf-site]

[gallery-image]: https://img.shields.io/powershellgallery/dt/AnyPackage.Docker
[build-image]: https://img.shields.io/github/actions/workflow/status/anypackage/docker/ci.yml
[cf-image]: https://img.shields.io/codefactor/grade/github/anypackage/docker
[gallery-site]: https://www.powershellgallery.com/packages/AnyPackage.Docker
[build-site]: https://github.com/anypackage/docker/actions/workflows/ci.yml
[cf-site]: https://www.codefactor.io/repository/github/anypackage/docker

`AnyPackage.Docker` is an AnyPackage provider that facilitates managing Docker
images.

## Install AnyPackage.Docker

```powershell
Install-PSResource AnyPackage
```

## Import AnyPackage.Docker

```powershell
Import-Module AnyPackage.Docker
```

## Sample usages

### Get list of installed images

```powershell
Get-Package -Name nginx
```

### Install image

```powershell
Install-Package -Name justingrote/powershell -Version latest -Source ghcr.io
```

### Uninstall image

```powershell
Uninstall-Package -Name nginx
```
