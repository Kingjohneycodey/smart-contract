module voting_system::voting {

    use std::vector;
    use sui::tx_context::{Self, TxContext};
    use sui::object::{Self, UID};
    use sui::address::Address;

    /// Represents a proposal people can vote on.
    struct Proposal has key {
        id: UID,
        title: vector<u8>,
        description: vector<u8>,
        votes_for: u64,
        votes_against: u64,
        voters: vector<Address>,
    }

    /// Public entry to create a new proposal
    public entry fun create_proposal(
        title: vector<u8>,
        description: vector<u8>,
        ctx: &mut TxContext
    ): Proposal {
        let id = object::new(ctx);
        Proposal {
            id,
            title,
            description,
            votes_for: 0,
            votes_against: 0,
            voters: vector::empty(),
        }
    }

    /// Vote on a proposal
    public entry fun vote(
        proposal: &mut Proposal,
        vote_for: bool,
        ctx: &mut TxContext
    ) {
        let sender = TxContext::sender(ctx);

        // Check if already voted
        let mut i = 0;
        let voters = &mut proposal.voters;
        while (i < vector::length(voters)) {
            let v = *vector::borrow(voters, i);
            assert!(v != sender, 0); // already voted
            i = i + 1;
        }

        // Add voter
        vector::push_back(voters, sender);

        // Register vote
        if (vote_for) {
            proposal.votes_for = proposal.votes_for + 1;
        } else {
            proposal.votes_against = proposal.votes_against + 1;
        }
    }

    /// View result of voting
    public fun get_result(proposal: &Proposal): u8 {
        if (proposal.votes_for > proposal.votes_against) {
            1 // Passed
        } else if (proposal.votes_for < proposal.votes_against) {
            2 // Failed
        } else {
            0 // Tie
        }
    }
}
