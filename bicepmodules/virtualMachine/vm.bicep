//Domain Join Paramaters
@description('List of virtual machines to be domain joined, if using multiple VMs, make their names comma separate. E.g. VM01, VM02, VM03.')
@minLength(1)
param vmList array

@description('Domain NetBiosName plus User name of a domain user with sufficient rights to perfom domain join operation. E.g. domain\\username')
param domainJoinUserName string

@description('Domain user password')
@secure()
param domainJoinUserPassword string

@description('Domain FQDN where the virtual machine will be joined')
param domainFQDN string = 'ayahealthcare.com'

// VM Paramaters
param adminUsername string
@secure()
param adminPassword string
param location string = resourceGroup().location

param virtualMachineExtensionCustomScriptUri string = 'https://raw.githubusercontent.com/precopio/Microsoft-Bicep/main/install.ps1'
//VM Variables
param vNet string

var virtualMachineSize = 'Standard_D4s_v3'
var virtualMachineExtensionCustomScript = {
  location: location
  fileUris: [
    virtualMachineExtensionCustomScriptUri
  ]
  commandToExecute: 'powershell -ExecutionPolicy Unrestricted -File ./${last(split(virtualMachineExtensionCustomScriptUri, '/'))}'
}
//Domain Join Variables 
var domainJoinOptions = 3

//Creating VM 
resource vm 'Microsoft.Compute/virtualMachines@2021-07-01' = [for (name, i) in vmList: {
  name: name
  location: location
  
  properties: {
    osProfile: {
      computerName: name
      adminUsername: adminUsername
      adminPassword: adminPassword
      windowsConfiguration: {
        provisionVMAgent: true
      }
      
    }

    storageProfile: {
      dataDisks: [
        {
          createOption: 'Empty'
          diskSizeGB: int(2048)
          lun: int(1)
        }
      ]
      osDisk: {
        createOption: 'FromImage'
        diskSizeGB: int(256)
        osType: 'Windows'
      }
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2019-Datacenter'
        version: 'latest'
      }
    }
    hardwareProfile: {
     vmSize: virtualMachineSize
    }
    networkProfile: {
      networkInterfaces:[
        {
          properties: {
            primary: true
            
          }
          id: nic[i].id
        }
      ]
    }
  }       
}]

  //Creating VM NIC
resource nic 'Microsoft.Network/networkInterfaces@2021-05-01' = [ for name in vmList: {
    name: name
    location: location
    properties: {
      
      ipConfigurations: [
          {
            name: name
            properties: {
              subnet: {
                id: vNet
              }
              privateIPAllocationMethod: 'Dynamic'
            }
          }
        ]
    }
}]

//Moved anti malware to be deployed by Azure Policy

resource vmext 'Microsoft.Compute/virtualMachines/extensions@2021-04-01' = [ for name in vmList: {
  name: '${name}/custom-config'
  location: virtualMachineExtensionCustomScript.location
  dependsOn: [
    vm
  ]
  
  properties: {
    publisher: 'Microsoft.Compute'
    type: 'CustomScriptExtension'
    typeHandlerVersion: '1.7'
    autoUpgradeMinorVersion: true
    settings: {
      fileUris: virtualMachineExtensionCustomScript.fileUris
      commandToExecute: virtualMachineExtensionCustomScript.commandToExecute
    }
    protectedSettings: {}
  }
}]

resource vmListArray_joindomain 'Microsoft.Compute/virtualMachines/extensions@2021-11-01' = [for item in vmList: {
  name: '${item}/joindomain'
  location: location
  dependsOn: [
    vmext
  ]
  properties: {
    publisher: 'Microsoft.Compute'
    type: 'JsonADDomainExtension'
    typeHandlerVersion: '1.3'
    autoUpgradeMinorVersion: true
    settings: {
      Name: domainFQDN
      User: domainJoinUserName
      Restart: 'true'
      Options: domainJoinOptions
      
    }
    protectedSettings: {
      Password: domainJoinUserPassword
    }
  }
}]
