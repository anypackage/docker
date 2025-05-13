using module AnyPackage
using namespace AnyPackage.Provider
using namespace System.Management.Automation

[PackageProvider('Docker')]
class DockerProvider : PackageProvider, IGetPackage, IInstallPackage, IUninstallPackage {
    [void] GetPackage ([PackageRequest] $request) {
        $images = docker image list --format json --no-trunc --digests | ConvertFrom-Json

        foreach ($image in $images) {
            try {
                $repo = $this.ParseRepository($image.Repository, $request)
            } catch {
                continue
            }

            if ($request.IsMatch($repo.Name, $image.Tag)) {
                $metadata = $image | ConvertTo-Metadata
                $package = [PackageInfo]::new($repo.Name, $image.Tag, $repo.Source, '', $null, $metadata, $request.ProviderInfo)
                $request.WritePackage($package)
            }
        }
    }

    [void] InstallPackage ([PackageRequest] $request) {
        $id = ''

        if ($request.Source) {
            $id += "{0}/" -f $request.Source
        }

        $id += $request.Name

        if ($request.Version -and $request.Version.MinVersion -ne $request.Version.MaxVersion) {
            throw "Version ranges not supported."
        }
        elseif ($request.Version) {
            $id += ":{0}" -f $request.Version.MinVersion
        }

        $request.WriteVerbose("Full repository name: $id")

        docker pull $id 2>&1 |
            ForEach-Object {
                if ($_ -is [ErrorRecord]) {
                    $request.WriteError($_)
                } else {
                    $request.WriteVerbose($_)
                }
            }

        if ($LASTEXITCODE -eq 0) {
            $getPackageParameters = @{
                Name        = $request.Name
                Provider    = $request.ProviderInfo.FullName
                ErrorAction = 'SilentlyContinue'
            }

            if ($request.Version) {
                $getPackageParameters['Version'] = $request.Version
            }

            $package = Get-Package @getPackageParameters

            $request.WritePackage($package)
        }
    }

    [void] UninstallPackage ([PackageRequest] $request) {
        $getPackageParameters = @{
            Name        = $request.Name
            Provider    = $request.ProviderInfo.FullName
            ErrorAction = 'SilentlyContinue'
        }

        if ($request.Version) {
            $getPackageParameters['Version'] = $request.Version
        }

        $package = Get-Package @getPackageParameters

        if (!$package) {
            return
        }

        $id = '{0}/{1}:{2}' -f $package.Source, $package.Name, $package.Version
        docker image rm $id 2>&1 |
            ForEach-Object {
                if ($_ -is [ErrorRecord]) {
                    $request.WriteError($_)
                } else {
                    $request.WriteVerbose($_)
                }
            }

        if ($LASTEXITCODE -eq 0) {
            $request.WritePackage($package)
        }
    }

    hidden [hashtable] ParseRepository([string] $repository, [PackageRequest] $request) {
        if ($repository -match '^(?:(?<source>[^/]*\.[^/]+)/)?(?<name>.+)$') {
            if ($matches.ContainsKey('source')) {
                $source = [PackageSourceInfo]::new($matches.source, $matches.source, $request.ProviderInfo)
            } else {
                $request.WriteVerbose('Host not found, defaulting to default docker.io')
                $source = [PackageSourceInfo]::new('docker.io', 'docker.io', $request.ProviderInfo)
            }
        } else {
            throw "Failed to parse $($repository)"
        }

        return @{
            Name   = $matches.Name
            Source = $source
        }
    }
}

[guid] $id = '9782932d-8d88-4f53-9ef9-4dbf1def9783'
[PackageProviderManager]::RegisterProvider($id, [DockerProvider], $MyInvocation.MyCommand.ScriptBlock.Module)

$MyInvocation.MyCommand.ScriptBlock.Module.OnRemove = {
    [PackageProviderManager]::UnregisterProvider($id)
}

function ConvertTo-Metadata {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '')]
    [CmdletBinding()]
    [OutputType([hashtable])]
    param (
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [PSObject]
        $InputObject
    )

    process {
        $ht = @{ }

        $properties = $InputObject |
            Get-Member -MemberType Properties |
            Select-Object -ExpandProperty Name

        foreach ($prop in $properties) {
            $ht[$prop] = $InputObject.$prop
        }

        $ht
    }
}
