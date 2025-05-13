#Requires -Modules AnyPackage.Docker

Describe Get-PackageProvider {
    Context 'with no parameters' {
        It 'should return results' {
            Get-PackageProvider |
            Should -Not -BeNullOrEmpty
        }
    }
}
