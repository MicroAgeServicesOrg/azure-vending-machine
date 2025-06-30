targetScope= 'subscription'

param backupRGName string
param vaultName string
param location string


resource backupResourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: backupRGName
  location: location
}


module vault 'br/public:avm/res/recovery-services/vault:0.9.1' = {
  scope: backupResourceGroup
  name: 'vaultDeployment'
  params: {
    // Required parameters
    name: vaultName
    // Non-required parameters
    backupConfig: {
      enhancedSecurityState: 'Disabled'
      softDeleteFeatureState: 'Disabled'
    }
    backupPolicies: [
      {
        name: 'vmDefaultPolicy'
        properties: {
          backupManagementType: 'AzureIaasVM'
          instantRPDetails: {}
          instantRpRetentionRangeInDays: 2
          policyType: 'V2'
          protectedItemsCount: 0
          retentionPolicy: {
            dailySchedule: {
              retentionDuration: {
                count: 7
                durationType: 'Days'
              }
              retentionTimes: [
                '2019-11-07T07:00:00Z'
              ]
            }
            monthlySchedule: {
              retentionDuration: {
                count: 12
                durationType: 'Months'
              }
              retentionScheduleFormatType: 'Weekly'
              retentionScheduleWeekly: {
                daysOfTheWeek: [
                  'Sunday'
                ]
                weeksOfTheMonth: [
                  'First'
                ]
              }
              retentionTimes: [
                '2019-11-07T07:00:00Z'
              ]
            }
            retentionPolicyType: 'LongTermRetentionPolicy'
            weeklySchedule: {
              daysOfTheWeek: [
                'Sunday'
              ]
              retentionDuration: {
                count: 4
                durationType: 'Weeks'
              }
              retentionTimes: [
                '2019-11-07T07:00:00Z'
              ]
            }
            yearlySchedule: {
              monthsOfYear: [
                'December'
              ]
              retentionDuration: {
                count: 2
                durationType: 'Years'
              }
              retentionScheduleFormatType: 'Weekly'
              retentionScheduleWeekly: {
                daysOfTheWeek: [
                  'Sunday'
                ]
                weeksOfTheMonth: [
                  'First'
                ]
              }
              retentionTimes: [
                '2019-11-07T07:00:00Z'
              ]
            }
          }
          schedulePolicy: {
            schedulePolicyType: 'SimpleSchedulePolicyV2'
            scheduleRunFrequency: 'Daily'
            dailySchedule: {
              scheduleRunTimes: [
                '2019-11-07T07:00:00Z'
              ]
            }
          }
          tieringPolicy: {
            ArchivedRP: {
              tieringMode: 'TierRecommended'
            }
          }
          timeZone: 'UTC'
        }
      }
      {
        name: 'sqlDefaultPolicy'
        properties: {
          backupManagementType: 'AzureWorkload'
          protectedItemsCount: 0
          settings: {
            isCompression: true
            issqlcompression: true
            timeZone: 'UTC'
          }
          subProtectionPolicy: [
            {
              policyType: 'Full'
              retentionPolicy: {
                monthlySchedule: {
                  retentionDuration: {
                    count: 12
                    durationType: 'Months'
                  }
                  retentionScheduleFormatType: 'Weekly'
                  retentionScheduleWeekly: {
                    daysOfTheWeek: [
                      'Sunday'
                    ]
                    weeksOfTheMonth: [
                      'First'
                    ]
                  }
                  retentionTimes: [
                    '2019-11-07T22:00:00Z'
                  ]
                }
                retentionPolicyType: 'LongTermRetentionPolicy'
                weeklySchedule: {
                  daysOfTheWeek: [
                    'Sunday'
                  ]
                  retentionDuration: {
                    count: 4
                    durationType: 'Weeks'
                  }
                  retentionTimes: [
                    '2019-11-07T22:00:00Z'
                  ]
                }
                yearlySchedule: {
                  monthsOfYear: [
                    'December'
                  ]
                  retentionDuration: {
                    count: 2
                    durationType: 'Years'
                  }
                  retentionScheduleFormatType: 'Weekly'
                  retentionScheduleWeekly: {
                    daysOfTheWeek: [
                      'Sunday'
                    ]
                    weeksOfTheMonth: [
                      'First'
                    ]
                  }
                  retentionTimes: [
                    '2019-11-07T22:00:00Z'
                  ]
                }
              }
              schedulePolicy: {
                schedulePolicyType: 'SimpleSchedulePolicy'
                scheduleRunDays: [
                  'Sunday'
                ]
                scheduleRunFrequency: 'Weekly'
                scheduleRunTimes: [
                  '2019-11-07T22:00:00Z'
                ]
                scheduleWeeklyFrequency: 0
              }
            }
            {
              policyType: 'Differential'
              retentionPolicy: {
                retentionDuration: {
                  count: 15
                  durationType: 'Days'
                }
                retentionPolicyType: 'SimpleRetentionPolicy'
              }
              schedulePolicy: {
                schedulePolicyType: 'SimpleSchedulePolicy'
                scheduleRunDays: [
                  'Monday'
                ]
                scheduleRunFrequency: 'Weekly'
                scheduleRunTimes: [
                  '2017-03-07T02:00:00Z'
                ]
                scheduleWeeklyFrequency: 0
              }
            }
            {
              policyType: 'Log'
              retentionPolicy: {
                retentionDuration: {
                  count: 15
                  durationType: 'Days'
                }
                retentionPolicyType: 'SimpleRetentionPolicy'
              }
              schedulePolicy: {
                scheduleFrequencyInMins: 120
                schedulePolicyType: 'LogSchedulePolicy'
              }
            }
          ]
          workLoadType: 'SQLDataBase'
          tieringPolicy: {
            ArchivedRP: {
              tieringMode: 'TierAfter'
              duration: 60
              durationType: 'Days'

            }
          }
        }
      }
      {
        name: 'fileDefaultPolicy'
          properties: {
            backupManagementType: 'AzureStorage'
            protectedItemsCount: 0
            vaultRetentionPolicy: {
              snapshotRetentionInDays: 5
              vaultRetention: {
                retentionPolicyType: 'LongTermRetentionPolicy'
                dailySchedule: {
                  retentionDuration: {
                    count: 30
                    durationType: 'Days'
                  }
                  retentionTimes: [
                    '2019-11-07T04:30:00Z'
                  ]
                }
              }
            }
            schedulePolicy: {
              schedulePolicyType: 'SimpleSchedulePolicy'
              scheduleRunFrequency: 'Daily'
              scheduleRunTimes: [
                '2019-11-07T04:30:00Z'
              ]
              scheduleWeeklyFrequency: 0
            }
            timeZone: 'UTC'
            workloadType: 'AzureFileShare'
          }
      }
    ]
  }
}

output vaultId string = vault.outputs.resourceId
