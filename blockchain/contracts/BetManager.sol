// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Betting is ReentrancyGuard, Ownable {
    using SafeMath for uint256;

    // Structs
    struct Bet {
        address payable bettor;
        uint256 amount;
        string outcome;
        bool settled;
    }

    struct Game {
        string description;
        string[] outcomes;
        bool active;
        mapping(string => uint256) outcomeBets;
        mapping(address => Bet) bets;
    }

    // State variables
    uint256 public gameIdCounter;
    mapping(uint256 => Game) public games;
    address public arbitrator;

    // Events
    event GameCreated(uint256 gameId, string description, string[] outcomes);
    event BetPlaced(
        uint256 gameId,
        address bettor,
        string outcome,
        uint256 amount
    );
    event BetSettled(
        uint256 gameId,
        address bettor,
        string outcome,
        uint256 payout
    );
    event DisputeRaised(uint256 gameId, address bettor, string reason);
    event ArbitratorSet(address arbitrator);
    event BetRefunded(uint256 gameId, address bettor, uint256 amount);

    // Modifiers
    modifier gameExists(uint256 gameId) {
        require(gameId < gameIdCounter, "Game does not exist");
        _;
    }

    modifier gameIsActive(uint256 gameId) {
        require(games[gameId].active, "Game is not active");
        _;
    }

    modifier betExists(uint256 gameId) {
        require(
            games[gameId].bets[msg.sender].amount > 0,
            "Bet does not exist"
        );
        _;
    }

    // Constructor
    constructor(address _arbitrator) {
        arbitrator = _arbitrator;
    }

    // Functions
    function setArbitrator(address _arbitrator) public onlyOwner {
        arbitrator = _arbitrator;
        emit ArbitratorSet(_arbitrator);
    }

    function createGame(
        string memory description,
        string[] memory outcomes
    ) public onlyOwner {
        Game storage game = games[gameIdCounter];
        game.description = description;
        game.outcomes = outcomes;
        game.active = true;

        emit GameCreated(gameIdCounter, description, outcomes);
        gameIdCounter++;
    }

    function placeBet(
        uint256 gameId,
        string memory outcome
    ) public payable gameExists(gameId) gameIsActive(gameId) nonReentrant {
        require(msg.value > 0, "Bet amount must be greater than zero");

        Game storage game = games[gameId];
        require(game.bets[msg.sender].amount == 0, "Bet already placed");

        game.bets[msg.sender] = Bet(
            payable(msg.sender),
            msg.value,
            outcome,
            false
        );
        game.outcomeBets[outcome] = game.outcomeBets[outcome].add(msg.value);

        emit BetPlaced(gameId, msg.sender, outcome, msg.value);
    }

    function settleBet(
        uint256 gameId,
        string memory winningOutcome
    ) public onlyOwner gameExists(gameId) nonReentrant {
        Game storage game = games[gameId];
        game.active = false;

        uint256 totalBets = game.outcomeBets[winningOutcome];
        for (uint256 i = 0; i < gameIdCounter; i++) {
            Bet storage bet = game.bets[gameId];
            if (
                keccak256(abi.encodePacked(bet.outcome)) ==
                keccak256(abi.encodePacked(winningOutcome)) &&
                !bet.settled
            ) {
                uint256 payout = bet.amount.mul(address(this).balance).div(
                    totalBets
                );
                bet.bettor.transfer(payout);
                bet.settled = true;

                emit BetSettled(gameId, bet.bettor, bet.outcome, payout);
            }
        }
    }

    function raiseDispute(
        uint256 gameId,
        string memory reason
    ) public gameExists(gameId) betExists(gameId) {
        emit DisputeRaised(gameId, msg.sender, reason);
    }

    function resolveDispute(
        uint256 gameId,
        address payable bettor,
        bool refund
    ) public {
        require(
            msg.sender == arbitrator,
            "Only the arbitrator can resolve disputes"
        );

        Bet storage bet = games[gameId].bets[bettor];
        require(!bet.settled, "Bet already settled");

        if (refund) {
            bettor.transfer(bet.amount);
            bet.settled = true;
            emit BetRefunded(gameId, bettor, bet.amount);
        }
    }

    function withdrawFunds() public onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }
}
