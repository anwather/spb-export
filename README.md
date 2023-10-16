# Sovereign Landing Zone (SLZ) - Sovereignty Policy Baseline

Policies from the [Sovereignty Policy Baseline](https://github.com/Azure/sovereign-landing-zone/blob/main/docs/scenarios/Sovereignty-Policy-Baseline.md) project extracted for use in [EPAC](https://aka.ms/epac).

## Usage

- Copy the files from the ```Definitions``` folder to your own EPAC repo.
- Adjust the following fields in the assignment files to suit your environment.
    - ```scope```
    - ```managedIdentityLocations```
    - ```parameters```

## Caveats

- Policies are tested by the owners of the Sovereign Landing Zone repositories - for issues with the policies or assignments please refer to the original [project](https://github.com/Azure/sovereign-landing-zone/tree/main).
- Deploying the SLZ also includes the ALZ policies - you can synchronise these using EPAC - ```Sync-ALZPolicies```. The policies extracted here **do not** include the ALZ deployed policies. 
- The assignment files assumes an SLZ recommended management group structure - as described in [this link](https://github.com/Azure/sovereign-landing-zone/blob/main/docs/02-Architecture.md).
