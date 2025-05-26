#[allow(duplicate_alias)]
module voting_system::voting {
    use sui::tx_context::TxContext;
    use sui::object::UID;
    use sui::transfer;

    public struct Proposal has key, store {
        id: UID,
        description: vector<u8>,
        votes_for: u64,
        votes_against: u64,
    }

    public struct Voter has key, store {
        id: UID,
        has_voted: bool,
    }

    /// Creates a new proposal
    public entry fun create_proposal(
        description: vector<u8>,
        ctx: &mut TxContext
    ) {
        let proposal = Proposal {
            id: object::new(ctx),
            description,
            votes_for: 0,
            votes_against: 0
        };
        transfer::share_object(proposal);
    }

    /// Create a new voter
    public entry fun register_voter(
        ctx: &mut TxContext
    ) {
        let voter = Voter {
            id: object::new(ctx),
            has_voted: false
        };
        transfer::transfer(voter, tx_context::sender(ctx));
    }

    /// Cast a vote
    public entry fun vote(
        proposal: &mut Proposal,
        voter: &mut Voter,
        vote_for: bool
    ) {
        assert!(!voter.has_voted, 0);
        if (vote_for) {
            proposal.votes_for = proposal.votes_for + 1;
        } else {
            proposal.votes_against = proposal.votes_against + 1;
        };
        voter.has_voted = true;
    }

    /// Get result
    public fun get_result(proposal: &Proposal): vector<u8> {
        if (proposal.votes_for > proposal.votes_against) {
            b"Accepted"
        } else if (proposal.votes_for < proposal.votes_against) {
            b"Rejected"
        } else {
            b"Tie"
        }
    }
}