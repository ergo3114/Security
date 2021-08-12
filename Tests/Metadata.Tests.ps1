Describe "Metadata"{
    It "Should have a LICENSE file" {
        (Get-ChildItem LICENSE).Name | Should -Be 'LICENSE'
    }

    It "Should have a README.md file" {
        (Get-ChildItem README.md).Name | Should -Be 'README.md'
    }
}