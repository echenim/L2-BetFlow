// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract Settlement is Ownable, Pausable, ReentrancyGuard {
    struct Bet {
        address bettor;
        uint256 amount;
        bool outcome;
        bool settled;
    }

    mapping(string => Bet[]) public eventBets;
    mapping(address => uint256) public balances;

    address public admin;
    address public oracle;
    uint256 public constant OWNER_CHANGE_DELAY = 2 days;
    uint256 public changeOwnerRequestTime;
    address public pendingOwner;

    event BetPlaced(
        address indexed bettor,
        string eventId,
        uint256 amount,
        bool outcome
    );
    event BetSettled(
        address indexed bettor,
        string eventId,
        uint256 amount,
        bool won
    );
    event Withdrawn(address indexed bettor, uint256 amount);
    event OwnershipTransferRequested(
        address indexed newOwner,
        uint256 timestamp
    );
    event OracleChanged(address indexed newOracle);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can call this function");
        _;
    }

    modifier onlyOracle() {
        require(msg.sender == oracle, "Only oracle can call this function");
        _;
    }

    constructor(address _oracle) {
        admin = msg.sender;
        oracle = _oracle;
    }

    function placeBet(
        string memory _eventId,
        bool _outcome
    ) public payable whenNotPaused nonReentrant {
        require(msg.value > 0, "Bet amount must be greater than zero");

        Bet memory newBet = Bet({
            bettor: msg.sender,
            amount: msg.value,
            outcome: _outcome,
            settled: false
        });

        eventBets[_eventId].push(newBet);
        emit BetPlaced(msg.sender, _eventId, msg.value, _outcome);
    }

    function settleBet(
        string memory _eventId,
        bool _outcome
    ) public onlyOracle whenNotPaused {
        Bet[] storage bets = eventBets[_eventId];
        uint256 totalBets = bets.length;
        require(totalBets > 0, "No bets to settle for this event");

        for (uint256 i = 0; i < totalBets; i++) {
            Bet storage bet = bets[i];
            if (!bet.settled) {
                if (bet.outcome == _outcome) {
                    uint256 winnings = bet.amount * 2;
                    balances[bet.bettor] += winnings;
                    emit BetSettled(bet.bettor, _eventId, winnings, true);
                } else {
                    emit BetSettled(bet.bettor, _eventId, bet.amount, false);
                }
                bet.settled = true;
            }
        }
    }

    function withdraw() public nonReentrant {
        uint256 amount = balances[msg.sender];
        require(amount > 0, "No balance to withdraw");

        balances[msg.sender] = 0;
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Transfer failed");

        emit Withdrawn(msg.sender, amount);
    }

    function emergencyWithdraw() public whenPaused nonReentrant {
        uint256 amount = balances[msg.sender];
        require(amount > 0, "No balance to withdraw");

        balances[msg.sender] = 0;
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Transfer failed");

        emit Withdrawn(msg.sender, amount);
    }

    function pause() public onlyAdmin {
        _pause();
    }

    function unpause() public onlyAdmin {
        _unpause();
    }

    function changeOracle(address newOracle) public onlyOwner {
        require(
            newOracle != address(0),
            "New oracle cannot be the zero address"
        );
        oracle = newOracle;
        emit OracleChanged(newOracle);
    }

    function requestOwnershipTransfer(address newOwner) public onlyOwner {
        require(newOwner != address(0), "New owner cannot be the zero address");
        pendingOwner = newOwner;
        changeOwnerRequestTime = block.timestamp;
        emit OwnershipTransferRequested(newOwner, block.timestamp);
    }

    function confirmOwnershipTransfer() public {
        require(
            msg.sender == pendingOwner,
            "Only the pending owner can confirm ownership transfer"
        );
        require(
            block.timestamp >= changeOwnerRequestTime + OWNER_CHANGE_DELAY,
            "Ownership transfer delay not met"
        );
        _transferOwnership(pendingOwner);
    }

    function getEventBets(
        string memory _eventId
    ) public view returns (Bet[] memory) {
        return eventBets[_eventId];
    }

    function getUserBalance() public view returns (uint256) {
        return balances[msg.sender];
    }

    function changeAdmin(address newAdmin) public onlyOwner {
        require(newAdmin != address(0), "New admin cannot be the zero address");
        admin = newAdmin;
    }

    receive() external payable {}
    fallback() external payable {}
}
