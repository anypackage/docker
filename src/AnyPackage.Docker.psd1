@{
    RootModule = 'AnyPackage.Docker.psm1'
    ModuleVersion = '0.1.0'
    CompatiblePSEditions = @('Desktop', 'Core')
    GUID = '4826c4eb-b455-434e-9d1f-253c9e0021fd'
    Author = 'Thomas Nieto'
    Copyright = '(c) 2025 Thomas Nieto. All rights reserved.'
    Description = 'Docker provider for AnyPackage.'
    PowerShellVersion = '5.1'
    RequiredModules = @('AnyPackage')
    FunctionsToExport = @()
    CmdletsToExport = @()
    AliasesToExport = @()
    PrivateData = @{
        AnyPackage = @{
            Providers = 'Docker'
        }
        PSData = @{
            Tags = @('AnyPackage', 'Provider', 'Docker', 'Container', 'Windows', 'Linux', 'MacOS')
            LicenseUri = 'https://github.com/anypackage/docker/blob/main/LICENSE'
            ProjectUri = 'https://github.com/anypackage/docker'
        }
    }
}
