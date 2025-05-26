# SUI VOTING SYSTEM

This is a simple voting system built using sui move.


## To run the program

```
sui move build 
```

``` 
sui client publish --gas-budget 50000000
```


NOTE: The Object Id is the ObejctId under Created Objects

## The different functions

1. Create a Proposal: 
    Call create_proposal to create a shared Proposal object:

    ```
    sui client call --package <PACKAGE_ID> --module voting --function create_proposal --args '"Test Proposal"' --gas-budget 10000000
    ```

2. Register a Voter: 
Call register_voter to create a Voter object owned by your address:

    ```
    sui client call --package <PACKAGE_ID> --module voting --function register_voter --gas-budget 10000000
    ```

3. Cast a Vote: 
    Call vote to vote on the proposal:

    ```
    sui client call --package <PACKAGE_ID> --module voting --function vote --args <PROPOSAL_ID> <VOTER_ID> true --gas-budget 10000000
    ```

4. Inspect the Proposal: 
Check the proposal’s state (votes):

    ```
    sui client object <PROPOSAL_ID>
    ```
