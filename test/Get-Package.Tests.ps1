#Requires -Modules AnyPackage.Docker

Describe Get-Package {
    Context 'with no parameters' {
        It 'should return results' {
            $packages = Get-Package

            Write-Verbose ($packages | Out-String) -Verbose
            
            Get-Package |
            Should -Not -BeNullOrEmpty
        }
    }
}
