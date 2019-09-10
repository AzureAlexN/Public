[OutputType([String])]
param (
    [Parameter(Mandatory = $false)]
    [String]  $AzureConnectionAssetName = "AzureRunAsConnection",
    [Parameter(Mandatory = $false)]
    [String] $ResourceGroupName,
    [Parameter(Mandatory = $false)]
    [String] $VmName
)
try {
    $ServicePrincipalConnection = Get-AutomationConnection -Name $AzureConnectionAssetName
    Write-Output "Logging in to Azure..."
    $Null = Add-AzAccount `
        -ServicePrincipal `
        -TenantId $ServicePrincipalConnection.TenantId `
        -ApplicationId $ServicePrincipalConnection.ApplicationId `
        -CertificateThumbprint $ServicePrincipalConnection.CertificateThumbprint
}
catch {
    if (!$ServicePrincipalConnection) {
        throw "Connection $AzureConnectionAssetName not found."
    }
    else {
        throw $_.Exception
    }
}
# If there's a specified resource group VM, get the specified VM/VMs in the resource group; otherwise get all VMs in the subscription.
if ($ResourceGroupName) {
    if ($vmName) {
        $VMs = Get-AzVM -ResourceGroupName $ResourceGroupName -vmName $vmName
    }
    else {
        $VMs = Get-AzVM -ResourceGroupName $ResourceGroupName
    }
}
else {
    $VMs = Get-AzVM
}
# Start VMs one by one
foreach ($VM in $VMs) {
    $Output = $VM | Start-AzVM -ErrorAction Continue
    if (!$Output.IsSuccessStatusCode) {
 
        Write-Error ($VM.Name + " failed with the following error:") -ErrorAction Continue
        Write-Error (ConvertTo-Json $Output) -ErrorAction Continue
    }
    else {
        Write-Output ($VM.Name + " has been started")
    }
}