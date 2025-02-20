using './main.bicep'

param addsSubnetId = ''
param location = ''
param dcPrefix = ''
param adminPassword = ''
param dcCount = 2
param zones = [
  1
  2
  3
]
param domainName = ''
param domainSiteName = ''
param domainAdminUsername = ''
param domainAdminPassword = ''
param safeModeUsername = ''
param safeModePassword = ''

